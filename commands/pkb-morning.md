---
description: Start-of-day briefing — pull signals from configured sources and turn them into action points
argument-hint: [optional: "sources" to list and test the configured sources]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`). If `$ARGUMENTS` is `sources`, jump to **Managing sources** at the end and stop there.

Otherwise, build today's briefing.

## 1 — Read the source registry

Read `<root>/.pkb/config.json` and take its `sources` array. The schema is documented in the conventions skill. Sources live in the vault rather than the machine config so they are versioned with the vault and survive a move to another machine.

- **Vaults from before 0.8** have no `.pkb/config.json` — their `sources` are still in `~/.config/pv-personal-kb/config.json`. Read those and continue, but tell the user to run `/pkb-upgrade` to move them into the vault.

- **No `sources` key, or every entry disabled** → say so plainly, and show the two sources that need no setup: `vault` entries pointing at `00-inbox/` and `10-workboard/workboard.md`. Offer to add them. Do not run a briefing against nothing and present the silence as a clear day.
- **Sources exist** → continue.

## 2 — Fetch, one source at a time

For each enabled source, in order:

| `kind` | How to read it |
|---|---|
| `vault` | Read the path inside `<root>`. |
| `mcp` | Call the named MCP tool with its `args`. |
| `command` | Run it with Bash. If the source has an `env` map, resolve each `$SECRET:<key>` from the `secrets` map in `~/.config/pv-personal-kb/config.json` and pass it as that environment variable for the run. |

Resolve `$TODAY`, `$NOW`, `$TODAY_START`, `$TODAY_END`, and `$VAULT` in `args` and `command` **before** running anything.

A `$SECRET:` key that is missing from the machine config makes the source `failed` — name the missing key, never the value, and never fall back to a literal token found anywhere else.

**Report each source's status as you go** — `ok`, `empty`, or `failed`. One failure must never stop the run, and a source that failed must never be quietly omitted: a briefing that silently drops your calendar is worse than one that admits it could not reach it.

If an `mcp` tool name does not resolve, say which one and tell the user to run `/mcp` to see what is actually connected. Never substitute a neighbouring tool name that looks close.

**Then read the previous daily note** — the most recent file before today under `05-daily/*/`, by filename. Take its `## Carried to tomorrow` list and hold it: those belong in the Carried bucket below. This is the seam with `/pkb-end-of-the-day`, and skipping it is how an item gets carried indefinitely without anyone noticing. If an item appears there for the third day running, say so in the briefing rather than listing it a fourth time as if it were new.

## 3 — Synthesize

This is the whole job. Do not dump the raw signals and call it a briefing.

Order the day:

1. **Fixed** — anything with a time already attached. These anchor the day and are the one thing you may not reorder.
2. **Carried** — workboard items past their `📅` date, or sitting in `Now` for more than a week.
3. **Proposed** — new inbound from sources that needs a decision today.
4. **Everything else** — worth knowing, not worth acting on. One line, or leave it out.

Rules:

- **Deduplicate hard.** The same commitment usually arrives twice — a meeting invite and an email about it, a task and a message referencing it. One line, not two.
- **Cap the proposed list at seven.** A briefing longer than one screen is a briefing nobody reads. If more remains, say how much you left out rather than listing it.
- **Separate fact from suggestion.** "You have a 10:00 standup" is a fact. "Draft the proposal before then" is your suggestion, and must read like one.
- **Never invent an item.** Every line traces to a source. If the sources yield nothing, say the day is clear — do not manufacture filler to make the briefing look useful.
- **Name the source** for anything non-obvious, so the user can see where it came from.

## 4 — Present, then confirm

Show the briefing. **Write nothing yet.**

```
## Thursday 2026-09-26

**Fixed**
- 10:00 Standup
- 16:00 Dentist

**Carried**
- [ ] Ship the plugin — due yesterday #project/pv-personal-kb

**Proposed**
- Draft the proposal before 16:00 — the client has asked twice   ← notion-inbox
- Reply to Sam about the quote                                   ← mail

Not reached: calendar (tool name not found — check /mcp)
```

Then ask, in one round, which of the **proposed** items to add to the workboard. Do not ask a second question.

## 5 — Write

On confirmation, two writes.

**a. The daily note — `05-daily/YYYY-MM/YYYY-MM-DD.md`.** Notes are filed under the month they belong to, so create the month folder first if it does not exist (`mkdir -p` — never assume it is there). The record of what the day looked like when it started.

```yaml
---
title: 2026-09-26
type: daily
status: active
created: 2026-09-26
updated: 2026-09-26
sources: [vault-inbox, calendar, notion-inbox]
tags: []
---
```

Beneath it, the briefing exactly as shown, then an empty `## Log` — that is where the day gets written up later.

**This command owns two things in that file and nothing else: the frontmatter it writes, and the briefing block.** `## Log` and `## Habits` belong to `/pkb-end-of-the-day`. Never rewrite, reorder, clear, reformat, or "tidy" them — and if today's note has already been closed out, refreshing the briefing must leave everything below it exactly as it is.

That is not a nicety. The evening log is committed and cannot be reconstructed from the note, and the `## Habits` ticks are the **only** record of that day's habits — so a write step that regenerates the file from the briefing would silently destroy both, and the habit damage would be invisible, showing up months later as a gap that reads as a day you failed. Touch your own sections and stop.

**b. The workboard** — append the confirmed items under `## Now` in `10-workboard/workboard.md`, with `📅 YYYY-MM-DD` when the item carries a date.

**Running this twice on the same day must not duplicate anything.** If `05-daily/YYYY-MM/<today>.md` exists, update the briefing in place rather than writing a second copy — and leave `## Log` and `## Habits` untouched, however far the day has already got. Before adding a workboard line, check for an existing line with the same text and skip it.

## 6 — Report

Two or three lines: what was written, how many sources answered, which did not and why. If a source failed, name the next thing to check — `/pkb-morning sources` for the registry, `/mcp` for tool names.

## Managing sources

`/pkb-morning sources` — read the `sources` array and show a table: `id`, `kind`, what it points at, enabled. Then test each enabled source and report `ok` / `empty` / `failed` with the reason. Never print a resolved secret.

If the user asks to add, enable, or disable one, edit the `sources` array in `<root>/.pkb/config.json` and confirm the change. Ask for whatever the mechanism needs — a `vault` path, an `mcp` tool name, or a `command` — and nothing more.

**A source that needs a credential takes it from `$SECRET:<key>`, never literally.** If the user offers a token to paste into the config, refuse and put it in the `secrets` map of `~/.config/pv-personal-kb/config.json` instead — the vault config is committed, so a token written there is a token published. Say that in one sentence, then do the right thing.

## Hard rules

- **Sources are read-only.** Never mark a Notion row processed, complete a remote task, or send anything. The vault is the only thing this command writes. Writing back re-creates the two-way sync problem this whole design exists to avoid.
- **Never store a credential in the vault.** `<root>/.pkb/config.json` is committed; secrets belong in `~/.config/pv-personal-kb/config.json`, which is not. Source auth otherwise belongs to the MCP server or the command's own environment.
- **Never fail silently on a source.** Report it, and never let a failed source look like an empty one.
- **Never present a briefing you could not build.** If every source fails, say that — do not show an empty day.
