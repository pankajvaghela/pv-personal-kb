# Design

Why this plugin works the way it does. **[README.md](README.md) is the reference** — install, commands, config, schemas. This is the reasoning behind it, kept separate so the reference stays short enough to trust and the reasoning doesn't get lost.

The conventions skill (`skills/pkb-conventions/SKILL.md`) is the third piece: it's what Claude actually follows when working in a vault. Where this document and the skill disagree, the skill is correct — it's the one that runs.

## Principles

**Markdown is the format; everything else is a view of it.** Nothing here requires Obsidian. No command reads or writes editor state, and the plugin never touches `.obsidian/`. Delete every editor tomorrow and the vault is still a directory of readable text.

**Local files are the source of truth.** There is no mirror and no sync, because a sync is a second place for the truth to live, and reconciling two truths is the expensive part. If you want your notes on another device, that is what git is for. This is also why the sources feature is read-only, below.

**Never delete, archive.** `90-archive/` is what makes this affordable — a dead project keeps its inbound links, and the vault stays navigable. "Nothing is deleted" is only a safe rule if there's somewhere for dead things to go.

**The folders are the schema.** Structure goes in the directory tree, not in frontmatter. A field that no query consumes is a small lie you have to keep maintaining, and unused fields rot into wrong ones. The taxonomy is closed: a new top-level folder gets proposed, never created silently.

**One note = one topic.** Filenames are wiki-link targets, so a rename breaks every inbound link. Renames are allowed, but the conventions require repairing inbound links in the same pass.

**Capture and sorting are separate acts.** `/pkb-capture` never asks a question — the moment capture costs a decision, you stop capturing. `/pkb-triage` is where the judgment happens, and it proposes before it moves anything.

**The workboard is literal checkboxes.** Readable and editable as plain text on a phone, in a terminal, in any editor. A Dataview view on top is fine; a Dataview-only workboard is not, because the file has to stay readable as text.

**Wiki-links, and why.** `[[Note Title]]` isn't CommonMark, so GitHub shows it as literal text. It's still the right default for two reasons: it's the shared convention across file-based PKM tools, and it needs only the note's *filename* rather than a relative path — which matters a lot when an AI is writing the link, since a guessed relative path fails silently while a filename is either right or obviously missing. Switching to `[Note](Note.md)` is a mechanical conversion if you'd rather have GitHub-native rendering; decide while the vault is small.

**Templates are the one place the scaffold speaks Obsidian.** `{{title}}` and `{{date:YYYY-MM-DD}}` are Obsidian Templates syntax, kept because it's what makes that plugin useful. It's a deliberate exception, not a precedent — Claude substitutes those variables itself, so a note created by a command is correct with or without Obsidian installed.

## The daily loop

`/pkb-morning` and `/pkb-end-of-the-day` are two halves of one thing, and neither is much use alone.

The morning command reads your sources and writes a briefing into `05-daily/YYYY-MM/YYYY-MM-DD.md` — what's fixed, what's carried, what it proposes. The evening command reads the git history and the day's note, writes a log underneath that briefing, and commits. The seam is **`## Carried to tomorrow`**: the evening writes it, the next morning reads it.

That loop is why the log is written *against* the morning list rather than as a free-form diary. If something was on the list and didn't happen, the evening entry says so — and if the same item shows up carried for the third day running, the next morning calls that out instead of listing it a fourth time as if it were new.

Two details make it hold up in practice. The evening command reads `git log --since=midnight` **as well as** `git status`, because after any mid-day commit a status-only check would report a quiet day — the changes exist, they're just not in the working tree. And a day where nothing happened produces a short log, not a padded one.

Daily notes live in `05-daily/` rather than `00-inbox/` deliberately. A log has a different lifecycle from capture, and `/pkb-triage` should not try to file yesterday's briefing.

## Sources are read-only

The briefing never marks a Notion row processed, completes a remote task, or sends mail. Writing back would re-create the two-way sync problem this whole design avoids: once you write to a source, you have two copies of the truth to reconcile.

When something is handled, you record it in the vault. The vault is the only thing any command writes.

The source vocabulary is deliberately three kinds — `vault`, `mcp`, `command` — because that's enough to describe a calendar, a task list, or a Notion inbox without the plugin shipping an API client or holding a credential. Auth belongs to the MCP server, or to the command's own environment.

**A source that fails is not a source that is empty.** Anything reading a source reports `ok`, `empty`, or `failed` per source, and never lets a failure pass as silence. A briefing that silently drops your calendar is worse than one that admits it couldn't reach it.

## The desire space

Three tiers, and the dividing lines between them are the whole design. They look similar and are not.

| | Ends in | Lives as | Review pressure |
| --- | --- | --- | --- |
| Curiosity | knowing | `70-knowledge/` seed | none, ever |
| Wish | an act, months out | wishlist line | forced at hold expiry |
| Dream | an act, life-scale | wishlist line, `## Dreams` | none, but momentum gets surfaced |

### Wishes — an inbox for desire

`30-lifestyle/wishlist.md`, one line per wish, held until it's clear what to do with it.

It's an inbox, but not one you clear in a sitting. Every other inbox in this vault is processed as fast as possible; this one is processed **slowly, on purpose**, because desire isn't legible on the day you feel it. That single constraint produces the design:

**Capture asks nothing.** Same as `/pkb-capture` — the judgment happens at review. A wishlist entry that costs a question to write is one that never gets written. The hold starts at capture rather than at assessment, because the desire is already ageing and restarting the clock at review would defeat the only mechanism that works.

**Desire is tested by waiting, not recorded.** "How much do I want this?" answered at the moment of wanting is the impulse talking — which is exactly why high/medium/low priority collapses within a week. Time is the honest measure, so every wish gets a cooling-off period derived from cost: 7 days under $100, 14 to $500, 30 above. Anything with no cost gets 30 days, because money is capped and time isn't.

**Importance exempts you from the wait.** That is its only job here. A mattress you need but don't want will never clear a cooling-off period with any enthusiasm, so `## Needed` carries no hold at all. A need doesn't become more urgent by sitting on a list for a month.

Wishlists don't fail at storing things — storing is free. They fail because nothing ever forces a decision, so the list only grows and eventually stops being read. So `/pkb-wishlist review` forces **promote, extend, drop, or buy** on everything off hold, and flags anything off hold for 60+ days as a decision being avoided rather than a pending purchase. "Leave it" is the one answer not allowed.

**A wish leaves by being acted on.** That usually means it has become legible enough to promote — into a goal, a project, a trip, or a workboard line. Promotion is the primary exit and the one to steer toward: a wish that has been promoted has done its job. Nothing leaves by being ignored, which is what keeps this from becoming a graveyard. Dropped wishes stay in the file, checked, so you stop re-adding the same thing every few months.

### Seeds — the low-consequence ones

Not everything you want is a wish. "Jan Schoonhoven relief" isn't something to buy or do; it's something to *know about*. Those end in knowing rather than in an act, and they need none of the machinery above — no cost, no hold, no review pressure.

They're **seed notes** in `70-knowledge/` with `status: seed`: a stub that exists so the learning has somewhere to land, and so it can be linked to from a gallery visit, a project, or a wish to buy a print. A note rather than a list line because a line can be linked from nowhere, which is the entire reason this vault uses wiki-links.

The dividing line is **what the thing ends in**. Ends in an act — buy it, go there, do it — → wishlist. Ends in knowing → seed.

A seed has no urgency and must never acquire any: no due date, no count that should trend to zero. A seed you haven't gotten to isn't a failure and a list of forty isn't a problem. The moment seeds get treated as a backlog they stop being curiosities and start being guilt — which is why `/pkb-review`'s orphan-notes section explicitly skips them.

### Dreams

`## Dreams` is the last section of the same wishlist file: things you want to do in your life.

**Dreams are what you want your life to have in it; wishes are what you want next.** Both are wants and both are one line — the difference is **time horizon, not weight**. A dream isn't a goal or a project; "skydive" needs no research plan and no `## Leading actions`, and turning every dream into a project is how a dream list stops being a pleasure.

**The wording is load-bearing, not decoration.** It is *dreams* and *things you want to do in your life* — never "bucket list", which comes from "kick the bucket". A list that reads as an invitation gets used; one that reads as a deadline gets avoided.

No pressure, deliberately. A dream is on the list because it's true about you, not because it's due, and it's allowed to wait years. `/pkb-review` surfaces only the ones that have *started to move*, never an untouched one as overdue. When a dream gets real — a date forming, money to save, a skill to build first — `/pkb-dreams pursue` promotes it to a goal note in `20-goals/`, where `## Leading actions` and `## Progress` can hold the working-out. It hasn't stopped being a dream; it has acquired somewhere to be worked on.

The review pressure across the three tiers is **deliberately uneven**, and that's the part to protect from well-meaning improvement: ignoring a wish is information about you, ignoring a seed or a dream means nothing. A command that nags about the latter turns something pleasurable into a debt.

## Two config files, split by what belongs in git

`~/.config/pv-personal-kb/config.json` holds the vault's path and secrets. `<vault>/.pkb/config.json` holds everything else — the name, the sources — and is committed.

The split is the point. Configuration that *describes the vault* belongs with the vault, so it's versioned, diffable, and survives moving to another machine: clone the repo, set one path, and the vault is itself again. Only the two things that genuinely can't live there are kept out — the path that finds the vault when you're not standing in it, and secrets.

Which means **the vault config is committed, so no credential ever goes in it.** A source that needs auth references it as `$SECRET:<key>`, resolved from the machine config at read time. `/pkb-commit` checks for this specifically, at the value level rather than by filename — a token pasted into a source's `command` would sail straight past a filename scan.

## The plugin and the vault update separately

The plugin's commands update through `claude plugin update`. The vault's folders and scaffold files do not — `/pkb-setup` copies them once and nothing links the copy back.

That's why `/pkb-upgrade` exists, and why it is **additive only**: it creates folders that are new and copies scaffold files that are missing, shows a diff rather than overwriting anything that differs, and never deletes or renames. A vault is meant to be a folder of files you own, and silently rewriting them on every plugin update is the wrong behaviour for personal notes. It touches structure and scaffold files only — **never a note**, not one line.
