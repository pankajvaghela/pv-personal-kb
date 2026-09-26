---
description: Show, add to, or complete items on the PKB workboard
argument-hint: [show | add <item> | done <item> | drop <item>]
allowed-tools: Read, Edit
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then work with `<root>/10-workboard/workboard.md`.

Request: $ARGUMENTS

**`show`** (or empty) — print the `## Now` section in full, then just the count of items in `Next`, `Waiting`, and `Someday`. Flag anything with a `📅` date that is past due or within three days.

**`add <item>`** — place it under the correct horizon:
- `Now` — you are actively on it this week
- `Next` — committed, not started
- `Waiting` — blocked on a person or an external event (name them in the line)
- `Someday` — no commitment

Keep inline metadata to a trailing `#tag` and/or `📅 YYYY-MM-DD`. One line per action, action-first phrasing, no sub-bullets.

**`done <item>`** — mark it `- [x]` in place. Do not move it. `/review` sweeps checked items out.

**`drop <item>`** — ask why, then either delete the line (if it was never real) or move it to `Someday`. Never silently discard.

The file must stay **literal GFM task lists** — no Dataview, no query-only views. You should be able to read and edit this file on a phone, in a terminal, or in any text editor.

If the request is ambiguous about which item, list the close matches and ask. Otherwise make the edit and confirm in one line.
