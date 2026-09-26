---
description: Create or update a person note in the PKB
argument-hint: <person's name>
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then create or update a person note for: $ARGUMENTS

1. **Search first.** Look in `<root>/60-people/` and grep the vault for the name. If a note exists, append to it instead of creating a second one — a duplicate person note is worse than a thin one.
2. **Create** `<root>/60-people/<Name>.md` from `<root>/templates/person.md` if absent. The template uses Obsidian variables (`{{title}}`, `{{date:YYYY-MM-DD}}`) — substitute them yourself; never write the literal braces into a note. Filename is the full name as you'd say it aloud — that is what wiki-links will target.
3. **Ask at most two things**: how you know them, and anything time-sensitive worth recording now. Skip the interrogation — this note grows over time.
4. **Back-link** — if they came up in a project or trip, add the wiki-link in both directions.

Record only what the user actually tells you. Never infer or fill in details about a real person, and never write assumptions about their role, employer, or relationship.

Confirm in one line with the path.
