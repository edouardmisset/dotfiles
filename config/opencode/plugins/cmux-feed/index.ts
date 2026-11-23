import { Plugin } from "@opencode/plugin";
import { CMUXFeed } from "../cmux-feed.js";
import { toV1Events } from "../../lib/cmux-v2-events";

type LegacyPermissionReply = {
  requestID: string;
  reply: "once" | "always" | "reject";
  message?: string;
};

type LegacySessionUpdate = {
  path: { id: string };
  body: {
    permission?: Array<{
      permission: string;
      pattern: string;
      action: "allow" | "deny" | "ask";
    }>;
  };
};

type LegacyPrompt = {
  path: { id: string };
  body: {
    parts?: Array<{ text?: string }>;
  };
};

export default Plugin.define({
  id: "cmux.feed",
  async setup(ctx) {
    const pendingPermissionSessions = new Map<string, string>();
    const legacy = await CMUXFeed({
      directory: ctx.location.directory,
      worktree: ctx.location.directory,
      client: {
        permission: {
          reply: async ({ requestID, reply, message }: LegacyPermissionReply) => {
            const sessionID = pendingPermissionSessions.get(requestID);
            if (!sessionID) {
              throw new Error(`Unknown OpenCode permission request: ${requestID}`);
            }
            await ctx.permission.reply({
              sessionID,
              requestID,
              decision: reply,
              message,
            });
            pendingPermissionSessions.delete(requestID);
          },
        },
        session: {
          update: async ({ path, body }: LegacySessionUpdate) => {
            const permissions = (body.permission ?? []).map((rule) => ({
              action:
                rule.permission === "bash"
                  ? "shell"
                  : rule.permission === "write" || rule.permission === "patch"
                    ? "edit"
                    : rule.permission,
              resource: rule.pattern,
              effect: rule.action,
            }));
            await ctx.session.update({ sessionID: path.id, permissions });
          },
          promptAsync: async ({ path, body }: LegacyPrompt) => {
            const text = (body.parts ?? [])
              .map((part) => part.text ?? "")
              .filter(Boolean)
              .join("\n");
            if (!text.trim()) {
              throw new Error("Cannot submit an empty cmux plan prompt");
            }
            await ctx.session.prompt({ sessionID: path.id, text });
          },
        },
      },
    });
    if (typeof legacy.event !== "function") return;

    const controller = new AbortController();
    const messageText = new Map<string, string>();

    void (async () => {
      try {
        for await (const event of ctx.event.subscribe({
          signal: controller.signal,
        })) {
          for (const bridged of toV1Events(event, messageText)) {
            if (bridged.type === "permission.asked") {
              const { id, sessionID } = bridged.properties;
              if (typeof id === "string" && typeof sessionID === "string") {
                pendingPermissionSessions.set(id, sessionID);
              }
            }
            try {
              await legacy.event({ event: bridged });
            } catch (error) {
              console.error("cmux feed plugin event failed", error);
            }
          }
        }
      } catch (error) {
        if (!controller.signal.aborted) {
          console.error("cmux feed plugin event stream failed", error);
        }
      }
    })();

    // V2 exposes forms but no server-plugin form reply API, so legacy Q&A and plan-exit events cannot be bridged.
    return () => controller.abort();
  },
});
