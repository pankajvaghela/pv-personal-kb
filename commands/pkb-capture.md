---
description: Capture a thought into the PKB inbox with zero ceremony
argument-hint: <the thought, link, or thing to remember>
allowed-tools: Read, Write, Edit
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then capture this into the inbox: $ARGUMENTS

Friction is the enemy here — this command exists so that capturing never requires a decision.

1. Target file: `<root>/00-inbox/<today's date>.md` (ISO, e.g. `2026-09-26.md`). Create it if absent with `type: inbox` frontmatter.
2. Append the thought as a `- HH:MM` bullet. If the input is multi-line or clearly has structure, keep that structure beneath the bullet rather than flattening it.
3. Do **not** classify, tag, retitle, or move anything. Do not guess a destination. Triage is a separate, deliberate act.
4. If the input contains a URL or a file reference, keep it verbatim.

If `$ARGUMENTS` is empty, ask for the thought in one line — nothing else. Then stop.

Reply with a single line: what you captured and the file it landed in. No commentary, no suggestions.
