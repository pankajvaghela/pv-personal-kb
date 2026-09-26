# pv-personal-kb

A Claude Code plugin that sets up and runs a personal knowledge base as a **plain folder of Markdown files**.

No database, no server, no sync service. Your notes are `.md` files with YAML frontmatter that you can read in Obsidian, grep in a terminal, and still open in ten years. Claude gets commands for the things that are annoying to do by hand — capturing without ceremony, filing an inbox, keeping a workboard honest — and a conventions skill so it files things the same way every time instead of inventing a structure.

## Install

```bash
claude plugin marketplace add pankajvaghela/pv-personal-kb
claude plugin install pv-personal-kb@pv
```

Then, in any session:

```
/setup
```

It asks where the vault should live and what to call it, scaffolds the folders, and writes a config. You can put the vault anywhere — the plugin reads the path from `~/.config/pv-personal-kb/config.json` and never hardcodes one.

Set up more than one vault by re-running `/setup` and pointing it somewhere else.

## What you get

```
<your vault>/
├── AGENTS.md            conventions, for any AI or editor working in the vault
├── Home.md              entry note
├── .gitignore           ignores editor state, keeps your config
├── 00-inbox/            unsorted capture — the default landing zone
├── 10-workboard/        action items, as literal task lists
├── 20-goals/            outcomes with a target date
├── 30-lifestyle/        routines, health, habits, home, money
├── 40-travels/          trips, itineraries, places
├── 50-projects/         time-bound efforts, one folder each
├── 60-people/           one note per person
├── 70-knowledge/        evergreen notes and reference
├── 90-archive/          done, dead, dormant — kept so links survive
└── templates/           note skeletons
```

The numbers are **attention order, not hierarchy**. The folders you touch most sit at the top of Obsidian's file list.

## Commands

| Command | Does |
|---|---|
| `/setup` | Create a vault, or point the plugin at a different one. |
| `/capture <thing>` | Throw something into the inbox. No decisions, no sorting. |
| `/triage` | File inbox items into the right folders — shows a plan first. |
| `/workboard` | Show, add, complete, or drop action items. |
| `/new-project <name>` | Start a project note from the template. |
| `/new-person <name>` | Create or update a person note — searches for a duplicate first. |
| `/review` | Weekly sweep: inbox count, stale projects, orphan notes, broken links. |
| `/commit` | Snapshot the vault to git, with a secret check before staging. |

Plus a `pkb-librarian` agent for bulk work — filing a large backlog, repairing links after a rename, hunting duplicates.

## Design choices

**Local files are the source of truth.** There is no mirror and no sync, because a sync is a second place for the truth to live, and reconciling two truths is the expensive part. If you want your notes on another device, that is what git is for.

**Never delete, archive.** `90-archive/` is what makes this affordable — a dead project keeps its inbound links, and the vault stays navigable.

**The folders are the schema.** Structure goes in the directory tree, not in frontmatter. A field that no query consumes is a small lie you have to keep maintaining.

**One note = one topic.** Filenames are wiki-link targets, so a rename breaks every inbound link. The conventions require repairing links in the same pass.

**Capture and sorting are separate acts.** `/capture` never asks a question. `/triage` is where the judgment happens, and it proposes before it moves anything.

**The workboard is literal checkboxes.** Readable and editable as plain text on a phone, in a terminal, in any editor. A Dataview view on top is fine; a Dataview-only workboard is not.

**Obsidian is a viewer, not a dependency.** Callouts, Dataview, and embeds all work — but they are bets on one app, so the conventions prefer plain Markdown where it costs nothing.

## Frontmatter

```yaml
---
title: Human-readable title
type: project | person | trip | lifestyle | goal | note | inbox
status: active | paused | done | archived
created: 2026-09-26
updated: 2026-09-26
tags: []
---
```

Dates are ISO-8601, always. `created` is never rewritten; `updated` changes whenever the note does.

## Using it with Obsidian

*Open folder as vault* → pick your vault path. Then in Settings → **Files & Links**, set **Template folder location** to `templates/`. The templates use `{{title}}` and `{{date:YYYY-MM-DD}}`, which Obsidian's core Templates plugin substitutes on insert.

## Requirements

Claude Code, and optionally Obsidian. `/commit` needs `git`; everything else is plain filesystem work.

## License

MIT
