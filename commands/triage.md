---
description: File inbox items into the right PKB folders, with confirmation
argument-hint: [optional: a specific inbox file or item to triage]
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then triage the PKB inbox.

Scope: $ARGUMENTS (if empty, triage every file in `<root>/00-inbox/`).

**Step 1 — Read and classify.** Read each inbox item. For each, decide:
- destination path
- final title and filename
- the frontmatter it needs (per the schema)
- which existing notes it should link to (search `70-knowledge/` and relevant folders first — an item that belongs inside an existing note should be appended there, not made a new file)

**Step 2 — Propose.** Present one table: `item → destination → type → reason`. Include a `?` row for anything you cannot confidently place, with a one-line question. Do not act yet.

**Step 3 — Act on confirmation.** Create or append the notes. Add wiki-links in both directions where a relationship is real. Remove each filed item from its inbox file. Delete an inbox file only when it is empty — otherwise leave the remainder intact.

**Step 4 — Sweep.** If an item is an action, add it to `10-workboard/workboard.md` under the right horizon and do not also file it as a note.

Report: items filed by destination, items deferred and why, and any broken wiki-links or near-duplicates you noticed. Keep it to a table plus two or three lines.
