# pv-personal-kb

A Claude Code plugin that sets up and runs a personal knowledge base as a **plain folder of Markdown files**.

No database, no server, no sync service. Your notes are `.md` files with YAML frontmatter that you can grep in a terminal, diff in git, and still open in ten years. Claude gets commands for the things that are annoying to do by hand — capturing without ceremony, filing an inbox, keeping a workboard honest — and a conventions skill so it files things the same way every time instead of inventing a structure.

## Markdown is the format. Everything else is a view of it.

The vault is a directory of text files. **Nothing here requires Obsidian** — no command reads or writes Obsidian state, and the plugin never touches `.obsidian/`. Open it in whatever you like: Obsidian, VS Code, iA Writer, GitHub, `less`.

| | |
|---|---|
| **Required** | `.md` files, YAML frontmatter, plain directories, GFM checkboxes, `[[wiki-links]]` |
| **Pick any** | A Markdown viewer. Obsidian is a good one — it renders the wiki-links and draws the graph — but it's one option, not a requirement. |
| **App-specific, optional** | Dataview, callouts, embeds, the `📅` task marker |

Two honest caveats, both in the conventions skill: `[[wiki-links]]` are not CommonMark, so GitHub shows them as literal text — though Foam, Logseq, Dendron, and Quartz all read them. And the `📅` date marker on workboard lines is an Obsidian Tasks convention that means nothing elsewhere, which is why the date is always also readable as plain text.

Templates use Obsidian's `{{title}}` and `{{date:YYYY-MM-DD}}` variables. That is the one place the scaffold speaks Obsidian — a deliberate convenience for the Templates plugin. Claude substitutes those variables itself, so `/pkb-new-project` and `/pkb-new-person` produce correct notes with or without Obsidian installed.

## Install

```bash
claude plugin marketplace add pankajvaghela/pv-personal-kb
claude plugin install pv-personal-kb@pankajvaghela
```

Then, in any session:

```
/pkb-setup
```

It asks where the vault should live and what to call it, scaffolds the folders, and writes a config. You can put the vault anywhere — the plugin reads the path from `~/.config/pv-personal-kb/config.json` and never hardcodes one.

Set up more than one vault by re-running `/pkb-setup` and pointing it somewhere else.

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

The numbers are **attention order, not hierarchy**. The folders you touch most sort to the top of any file listing.

## Commands

| Command | Does |
|---|---|
| `/pkb-setup` | Create a vault, or point the plugin at a different one. |
| `/pkb-capture <thing>` | Throw something into the inbox. No decisions, no sorting. |
| `/pkb-triage` | File inbox items into the right folders — shows a plan first. |
| `/pkb-workboard` | Show, add, complete, or drop action items. |
| `/pkb-new-project <name>` | Start a project note from the template. |
| `/pkb-new-person <name>` | Create or update a person note — searches for a duplicate first. |
| `/pkb-review` | Weekly sweep: inbox count, stale projects, orphan notes, broken links. |
| `/pkb-commit` | Snapshot the vault to git, with a secret check before staging. |

Plus a `pkb-librarian` agent for bulk work — filing a large backlog, repairing links after a rename, hunting duplicates.

## Design choices

**Local files are the source of truth.** There is no mirror and no sync, because a sync is a second place for the truth to live, and reconciling two truths is the expensive part. If you want your notes on another device, that is what git is for.

**Never delete, archive.** `90-archive/` is what makes this affordable — a dead project keeps its inbound links, and the vault stays navigable.

**The folders are the schema.** Structure goes in the directory tree, not in frontmatter. A field that no query consumes is a small lie you have to keep maintaining.

**One note = one topic.** Filenames are wiki-link targets, so a rename breaks every inbound link. The conventions require repairing links in the same pass.

**Capture and sorting are separate acts.** `/pkb-capture` never asks a question. `/pkb-triage` is where the judgment happens, and it proposes before it moves anything.

**The workboard is literal checkboxes.** Readable and editable as plain text on a phone, in a terminal, in any editor. A Dataview view on top is fine; a Dataview-only workboard is not.

**Wiki-links, and why.** `[[Note Title]]` isn't CommonMark, so GitHub shows it as literal text. It's still the right default: it's the shared convention across file-based PKM tools, and it needs only the note's *filename* rather than a relative path — which matters a lot when an AI is writing the link, since a guessed path fails silently and a filename is either right or obviously missing. Switching to `[Note](Note.md)` is a mechanical conversion if you'd rather have GitHub-native rendering; decide while the vault is small.

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

## If you happen to use Obsidian

*Open folder as vault* → pick your vault path. That's all there is to it — the vault works identically in any other editor, and this section exists because Obsidian users expect setup steps, not because the plugin needs them.

To let the Templates plugin fill templates in for you, set **Template folder location** to `templates/` under Settings → **Files & Links**; the `{{title}}` and `{{date:YYYY-MM-DD}}` variables will then be substituted on insert. Notes created by the commands are correct either way, because Claude substitutes them itself.

## Requirements

Claude Code. That's it. `git` is only needed for `/pkb-commit`, and Obsidian is just one of many ways to look at the result.

## License

MIT
