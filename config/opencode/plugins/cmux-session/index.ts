import { Plugin } from "@opencode/plugin";
import CMUXSessionRestore from "../cmux-session.js";
import { toV1Events } from "../../lib/cmux-v2-events";

export default Plugin.define({
  id: "cmux.session-restore",
  async setup(ctx) {
    const legacy = await CMUXSessionRestore({
      directory: ctx.location.directory,
    });
    if (typeof legacy.event !== "function") return;

    const controller = new AbortController();
    const messageText = new Map<string, string>();

    {
      try {
        for await (const event of ctx.event.subscribe({
          signal: controller.signal,
        })) {
          for (const bridged of toV1Events(event, messageText)) {
            try {
              await legacy.event({ event: bridged });
            } catch (error) {
              console.error("cmux session plugin event failed", error);
            }
          }
        }
      } catch (error) {
        if (!controller.signal.aborted) {
          console.error("cmux session plugin event stream failed", error);
        }
      }
    }

    return () => controller.abort();
  },
});
