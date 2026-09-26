# Working in this vault

This is a personal knowledge base: plain Markdown files with YAML frontmatter. The files are the source of truth. There is no database and no sync.

**Markdown is the format; every app is just a view of it.** Nothing in this vault requires Obsidian or any other editor, and no tool should depend on one. The vault must read correctly in a text editor, in a terminal, on GitHub, or anywhere else.

If the `pv-personal-kb` plugin is installed, load the `pkb-conventions` skill — it holds the authoritative version of everything below. This file is the fallback for tools that do not have the plugin.

### What is required vs. optional

- **Required:** `.md` files, YAML frontmatter, the folder taxonomy, GFM task lists, `[[wiki-links]]`.
- **Suggested:** a Markdown viewer of your choice. Obsidian is a good one — it renders the links and draws the graph — but it is one option among several, and the vault must never be organized around it.
- **App-specific, optional:** Dataview queries, callouts (`> [!note]`), embeds (`![[Note]]`), and the `📅 YYYY-MM-DD` task marker. Each renders as nothing outside Obsidian.
- Prefer plain Markdown where it costs nothing. Use an app-specific feature when it genuinely earns its keep, but know what it costs.
- `templates/` uses Obsidian's `{{title}}` / `{{date:YYYY-MM-DD}}` variables. Any tool creating a note from one must substitute them — never leave literal braces in a finished note.

`[[wiki-links]]` are not CommonMark — GitHub shows them as literal text. They are the shared convention across file-based PKM tools, and they need only a note's filename rather than a relative path, which is why they are the default here.

## Layout

| Folder | Holds |
|---|---|
| `00-inbox/` | Unsorted capture awaiting triage. The default landing zone. |
| `10-workboard/` | Action items — what is live right now. |
| `20-goals/` | Outcomes with a target date. |
| `30-lifestyle/` | Routines, health, habits, home, money. |
| `40-travels/` | Trips, itineraries, places. |
| `50-projects/` | Time-bound efforts with a finish line. One folder per project. |
| `60-people/` | One note per person. |
| `70-knowledge/` | Evergreen notes and reference. |
| `90-archive/` | Done, dead, or dormant. Kept so links survive. |
| `templates/` | Note skeletons. |

The numeric prefixes encode attention order, not hierarchy.

## Rules

- **One note = one topic.** Filenames are link targets, so a rename breaks inbound links — repair them in the same pass.
- **Never delete.** Archive to `90-archive/`.
- **Never invent a top-level folder.** Propose it instead.
- **Dates are ISO-8601** (`2026-09-26`). Never relative dates in frontmatter.
- **Every note has frontmatter** with at least `title`, `type`, `status`, `created`, `updated`, `tags`.
- **Update `updated`, never `created`.**
- **Templates carry no identity fields** — no dates, no specific titles.

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

Type-specific: `project` gets `owner`/`due`/`outcome`; `person` gets `relationship`/`last_contact`; `trip` gets `start`/`end`/`places`; `goal` gets `target`/`horizon`.

## Workboard

`10-workboard/workboard.md` holds literal GFM task lists under `## Now`, `## Next`, `## Waiting`, `## Someday`. One line per action, trailing `#tag` and `📅 YYYY-MM-DD` are the only inline metadata. Completed items are checked, not deleted.
