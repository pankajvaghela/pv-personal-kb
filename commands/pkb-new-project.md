---
description: Start a new project note in the PKB
argument-hint: <project name>
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then start a project: $ARGUMENTS

1. **Ask before creating** — at most two questions: the outcome (what "done" looks like) and the target date. If the user does not care, leave the date empty rather than inventing one.
2. **Create** `<root>/50-projects/<slug>/<Project Name>.md` from `<root>/templates/project.md`. The template uses Obsidian variables (`{{title}}`, `{{date:YYYY-MM-DD}}`) — substitute them yourself, and never let a literal `{{...}}` reach a finished note. Leave fields you have no answer for empty rather than inventing values. Fill `title`, `type: project`, `status: active`, `created`, `updated`, `outcome`, `due`.
3. **Link** — search `60-people/` and `70-knowledge/` for anything relevant and add wiki-links. Do not create stub people notes; only link to notes that already exist.
4. **Seed the workboard** — add the one obviously-next action to `10-workboard/workboard.md` under `## Now`, tagged `#project/<slug>`.
5. **Report** the path and the file tree you created, in three lines or fewer.

Do not write the project's content for them. Set up the container and stop — the thinking is theirs.
