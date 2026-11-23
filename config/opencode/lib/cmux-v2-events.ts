type RecordValue = Record<string, unknown>;

export type LegacyEvent = {
  type: string;
  properties: RecordValue;
};

const asRecord = (value: unknown): RecordValue =>
  value !== null && typeof value === "object" && !Array.isArray(value)
    ? (value as RecordValue)
    : {};

const asString = (value: unknown): string | undefined =>
  typeof value === "string" ? value : undefined;

const legacyEvent = (type: string, properties: RecordValue): LegacyEvent => ({
  type,
  properties,
});

function messageEvents(
  sessionID: string,
  messageID: string,
  role: "assistant" | "user",
  text: string,
): LegacyEvent[] {
  return [
    legacyEvent("message.updated", {
      info: { id: messageID, sessionID, role },
    }),
    legacyEvent("message.part.updated", {
      part: { type: "text", messageID, text },
    }),
  ];
}

export function toV1Events(
  value: unknown,
  messageText: Map<string, string>,
): LegacyEvent[] {
  const event = asRecord(value);
  const data = asRecord(event.data);
  const location = asRecord(event.location);
  const sessionID = asString(data.sessionID);
  const directory =
    asString(location.directory) ?? asString(asRecord(data.location).directory);

  switch (event.type) {
    case "session.created":
      return sessionID
        ? [
            legacyEvent("session.created", {
              info: { id: sessionID, directory },
            }),
          ]
        : [];
    case "session.archived":
      return sessionID
        ? [
            legacyEvent("session.updated", {
              info: {
                id: sessionID,
                directory,
                time: { archived: true },
              },
            }),
          ]
        : [];
    case "session.unarchived":
      return sessionID
        ? [
            legacyEvent("session.updated", {
              info: { id: sessionID, directory },
            }),
          ]
        : [];
    case "session.deleted":
    case "session.idle":
      return sessionID
        ? [legacyEvent(event.type, { sessionID, info: { id: sessionID } })]
        : [];
    case "session.status":
      return sessionID
        ? [legacyEvent("session.status", { sessionID, status: data.status })]
        : [];
    case "session.text.started": {
      const messageID = asString(data.assistantMessageID);
      if (!sessionID || !messageID) return [];
      messageText.set(messageID, "");
      return [
        legacyEvent("message.updated", {
          info: { id: messageID, sessionID, role: "assistant" },
        }),
      ];
    }
    case "session.text.delta": {
      const messageID = asString(data.assistantMessageID);
      const delta = asString(data.delta);
      if (!sessionID || !messageID || delta === undefined) return [];
      const text = (messageText.get(messageID) ?? "") + delta;
      messageText.set(messageID, text);
      while (messageText.size > 300) {
        const oldest = messageText.keys().next().value;
        if (oldest === undefined) break;
        messageText.delete(oldest);
      }
      return messageEvents(sessionID, messageID, "assistant", text);
    }
    case "session.text.ended": {
      const messageID = asString(data.assistantMessageID);
      if (!sessionID || !messageID) return [];
      const text = asString(data.text) ?? messageText.get(messageID) ?? "";
      messageText.set(messageID, text);
      return messageEvents(sessionID, messageID, "assistant", text);
    }
    case "session.inbox.enqueued": {
      if (!sessionID || data.inboxID === undefined) return [];
      const item = asRecord(data.item);
      if (item.type !== "user") return [];
      const text = asString(asRecord(item.payload).text);
      if (text === undefined) return [];
      return messageEvents(sessionID, String(data.inboxID), "user", text);
    }
    case "session.tool.called": {
      const toolID = asString(data.id)?.toLowerCase().replaceAll(/[-_]/g, "");
      if (!sessionID || toolID !== "todowrite") return [];
      const input = asRecord(data.input);
      return [
        legacyEvent("todo.updated", {
          sessionID,
          todos: input.todos ?? data.input,
        }),
      ];
    }
    case "permission.asked":
      return [
        legacyEvent("permission.asked", {
          ...data,
          permission: data.action,
          patterns: data.resources,
          always: data.save,
          tool: { name: data.action },
        }),
      ];
    default:
      return [];
  }
}
