# Working in this vault

This is a personal knowledge base: plain Markdown files with YAML frontmatter. The files are the source of truth. There is no database and no sync.

**Markdown is the format; every app is just a view of it.** Nothing in this vault requires Obsidian or any other editor, and no tool should depend on one. The vault must read correctly in a text editor, in a terminal, on GitHub, or anywhere else.

**This file is authoritative for this vault.** The `pkb-conventions` skill in the `pv-personal-kb` plugin ships the same conventions as *defaults* — and where this file and that skill disagree, **this file wins**, because it describes the vault you are actually in rather than the one the plugin would have made. Anything this vault does differently is recorded under [Local conventions](#local-conventions) at the end, and is deliberate.

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
| `05-daily/` | One note per day, filed under `YYYY-MM/`. Never triaged. |
| `10-workboard/` | Action items — what is live right now. |
| `20-goals/` | Outcomes with a target date. |
| `30-lifestyle/` | Routines, health, habits, home, money. |
| `40-travels/` | Trips, itineraries, places — plus `travels.md`, the index of all of them. |
| `50-projects/` | Time-bound efforts with a finish line. One folder per project. |
| `60-people/` | One note per person. |
| `70-knowledge/` | Evergreen notes and reference. |
| `90-archive/` | Done, dead, or dormant. Kept so links survive. |
| `templates/` | Note skeletons. |

The numeric prefixes encode attention order, not hierarchy.

Only two folders go deeper than one level by default: `05-daily/YYYY-MM/YYYY-MM-DD.md` and `50-projects/<slug>/`. Create the month folder if it is missing. Everywhere else stays flat — unless [Local conventions](#local-conventions) says otherwise, which is checked first and wins.

`.pkb/` is not part of the taxonomy — it is the tooling's own directory. `config.json` holds this vault's settings and **is committed**, so no credential ever goes in it. `version` records which scaffold built the vault and is machine-written.

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
type: project | person | trip | lifestyle | goal | note | inbox | daily | workboard | wishlist | travels
status: active | seed | paused | done | archived
created: 2026-09-26
updated: 2026-09-26
tags: []
---
```

Type-specific: `project` gets `owner`/`due`/`outcome`; `person` gets `relationship`/`last_contact`; `trip` gets `start`/`end`/`places`/`people`; `goal` gets `target`/`horizon`.

## Workboard

`10-workboard/workboard.md` holds literal GFM task lists under `## Now`, `## Next`, `## Waiting`, `## Someday`. One line per action, trailing `#tag` and `📅 YYYY-MM-DD` are the only inline metadata. Completed items are checked, not deleted.

## Wishlist

`30-lifestyle/wishlist.md` holds things that might be wanted, one line each, under `## Off hold` (waiting period over), `## Holding` (still inside it), `## Needed` (actually needed, no wait), `## Dreams`, and `## Done`.

A wish is deliberately undated and unplanned — that is what makes it a wish. If it acquires a target date it becomes a goal in `20-goals/`; a place becomes a `40-travels/` note; a single next action becomes a workboard line. Nothing ever leaves by being ignored, and nothing computed (totals, day counts) is ever written into the file.

`## Dreams` is the life-scale tier: things you want to do in your life. Same one-line shape as a wish, different time horizon. No waiting period and no review pressure — a dream is allowed to sit for years, and must never be reported as overdue. When one gets real it is promoted to a goal note in `20-goals/`.

## Habits

`30-lifestyle/habits.md` holds **standing things I want to keep doing** — one line each, `<habit> — <cadence> — <what counts>`, under `## Active` and `## Dropped`.

A habit is neither an action nor a goal. An action completes and a goal arrives; a habit never finishes, it is either being kept or it is not. That is why it lives here and not on the workboard, where everything is expected to close.

**The ticks are not in that file.** They go in the day's note under `## Habits`, which is where the day is already being written — every active habit listed, checked or not. The definition file holds only what the habits *are*, so changing a cadence does not rewrite history, and the daily note holds what actually happened.

**An unchecked box and a missing section mean different things.** A day with no `## Habits` section is *unknown* — not logged. A day with the section and an unchecked box is a *miss*. Anything reading the trend must keep those apart, because a gap reported as a failure is a false regression, and false regressions are what make people stop tracking.

**Never store a streak, a percentage, or a "regressing" flag.** All of it is computed from the days at read time. A stored streak is wrong the moment a day is missed, and worse, it makes the number the thing being maintained.

Dropping a habit is a legitimate outcome, not a failure — a cadence that is consistently missed may simply be the wrong cadence. Dropped habits are recorded, not deleted, so the same one does not get re-added every few months.

## Travels

`40-travels/travels.md` is the index: a table of every trip — `| Trip | Start | End | Places | People |` — under `## Planned` and `## Been`. Start and end are separate columns rather than a range, and a missing value is `—`.

**It is generated, not curated** — rebuilt from the `title`, `start`, `end`, `places`, `people`, and `status` frontmatter of the other notes in the folder. Never hand-edit a row: if a row is wrong, the note's frontmatter is wrong. A hand-patched row is silently reverted the next time the index is rebuilt.

A trip is a note named for the trip rather than the place (`Kyoto 2026`, not `Kyoto`) so two trips to the same city get two notes. Anything not on the index is either a new note waiting for a rebuild, or a place that belongs in `## Dreams`.

## Local conventions

Amendments to everything above, for **this vault specifically**. The plugin's conventions describe what a vault gets out of the box; this section records what *this* vault has decided differently, and it takes precedence over them.

Anything here is deliberate. A tool reading this file — including `/pkb-doctor` and the `pkb-conventions` skill — must treat these as correct and **never report them as problems**. That is the point of writing them down: an exception that lives only in someone's memory is indistinguishable from a mistake.

Write them as decisions, with the reason:

    - `50-projects/` may nest: `50-projects/<project>/<sub>/` — research folders get deep.
    - `20-goals/` groups by area: `20-goals/<area>/<goal>.md`.
    - New top-level folder `80-health/` — added <YYYY-MM-DD>, because it outgrew `30-lifestyle/`.

_Nothing amended yet._
