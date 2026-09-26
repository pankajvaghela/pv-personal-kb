# pv-personal-kb

A Claude Code plugin that sets up and runs a personal knowledge base as a **plain folder of Markdown files**.

No database, no server, no sync service. Your notes are `.md` files with YAML frontmatter that you can grep in a terminal, diff in git, and still open in ten years. Claude gets commands for the things that are annoying to do by hand — capturing without ceremony, filing an inbox, keeping a workboard honest — and a conventions skill so it files things the same way every time instead of inventing a structure.

**Nothing here requires Obsidian.** No command reads or writes editor state. Open the vault in whatever you like: Obsidian, VS Code, iA Writer, GitHub, `less`.

| | |
|---|---|
| **Required** | `.md` files, YAML frontmatter, plain directories, GFM checkboxes, `[[wiki-links]]` |
| **Pick any** | A Markdown viewer. Obsidian is a good one — it renders the wiki-links and draws the graph — but it's one option, not a requirement. |
| **App-specific, optional** | Dataview, callouts, embeds, the `📅` task marker |

Two honest caveats: `[[wiki-links]]` are not CommonMark, so GitHub shows them as literal text — though Foam, Logseq, Dendron, and Quartz all read them. And the `📅` date marker on workboard lines is an Obsidian Tasks convention that means nothing elsewhere, which is why the date is always also readable as plain text.

**Why it works this way is in [DESIGN.md](DESIGN.md).** This file is the reference.

## Install

```bash
claude plugin marketplace add pankajvaghela/pv-personal-kb
claude plugin install pv-personal-kb@pankajvaghela
```

Then, in any session:

```
/pkb-setup
```

It asks where the vault should live and what to call it, scaffolds the folders, and writes two config files. You can put the vault anywhere — the plugin reads the path from config and never hardcodes one. Set up more than one vault by re-running `/pkb-setup` and pointing it somewhere else.

## Commands

| Command | Does |
|---|---|
| `/pkb-setup` | Create a vault, or point the plugin at a different one. |
| `/pkb-upgrade` | Bring an existing vault's structure up to the installed plugin version. |
| `/pkb-morning` | Start-of-day briefing, built from your configured sources. |
| `/pkb-end-of-the-day` | Log what actually changed, then commit and push. |
| `/pkb-capture <thing>` | Throw something into the inbox. No decisions, no sorting. |
| `/pkb-triage` | File inbox items into the right folders — shows a plan first. |
| `/pkb-workboard` | Show, add, complete, or drop action items. |
| `/pkb-wishlist` | Show, add to, or resolve the wishlist. |
| `/pkb-curious` | Note something you want to know about — a seed note. |
| `/pkb-dreams` | Things you want to do in your life. |
| `/pkb-habits` | Standing habits — define them, tick them, see whether any are slipping. |
| `/pkb-travels` | Travels index — every trip as a table, generated from the trip notes. |
| `/pkb-new-project <name>` | Start a project note from the template. |
| `/pkb-new-person <name>` | Create or update a person note — searches for a duplicate first. |
| `/pkb-rename <note> → <title>` | Rename a note and repair every inbound wiki-link in the same pass. |
| `/pkb-doctor` | Check the vault's internal consistency — title/filename agreement, frontmatter, broken links, duplicates. `fix` applies the mechanical repairs only. |
| `/pkb-review` | Weekly sweep: inbox, workboard, wishlist, dreams, travels, stale projects, orphan notes, broken links. |
| `/pkb-commit` | Snapshot the vault to git, with a secret check before staging. |

Plus a `pkb-librarian` agent for bulk work — filing a large backlog, classifying an unsorted pile, hunting near-duplicates across folders.

## What you get

```
<your vault>/
├── AGENTS.md            conventions, for any AI or editor working in the vault
├── Home.md              entry note
├── .gitignore           ignores editor state, keeps your config
├── .pkb/                config.json (yours, committed) + version (written by setup)
├── 00-inbox/            unsorted capture — the default landing zone
├── 05-daily/            one note per day, filed under YYYY-MM/ — briefing, log, habit ticks
├── 10-workboard/        action items, as literal task lists
├── 20-goals/            outcomes, with a target date or horizon: life
├── 30-lifestyle/        routines, health, habits, home, money — wishlist.md and habits.md
├── 40-travels/          trips, itineraries, places — and travels.md, the index
├── 50-projects/         time-bound efforts, one folder each
├── 60-people/           one note per person
├── 70-knowledge/        evergreen notes and reference — including seeds
├── 90-archive/          done, dead, dormant — kept so links survive
└── templates/           note skeletons
```

The numbers are **attention order, not hierarchy**. The folders you touch most sort to the top of any file listing.

## Config

Two files, split by what belongs in git:

| | Holds | Committed |
|---|---|---|
| `~/.config/pv-personal-kb/config.json` | `root` — the vault's path — and `secrets` | never |
| `<vault>/.pkb/config.json` | `name` and `sources` | yes, with the vault |

```jsonc
// ~/.config/pv-personal-kb/config.json — this machine only
{
  "root": "/Users/you/brain",
  "secrets": { "gtsk_token": "..." }
}

// <vault>/.pkb/config.json — committed with the vault
{
  "name": "Brain",
  "sources": [
    { "id": "vault-inbox", "kind": "vault", "label": "Vault inbox", "path": "00-inbox", "enabled": true },
    { "id": "workboard", "kind": "vault", "label": "Workboard", "path": "10-workboard/workboard.md", "enabled": true },
    { "id": "calendar", "kind": "mcp", "label": "Today's calendar",
      "tool": "mcp__google-calendar__list_events",
      "args": { "timeMin": "$TODAY_START", "timeMax": "$TODAY_END" }, "enabled": true },
    { "id": "tasks", "kind": "command", "label": "Google Tasks", "command": "gtsk list --json",
      "env": { "GTSK_TOKEN": "$SECRET:gtsk_token" }, "enabled": false }
  ]
}
```

`$PKB_ROOT` overrides `root` if set. Nothing writes to a source — see [DESIGN.md](DESIGN.md#sources-are-read-only).

### Source kinds

| `kind` | Reads from | Needs |
|---|---|---|
| `vault` | A path inside your vault | Nothing — always available |
| `mcp` | An MCP tool, by name | That MCP server connected |
| `command` | A shell command's stdout | The command to exist |

`mcp` tool names are specific to your install — `/mcp` lists what you actually have, and the plugin reports a missing tool rather than guessing at a similar name.

Substitutions available in `args` and `command`: `$TODAY`, `$NOW`, `$TODAY_START`, `$TODAY_END`, `$VAULT`. `$SECRET:<key>` appears only in an `env` map and resolves from the machine-local `secrets`.

**Credentials never go in the vault config — it is committed.** An `mcp` source's auth belongs to the MCP server; a `command` source takes `$SECRET:<key>` and the value lives in `~/.config/pv-personal-kb/config.json`. `/pkb-commit` checks for this at the value level, not just by filename.

`/pkb-morning sources` lists what's configured, tests each one, and reports `ok` / `empty` / `failed` per source — which is also how you add or disable one.

## Updating

**The plugin:**

```bash
claude plugin update pv-personal-kb@pankajvaghela
```

**The vault** — the folders and scaffold files `/pkb-setup` copied in are a one-time snapshot, and nothing updates them on its own:

```
/pkb-upgrade
```

It creates folders that are new, copies scaffold files that are missing, and **shows a diff for any that differ rather than overwriting your edits**. `CHANGELOG.md` records which versions changed structure, and `/pkb-upgrade check` reports without changing anything.

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

Dates are ISO-8601, always. `created` is never rewritten; `updated` changes whenever the note does.

Type-specific fields: `project` → `owner`, `due`, `outcome`. `person` → `relationship`, `last_contact`. `trip` → `start`, `end`, `places`, `people`. `goal` → `target`, `horizon` (`life` | `year` | `quarter` | `season`).

## If you happen to use Obsidian

*Open folder as vault* → pick your vault path. That's all there is to it — the vault works identically in any other editor, and this section exists because Obsidian users expect setup steps, not because the plugin needs them.

To let the Templates plugin fill templates in for you, set **Template folder location** to `templates/` under Settings → **Files & Links**; the `{{title}}` and `{{date:YYYY-MM-DD}}` variables will then be substituted on insert. Notes created by the commands are correct either way, because Claude substitutes them itself.

## Requirements

Claude Code. That's it. `git` is only needed for `/pkb-commit` and `/pkb-end-of-the-day`, and Obsidian is just one of many ways to look at the result.

## License

MIT
