# Working in this vault

This is a personal knowledge base: plain Markdown files with YAML frontmatter, opened in Obsidian. The files are the source of truth. There is no database and no sync.

If the `pv-personal-kb` plugin is installed, load the `pkb-conventions` skill — it holds the authoritative version of everything below. This file is the fallback for tools that do not have the plugin.

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
