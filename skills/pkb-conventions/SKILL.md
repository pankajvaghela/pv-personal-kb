---
name: pkb-conventions
description: Conventions for the personal knowledge base — resolving the vault root from config, the folder taxonomy, frontmatter schema, note naming, link rules, and the workboard format. Use whenever creating, editing, moving, renaming, or classifying notes; when asked to capture, file, triage, review, or search notes; or when working with the workboard.
---

# PKB Conventions

The vault is plain Markdown files with YAML frontmatter. **The files are the source of truth** — there is no database, no server, and no sync. Everything below exists so that months of accumulated notes stay greppable, linkable, and safe to reorganize.

## What this vault depends on

**Markdown is the format. Everything else is a view of it.** Obsidian is the recommended view — it renders the links, the graph, and the frontmatter — but nothing here requires it. Delete Obsidian tomorrow and the vault is still a directory of readable text.

| Thing | Status |
|---|---|
| `.md` files with YAML frontmatter | **Required.** This is the format. |
| The folder taxonomy | **Required.** Ordinary directories. |
| GFM task lists | **Required.** Plain checkboxes. |
| `[[Wiki-links]]` | **Required convention.** Read by Obsidian, Foam, Logseq, Dendron, Quartz, and most other folder-of-Markdown tools. Not CommonMark — see the note below. |
| Obsidian | Optional. The best view, not a dependency. |
| Obsidian's Templates plugin | Optional. Substitutes `{{title}}` / `{{date}}` in `templates/`. Claude substitutes them itself, so a note created by a command is correct with or without the plugin. |
| Dataview, callouts, embeds | Optional. Use them where they earn their keep; they render as nothing outside Obsidian. |
| `📅 YYYY-MM-DD` on a workboard line | An Obsidian **Tasks** convention. Outside Obsidian it is only an emoji — which is why the date stays readable as plain text. |
| `.obsidian/` | Editor state. Git ignores the churn and keeps your config. |

**Why wiki-links are deliberate, not accidental.** `[[Note Title]]` is not CommonMark, so GitHub and bare text editors show it as literal text rather than a link. It is still the right default here for two reasons: it is the shared convention across file-based PKM tools, and it needs only the note's **filename**, not a relative path — which matters enormously when an AI writes the link, because a guessed relative path fails silently while a filename is either right or obviously missing.

If you ever want GitHub-native rendering, converting to `[Note](Note.md)` is mechanical. It touches every note, so it is worth deciding while the vault is still small.

## Resolving the vault root

The vault can live anywhere. Resolve it in this order:

1. `$PKB_ROOT` if set.
2. `~/.config/pv-personal-kb/config.json`:

   ```json
   { "root": "/Users/you/01personal/brain", "name": "Brain" }
   ```

3. **Neither present → stop.** Do not guess a path and do not create a vault by accident. Tell the user the config is missing and that `/setup` creates it.

Read the config once at the start of a task and use that absolute path for every operation. Never hardcode a vault path into a note, a template, or this plugin's files.

## Hard rules

1. **One note = one topic.** The filename is the link target, so a rename breaks every inbound link. Rename deliberately, and repair inbound links in the same pass.
2. **Every note carries frontmatter.** A note without `type` and `updated` is invisible to every review and query.
3. **Dates are ISO-8601** (`2026-09-26`), always. No relative dates (`"last week"`) in frontmatter — they rot into lies.
4. **Never invent a top-level folder.** The taxonomy is closed. If something genuinely does not fit, say so and propose the new folder rather than creating it silently.
5. **When unsure, file into `00-inbox/`.** It is the default landing zone, not a failure.
6. **The folders are the schema.** Putting a note in the right folder is worth more than adding three fields to the wrong one. Do not encode structure in frontmatter that a folder already expresses.

## Folder taxonomy

| Folder | Holds | `type` |
|---|---|---|
| `00-inbox/` | Unsorted capture, awaiting triage. | `inbox` |
| `10-workboard/` | Action items — what is live right now. See below. | `workboard` |
| `20-goals/` | Outcomes with a target date. | `goal` |
| `30-lifestyle/` | Routines, health, habits, home, money. | `lifestyle` |
| `40-travels/` | Trips, itineraries, places. | `trip` |
| `50-projects/` | Time-bound efforts with a finish line. One folder per project. | `project` |
| `60-people/` | One note per person. | `person` |
| `70-knowledge/` | Evergreen notes and reference — the graph core. | `note` |
| `90-archive/` | Done, dead, or dormant. Kept so links survive. | *(inherited)* |
| `templates/` | Note skeletons. | — |

Numeric prefixes encode **attention order**, not hierarchy — the folders you touch most sit at the top of Obsidian's file list. Renumbering rewrites paths, so treat it as a real change: cheap early, expensive once a hundred notes point at each other.

**Nothing is deleted, only archived.** `90-archive/` is what makes "never delete" affordable — a dead project keeps its links.

## Frontmatter schema

Minimum viable. Add a field only when a real query or view consumes it; an unused field is a small lie you have to keep maintaining.

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

Type-specific additions:
- `project`: `owner`, `due`, `outcome`
- `person`: `relationship`, `last_contact` (date)
- `trip`: `start`, `end`, `places` (list)
- `goal`: `target` (date), `horizon` (`year` | `quarter` | `season`)

`tags` are lowercase, hyphenated, no `#`. Nested tags (`area/health`, `project/kitchen`) are encouraged — they cross-cut folders without inventing new ones.

**Templates carry no identity fields.** A note created from a template inherits its frontmatter, so a template holding a `created` date or a specific `title` produces notes that all claim to be the template. Keep `templates/` to structure only.

## Links and syntax

Wiki-links are the point of the vault: `[[Note Title]]`, `[[Note Title|display text]]`, and `[[Note Title#Heading]]` all work. Link liberally — a link to a note that does not exist yet is a useful marker, not an error.

**Prefer plain Markdown where it costs nothing.** A fenced code block over a callout, a table over a query, a real word over an emoji. The vault should still read correctly in any text editor in ten years, and every Obsidian-only feature you lean on is one more thing that renders as nothing elsewhere. This is a preference, not a prohibition — use the Obsidian feature when it genuinely earns its keep, and do not contort a note to avoid one.

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
- The source is literal checkboxes, so `grep` and Obsidian's own task queries both work. A Dataview view on top is fine; a Dataview-only workboard is not — the file has to stay readable as text.
- Completed items are checked, not deleted. `/review` sweeps them into `## Done — <month>`.
- Per-project action items may live inside the project note under `## Actions`. The workboard is for what is live *now* — promote, do not duplicate.
