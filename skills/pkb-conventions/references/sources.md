# Sources

Read this when a task **reads from outside the vault** — a calendar, a task list, a Notion inbox. That means `/pkb-morning`, `/pkb-setup`, and the `sources` discussion in `/pkb-commit`. Nothing else needs it.

Some commands read from outside the vault. Sources are **declared in the vault's own `.pkb/config.json`, never hardcoded**, so adding one is a config edit rather than a code change — and the result is committed with the vault rather than stranded on one machine.

```json
{
  "name": "Brain",
  "sources": [
    { "id": "vault-inbox", "kind": "vault", "label": "Vault inbox", "path": "00-inbox", "enabled": true },
    { "id": "workboard", "kind": "vault", "label": "Workboard", "path": "10-workboard/workboard.md", "enabled": true },
    { "id": "calendar", "kind": "mcp", "label": "Today's calendar", "tool": "mcp__google-calendar__list_events", "args": { "timeMin": "$TODAY_START", "timeMax": "$TODAY_END" }, "enabled": true },
    { "id": "notion-inbox", "kind": "mcp", "label": "Notion inbox", "tool": "mcp__notion__search", "args": {}, "enabled": false },
    { "id": "tasks", "kind": "command", "label": "Google Tasks", "command": "gtsk list --json", "env": { "GTSK_TOKEN": "$SECRET:gtsk_token" }, "enabled": false }
  ]
}
```

Three kinds, and that is deliberately the whole vocabulary:

| `kind`    | Reads from                    | Needs                            |
| --------- | ----------------------------- | -------------------------------- |
| `vault`   | A path inside the vault       | Nothing. Always available.       |
| `mcp`     | An MCP tool, by name          | That MCP server to be connected. |
| `command` | A shell command's stdout      | The command to exist.            |

**Credentials never appear in this file, because this file is committed.** A `command` source that needs auth names the secret instead of holding it: `"$SECRET:gtsk_token"` resolves at read time from the `secrets` map in the machine-local config and is passed to the command as an environment variable. It is never written back into the vault, and never echoed. An `mcp` source needs no secrets at all — auth belongs to the MCP server.

If you ever find a literal token in `<root>/.pkb/config.json`, stop and say so. The file is in git, and a pushed secret is a leaked secret — moving it to the machine config is the fix, plus rotating it if it was already pushed.

**Sources are read-only.** Nothing here writes back to a source — do not mark a Notion row processed, complete a remote task, or send mail. That would re-create the two-way sync problem this whole design avoids. When something is handled, record it in the vault.

**`mcp` tool names are installation-specific.** They come from whichever servers the user has connected, and `/mcp` lists them. Never guess a name that looks adjacent — report it missing and point at `/mcp`.

**Substitutions** available in `args` and `command`: `$TODAY`, `$NOW`, `$TODAY_START`, `$TODAY_END`, `$VAULT`. Resolve them before running anything. `$SECRET:<key>` is the one exception — it appears only inside a source's `env` map, resolves from the machine-local `secrets`, and must never be printed, logged, or committed.

**A source that fails is not a source that is empty.** Anything reading a source must report `ok`, `empty`, or `failed` per source, and never let a failure pass as silence. A briefing that silently drops the user's calendar is worse than one that admits it could not reach it.
