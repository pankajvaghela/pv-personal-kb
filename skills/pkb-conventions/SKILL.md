---
name: pkb-conventions
description: Conventions for the personal knowledge base — vault root resolution, folder taxonomy, frontmatter schema, and hard rules. Use whenever creating, editing, moving, renaming, or classifying notes; when asked to capture, file, triage, review, or search notes; or when working with the workboard. Reference files cover the individual areas.
---

# PKB Conventions

The vault is plain Markdown files with YAML frontmatter. **The files are the source of truth** — no database, no server, no sync. What follows exists so months of accumulated notes stay greppable, linkable, and safe to reorganize.

## The vault's own conventions come first

**What this skill holds are defaults.** A vault may amend them, in `<root>/AGENTS.md` under `## Local conventions` — and there, **`AGENTS.md` wins.** It describes the vault you are in; this file describes the one the plugin would have made.

Read `<root>/AGENTS.md` at the start of every task, alongside the configs. Follow a local convention without commentary, and never quietly correct the vault toward the default: a structure `AGENTS.md` permits is correct by definition, and flagging it as a problem teaches the user to ignore the report.

**An amendment is never silent.** When a new folder or an exception is agreed on, record it there — otherwise the next session re-proposes it and the one after undoes it.

## Reference files

Read only the one the task touches. Each is relative to this file, and wins for its own area.

| File | Read it when the task touches |
| --- | --- |
| `references/format.md` | Note content, app-specific features, templates. |
| `references/desire.md` | Wants not yet decided — wishlist, seeds, dreams. |
| `references/habits.md` | A standing habit, its daily ticks, or the trend. |
| `references/travels.md` | A trip, or the travels index. |
| `references/workboard.md` | Adding, completing, or reviewing action items. |
| `references/daily.md` | Writing or reading a daily note. |
| `references/sources.md` | Reading from outside the vault. |

## Resolving the vault root

1. `$PKB_ROOT` if set.
2. `root` in `~/.config/pv-personal-kb/config.json`.
3. **Neither → stop.** Do not guess a path or create a vault by accident. Say the config is missing and that `/pkb-setup` writes it.

Then read `<root>/.pkb/config.json` for the rest and `<root>/AGENTS.md` for local conventions. Do all three once at the start of a task, and use that absolute path throughout. **Never hardcode a vault path** into a note, a template, or this plugin's files.

**Two config files, split by what belongs in git.** The machine-local one holds `root` and `secrets`, and is never committed. The vault's own holds `name` and `sources`, and **is committed** — which is why no credential ever goes in it.

**Vaults from before 0.8** have no `.pkb/config.json`; their `name` and `sources` are still in the machine config. Fall back to those, and point at `/pkb-upgrade`.

**Two things at the vault root are not notes.** `AGENTS.md` holds this vault's conventions, for every tool that reads it. `.pkb/` is the plugin's own: `config.json`, hand-edited, and `version`, machine-written. Neither belongs in the taxonomy.

## Hard rules

1. **One note = one topic.** The filename is the link target, so a rename breaks every inbound link. Use `/pkb-rename`, which repairs them in the same pass.
2. **Every note carries frontmatter.** Without `type` and `updated` it is invisible to every review and query.
3. **Dates are ISO-8601** (`2026-09-26`), always. Never relative dates in frontmatter — they rot into lies.
4. **Never invent a top-level folder.** The taxonomy is closed. Propose a new one instead, and once it is agreed, record it in `## Local conventions`.
5. **When unsure, file into `00-inbox/`.** The default landing zone, not a failure.
6. **The folders are the schema.** A note in the right folder beats three extra fields in the wrong one.
7. **Never delete.** Archive to `90-archive/`. Never rewrite `created` — it is the only record of when a note entered the vault.
8. **A thing that can be derived is not stored.** Totals, day counts, ranges, weekdays, streaks — render them at read time.

## Folder taxonomy

| Folder          | Holds                                                          | `type`        |
| --------------- | -------------------------------------------------------------- | ------------- |
| `00-inbox/`     | Unsorted capture, awaiting triage.                             | `inbox`       |
| `05-daily/`     | One note per day, filed by month. Never triaged.               | `daily`       |
| `10-workboard/` | Action items — what is live right now.                         | `workboard`   |
| `20-goals/`     | Outcomes — dated, or life-scale at `horizon: life`.            | `goal`        |
| `30-lifestyle/` | Routines, health, habits, home, money. Holds `wishlist.md` and `habits.md`. | `lifestyle` |
| `40-travels/`   | Trips, itineraries, places. Holds `travels.md`, the index.     | `trip`        |
| `50-projects/`  | Time-bound efforts with a finish line. One folder per project. | `project`     |
| `60-people/`    | One note per person.                                           | `person`      |
| `70-knowledge/` | Evergreen notes and reference — the graph core. Seeds live here too, as `status: seed`. | `note` |
| `90-archive/`   | Done, dead, or dormant. Kept so links survive.                 | _(inherited)_ |
| `templates/`    | Note skeletons.                                                | —             |

Numeric prefixes encode **attention order**, not hierarchy. Renumbering rewrites paths, so treat it as a real change: cheap early, expensive once a hundred notes point at each other.

**Two folders nest by default, and only two.** `05-daily/YYYY-MM/YYYY-MM-DD.md` — create the month folder when it is missing — and `50-projects/<slug>/`. A third level elsewhere needs a reason or an amendment, so check `## Local conventions` before calling any nesting a violation.

**Nothing is deleted, only archived.** `90-archive/` is what makes "never delete" affordable — a dead project keeps its links.

## Frontmatter schema

Minimum viable. Add a field only when a real query or view consumes it; an unused field is a small lie you have to keep maintaining.

```yaml
---
title: Human-readable title
type: project | person | trip | lifestyle | goal | note | inbox | daily | workboard | wishlist | travels
status: active | seed | paused | done | archived
created: 2026-09-26
updated: 2026-09-26
tags: []
---
```

Type-specific additions:

- `project`: `owner`, `due`, `outcome`
- `person`: `relationship`, `last_contact` (date)
- `trip`: `start` (date), `end` (date), `places` (list), `people` (list)
- `goal`: `target` (date), `horizon` (`life` | `year` | `quarter` | `season`)

`tags` are lowercase, hyphenated, no `#`. Nested tags (`area/health`, `project/kitchen`) are encouraged — they cross-cut folders without inventing new ones.

**`title` must match the filename** (minus `.md`). The filename is what links resolve against and the title is what they are written with, so a disagreement produces links that point at nothing — most visibly in the travels index, which links trips by title. `/pkb-doctor` checks it; `/pkb-rename` fixes it.

**Templates carry no identity fields.** A template holding a `created` date or a specific `title` produces notes that all claim to be the template. Keep `templates/` to structure only.

## Links and syntax

`[[Note Title]]`, `[[Note Title|display text]]`, `[[Note Title#Heading]]`. Link liberally — a link to a note that does not exist yet is a useful marker, not an error.

Prefer plain Markdown where it costs nothing. What that costs, why these are wiki-links, and the one place Obsidian syntax is deliberate: `references/format.md`.
