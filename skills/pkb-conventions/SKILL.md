---
name: pkb-conventions
description: Conventions for the personal knowledge base — resolving the vault root from config, the folder taxonomy, frontmatter schema, note naming, link rules, and the workboard format. Use whenever creating, editing, moving, renaming, or classifying notes; when asked to capture, file, triage, review, or search notes; or when working with the workboard.
---

# PKB Conventions

The vault is plain Markdown files with YAML frontmatter. **The files are the source of truth** — there is no database, no server, and no sync. Everything below exists so that months of accumulated notes stay greppable, linkable, and safe to reorganize.

## What this vault depends on

**Markdown is the format. Everything else is a view of it.** Nothing here requires Obsidian or any other app. Delete every editor tomorrow and the vault is still a directory of readable text. Viewers are interchangeable — Obsidian, VS Code, iA Writer, GitHub, `less`.

| Thing                               | Status                                                                                                                                                                                                                            |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.md` files with YAML frontmatter   | **Required.** This is the format.                                                                                                                                                                                                 |
| The folder taxonomy                 | **Required.** Ordinary directories.                                                                                                                                                                                               |
| GFM task lists                      | **Required.** Plain checkboxes.                                                                                                                                                                                                   |
| `[[Wiki-links]]`                    | **Required convention.** Read by Obsidian, Foam, Logseq, Dendron, Quartz, and most other folder-of-Markdown tools. Not CommonMark — see the note below.                                                                           |
| A Markdown viewer                   | **Suggested — pick any.** Obsidian is a good one: it renders the links, draws the graph, and shows frontmatter as properties. It is one option among several, not a requirement, and the vault must never be organized around it. |
| Dataview, callouts, embeds          | Optional, and Obsidian-only. Use them where they earn their keep; they render as nothing anywhere else.                                                                                                                           |
| `📅 YYYY-MM-DD` on a workboard line | An Obsidian **Tasks** plugin convention. Elsewhere it is just an emoji — which is why the date stays readable as plain text.                                                                                                      |
| `.obsidian/`                        | Editor state. Git ignores the churn and keeps your config.                                                                                                                                                                        |
| `templates/`                        | Note skeletons using Obsidian's `{{title}}` / `{{date}}` variables.                                                                                                                                                               |

**Templates speak Obsidian.** They use `{{title}}` and `{{date:YYYY-MM-DD}}` — the one place the vault depends on an app's syntax, kept because it is what makes the Templates plugin useful. That is a deliberate exception, not a precedent: Claude substitutes these variables itself, so a note created by a command is correct with or without Obsidian. If you edit a template, keep the same variable form so both paths keep working.

**Why wiki-links are deliberate, not accidental.** `[[Note Title]]` is not CommonMark, so GitHub and bare text editors show it as literal text rather than a link. It is still the right default here for two reasons: it is the shared convention across file-based PKM tools, and it needs only the note's **filename**, not a relative path — which matters enormously when an AI writes the link, because a guessed relative path fails silently while a filename is either right or obviously missing.

If you ever want GitHub-native rendering, converting to `[Note](Note.md)` is mechanical. It touches every note, so it is worth deciding while the vault is still small.

## Two config files, split by what belongs in git

**`~/.config/pv-personal-kb/config.json`** — machine-local, never committed. Two jobs, and only two: find the vault, and hold secrets.

```json
{
  "root": "/Users/you/path-to/brain",
  "secrets": { "notion_token": "ntn_xxx" }
}
```

**`<root>/.pkb/config.json`** — lives in the vault, committed, travels with it. Everything else:

```json
{
  "name": "Pankaj's PKB",
  "sources": []
}
```

The split is deliberate. Configuration that *describes the vault* — what it is called, what it reads from — belongs with the vault, so it is versioned, diffable, and survives a move to another machine. Only the two things that cannot live there are kept out: the path that makes the vault findable when you are not standing in it, and secrets.

## Resolving the vault root

1. `$PKB_ROOT` if set.
2. `root` from the machine config.
3. **Neither present → stop.** Do not guess a path and do not create a vault by accident. Tell the user the config is missing and that `/pkb-setup` creates it.

Read the machine config for the path, then read `<root>/.pkb/config.json` for everything else. Do both once at the start of a task, and use that absolute path for every operation. Never hardcode a vault path into a note, a template, or this plugin's files.

**Vaults from before 0.8 have no `.pkb/config.json`** — their `name` and `sources` still sit in the machine config. Fall back to those rather than failing, and tell the user to run `/pkb-upgrade` to move them where they belong.

**Two things sit at the vault root that are not notes.** `AGENTS.md` holds these conventions for tools that do not have this plugin. `.pkb/` is the plugin's own directory — `config.json`, which is yours to edit, and `version`, which `/pkb-setup` and `/pkb-upgrade` write. Neither belongs in the taxonomy, and only `config.json` is ever hand-edited.

## Sources

Some commands read from outside the vault — a calendar, a task list, a Notion inbox. Sources are **declared in the vault's own `.pkb/config.json`, never hardcoded**, so adding one is a config edit rather than a code change — and the result is committed with the vault rather than stranded on one machine.

```json
{
  "name": "Brain",
  "sources": [
    { "id": "vault-inbox", "kind": "vault", "label": "Vault inbox", "path": "00-inbox", "enabled": true },
    { "id": "workboard", "kind": "vault", "label": "Workboard", "path": "10-workboard/workboard.md", "enabled": true },
    { "id": "calendar", "kind": "mcp", "label": "Today's calendar", "tool": "mcp__google-calendar__list_events", "args": { "timeMin": "$TODAY_START", "timeMax": "$TODAY_END" }, "enabled": true },
    { "id": "notion-inbox", "kind": "mcp", "label": "Notion inbox", "tool": "mcp__notion__search", "args": {}, "enabled": false },
    { "id": "tasks", "kind": "command", "label": "Google Tasks", "command": "gtsk list --json", "env": { "GTSK_TOKEN": "$SECRET:gtsk_token" }, "enabled": false }
  ]
}
```

Three kinds, and that is deliberately the whole vocabulary:

| `kind`    | Reads from                    | Needs                            |
| --------- | ----------------------------- | -------------------------------- |
| `vault`   | A path inside the vault       | Nothing. Always available.       |
| `mcp`     | An MCP tool, by name          | That MCP server to be connected. |
| `command` | A shell command's stdout      | The command to exist.            |

**Credentials never appear in this file, because this file is committed.** A `command` source that needs auth names the secret instead of holding it: `"$SECRET:gtsk_token"` resolves at read time from the `secrets` map in the machine-local config and is passed to the command as an environment variable. It is never written back into the vault, and never echoed. An `mcp` source needs no secrets at all — auth belongs to the MCP server.

If you ever find a literal token in `<root>/.pkb/config.json`, stop and say so. The file is in git, and a pushed secret is a leaked secret — moving it to the machine config is the fix, plus rotating it if it was already pushed.

**Sources are read-only.** Nothing here writes back to a source — do not mark a Notion row processed, complete a remote task, or send mail. That would re-create the two-way sync problem this whole design avoids. When something is handled, record it in the vault.

**`mcp` tool names are installation-specific.** They come from whichever servers the user has connected, and `/mcp` lists them. Never guess a name that looks adjacent — report it missing and point at `/mcp`.

**Substitutions** available in `args` and `command`: `$TODAY`, `$NOW`, `$TODAY_START`, `$TODAY_END`, `$VAULT`. Resolve them before running anything. `$SECRET:<key>` is the one exception — it appears only inside a source's `env` map, resolves from the machine-local `secrets`, and must never be printed, logged, or committed.

**A source that fails is not a source that is empty.** Anything reading a source must report `ok`, `empty`, or `failed` per source, and never let a failure pass as silence.

## Hard rules

1. **One note = one topic.** The filename is the link target, so a rename breaks every inbound link. Rename deliberately, and repair inbound links in the same pass.
2. **Every note carries frontmatter.** A note without `type` and `updated` is invisible to every review and query.
3. **Dates are ISO-8601** (`2026-09-26`), always. No relative dates (`"last week"`) in frontmatter — they rot into lies.
4. **Never invent a top-level folder.** The taxonomy is closed. If something genuinely does not fit, say so and propose the new folder rather than creating it silently.
5. **When unsure, file into `00-inbox/`.** It is the default landing zone, not a failure.
6. **The folders are the schema.** Putting a note in the right folder is worth more than adding three fields to the wrong one. Do not encode structure in frontmatter that a folder already expresses.

## Folder taxonomy

| Folder          | Holds                                                          | `type`        |
| --------------- | -------------------------------------------------------------- | ------------- |
| `00-inbox/`     | Unsorted capture, awaiting triage.                             | `inbox`       |
| `05-daily/`     | One note per day, filed by month. Never triaged.               | `daily`       |
| `10-workboard/` | Action items — what is live right now. See below.              | `workboard`   |
| `20-goals/`     | Outcomes — dated, or life-scale at `horizon: life`.            | `goal`        |
| `30-lifestyle/` | Routines, health, habits, home, money. Holds `wishlist.md`.     | `lifestyle`   |
| `40-travels/`   | Trips, itineraries, places.                                    | `trip`        |
| `50-projects/`  | Time-bound efforts with a finish line. One folder per project. | `project`     |
| `60-people/`    | One note per person.                                           | `person`      |
| `70-knowledge/` | Evergreen notes and reference — the graph core. Seeds live here too, as `status: seed`. | `note`        |
| `90-archive/`   | Done, dead, or dormant. Kept so links survive.                 | _(inherited)_ |
| `templates/`    | Note skeletons.                                                | —             |

Numeric prefixes encode **attention order**, not hierarchy — the folders you touch most sort to the top of any file listing. Renumbering rewrites paths, so treat it as a real change: cheap early, expensive once a hundred notes point at each other.

**Two folders use subfolders, and only two.** Daily notes live at `05-daily/YYYY-MM/YYYY-MM-DD.md` — the month level keeps a year of notes browsable instead of leaving a 365-file directory, and it sorts correctly because the prefix is ISO. Create the month folder when it is missing rather than assuming it exists. Projects live at `50-projects/<slug>/`. Everywhere else stays flat; a third level elsewhere needs a reason.

**Nothing is deleted, only archived.** `90-archive/` is what makes "never delete" affordable — a dead project keeps its links.

## Frontmatter schema

Minimum viable. Add a field only when a real query or view consumes it; an unused field is a small lie you have to keep maintaining.

```yaml
---
title: Human-readable title
type: project | person | trip | lifestyle | goal | note | inbox | daily | workboard | wishlist
status: active | seed | paused | done | archived
created: 2026-09-26
updated: 2026-09-26
tags: []
---
```

Type-specific additions:

- `project`: `owner`, `due`, `outcome`
- `person`: `relationship`, `last_contact` (date)
- `trip`: `start`, `end`, `places` (list)
- `goal`: `target` (date), `horizon` (`life` | `year` | `quarter` | `season`)

`tags` are lowercase, hyphenated, no `#`. Nested tags (`area/health`, `project/kitchen`) are encouraged — they cross-cut folders without inventing new ones.

**Templates carry no identity fields.** A note created from a template inherits its frontmatter, so a template holding a `created` date or a specific `title` produces notes that all claim to be the template. Keep `templates/` to structure only.

## Links and syntax

Wiki-links are the point of the vault: `[[Note Title]]`, `[[Note Title|display text]]`, and `[[Note Title#Heading]]` all work. Link liberally — a link to a note that does not exist yet is a useful marker, not an error.

**Prefer plain Markdown where it costs nothing.** A fenced code block over a callout, a table over a query, a real word over an emoji. The vault should still read correctly in any text editor in ten years, and every app-specific feature you lean on is one more thing that renders as nothing elsewhere. This is a preference, not a prohibition — use the feature when it genuinely earns its keep, and do not contort a note to avoid one.

## Workboard

`10-workboard/workboard.md` holds action items as **literal GFM task lists**, grouped by horizon:

```markdown
## Now

- [ ] Ship the plugin #project/pv-personal-kb 📅 2026-09-30

## Next

- [ ] Book the Kyoto ryokan #travel/japan

## Waiting

- [ ] Awaiting quote from the builder #people/sam

## Someday

- [ ] Learn to sail #area/lifestyle
```

Rules:

- One line per action. State the action, not the topic.
- Trailing `#tag` and `📅 YYYY-MM-DD` are the only inline metadata.
- The source is literal checkboxes, so `grep` works and any editor's task queries work. A Dataview view on top is fine; a Dataview-only workboard is not — the file has to stay readable as text.
- Completed items are checked, not deleted. `/pkb-review` sweeps them into `## Done — <month>`.
- Per-project action items may live inside the project note under `## Actions`. The workboard is for what is live _now_ — promote, do not duplicate.

## Wishlist

`30-lifestyle/wishlist.md` — a single file, one line per wish, held until it has been wanted long enough to trust.

```markdown
- [ ] Mechanical keyboard — ~$180 — added 2026-08-15 — typing on a $20 membrane board all day #wish/buy
```

Sections: `## Off hold` (the waiting period is over — needs a decision), `## Holding` (inside it — leave alone), `## Needed` (things actually needed and not being bought, where the delay is the problem rather than the signal; no waiting period), `## Done` (bought or dropped, checked, never deleted).

**The wishlist is an inbox for desire.** Something you want, captured cheaply, held until it is clear what to do with it. It is an inbox, but not one you clear in a sitting — every other inbox in this vault is processed as fast as possible, and this one is processed **slowly, on purpose**, because desire is not legible on the day you feel it.

That has two consequences worth holding to. Capture asks nothing, exactly like `/pkb-capture` — the judgment happens at review, and a wishlist entry that costs a question to write is one that never gets written. And the hold is the *triage delay*, not a delay before triage: the clock starts when the wish is captured, because the desire is already ageing and restarting it at review would defeat the only mechanism that works.

**A wish leaves by being acted on, not by being ignored.** Acting on it usually means the desire has become legible enough to promote — into a goal, a project, a trip, or a workboard line, including a plain "buy X" task. A small decided purchase is simply done. A wish that no longer looks worth it is dropped, recorded as checked so the same thing is not re-added in three months. "Leave it" is the one answer that is not allowed, and it is the failure mode every wishlist has.

That gives the boundary with everything adjacent, and it is worth holding firmly:

| If it… | It belongs in |
| --- | --- |
| Has a target date and a plan | `20-goals/` — the promotion path for most wishes |
| Is a place to go | `40-travels/` |
| Needs sustained effort over time | `20-goals/`, or a project if it has a finish line |
| Is a single next action | `10-workboard/workboard.md` |
| Is undecided — wanted, not yet earned | here |

**Desire is tested by waiting, not recorded.** Do not add a "how much do I want this" field; asked at the moment of wanting, the answer is the impulse talking, and it is why high/medium/low priority collapses within a week. Time is the honest measure, so the hold period is derived from cost — 7 days under $100, 14 days to $500, 30 days above, and 30 days for anything with no cost at all, because money is capped and time is not.

**Importance is what exempts you from the wait**, and that is its only job here. A need does not become more urgent by sitting on a list for a month.

**Nothing computed is stored.** No totals, no day counts, no "waited 42 days" — those are derived at read time. A stored total is a number that goes stale and has to be maintained.

## Seeds

Not everything worth keeping is a task or a decision. "Jan Schoonhoven relief" is neither — it is something to know about, eventually, when it comes up.

A curiosity is a **note**, not a list line: a stub in `70-knowledge/` with `status: seed`. It is a note because the note is where the learning will land, and because a note can be linked to — from a gallery visit, from a wish to buy a print, from a note about the Nul group. A line in a list can be linked from nowhere, which is the entire reason this vault uses wiki-links.

**What separates a seed from a wishlist item is what it ends in.**

|                    | Wishlist                                | Seed                                |
| ------------------ | --------------------------------------- | ----------------------------------- |
| Ends in            | an act — buy, go, do                    | knowing                             |
| Lives in           | `30-lifestyle/wishlist.md`              | `70-knowledge/`, `status: seed`     |
| Has a cost and a hold | yes                                  | no                                  |
| Decays if ignored  | yes — and that is information about you | no — and that is fine               |
| Leaves by          | bought, promoted, dropped               | being developed, or never           |

**A seed has no urgency and must not acquire any.** No due date, no hold, no review section, no count that should trend to zero. A seed you have not gotten to is not a failure and a list of forty is not a problem. The moment seeds are treated as a backlog they stop being curiosities and start being guilt.

Everything else is already in the schema:

```yaml
---
title: Jan Schoonhoven
type: note
status: seed
created: 2026-09-26
updated: 2026-09-26
tags: [art, occasion/home]
---

Nul group, Dutch, white reliefs. Worth knowing how they were made — cardboard and cheap
filler, painted white, which is the opposite of what they look like.
```

The body is optional, and one line is a complete seed — why it is worth knowing, or where it came from. Developing it later means writing the note and flipping `status` to `active`. Nothing moves, nothing is converted, and every link already pointing at it keeps working.

**Occasion tags** are what make a seed findable when its moment arrives: `#occasion/home` for the art you would buy for the flat, `#occasion/date` for the topic you would bring up, `#occasion/gift`. Use them only when there is a real occasion — a tag nobody queries is another field to maintain for nothing.

A seed can lead to a wish, and that is a link rather than a conversion: the wishlist line references `[[Jan Schoonhoven]]` and the seed stays where it is.

## Dreams

`## Dreams` is the last section of `30-lifestyle/wishlist.md`: things you want to do in your life. `Skydive`, `See the Northern Lights`, `Learn to sail`.

**Dreams are what you want your life to have in it; wishes are what you want next.** Both are wants and both are one line — the difference is **time horizon, not weight**. A dream is not a goal, a project, or a note; "skydive" needs no research plan and no `## Leading actions`, and treating every dream as a project is how a dream list stops being a pleasure.

**Language matters, and it is not decoration.** Say *dreams*, *things you want to do in your life*, *what you want your life to have in it*. Never "before you die", and never "bucket list" — that phrase comes from "kick the bucket", and this section is about living, not about mortality. A list that reads as an invitation gets used; one that reads as a deadline gets avoided.

**No waiting period, no review pressure, no count.** A dream sits on the list because it is true about you, not because it is due. It is allowed to wait years and nothing is wrong while it does, so `/pkb-review` surfaces only the ones that have started to move. **Never report an untouched dream as overdue, stale, or forgotten.**

**The exit is pursuit.** When a dream gets real — cost looked into, a date forming, money to save, a skill to build first — it is promoted to a goal note in `20-goals/` (`horizon: life`) and removed from the list. It has not stopped being a dream; it has acquired somewhere to be worked on. That is what `## Leading actions` and `## Progress` in the goal template are for, and it is the only reason to leave the one-line form.

## Daily notes

`05-daily/YYYY-MM/YYYY-MM-DD.md`, `type: daily`. Two commands write these and they must agree on the shape.

```markdown
---
title: 2026-09-26
type: daily
status: active
created: 2026-09-26
updated: 2026-09-26
sources: [vault-inbox, calendar]
tags: []
---

## Thursday 2026-09-26

**Fixed**
- 10:00 Standup

**Carried**
- [ ] Ship the plugin #project/pv-personal-kb

**Proposed**
- Draft the proposal before 16:00

## Log

### Thursday 2026-09-26, evening

**Done**
- Shipped the plugin

**Changed**
- Archived 2 dormant projects

**Carried to tomorrow**
- [ ] Finish the proposal — blocked on the client's numbers
```

`/pkb-morning` writes the briefing and leaves `## Log` empty. `/pkb-end-of-the-day` appends under it. Both are idempotent: re-running either rewrites its own section rather than adding a second copy.

**The `## Carried to tomorrow` list is the seam between them** — the evening writes it, the next morning reads it into its Carried bucket. That loop is the reason both commands exist; either one alone is just a note-taking prompt.

Daily notes are never triaged. They are a log, not capture — which is exactly why they live outside `00-inbox/`.
