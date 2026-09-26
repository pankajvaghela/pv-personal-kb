# Design

Why this plugin works the way it does. **[README.md](README.md) is the reference** — install, commands, config, schemas. This is the reasoning behind it, kept separate so the reference stays short enough to trust and the reasoning doesn't get lost.

The conventions skill (`skills/pkb-conventions/SKILL.md`) is the third piece: it's what Claude actually follows when working in a vault. Where this document and the skill disagree, the skill is correct — it's the one that runs.

## Principles

**Markdown is the format; everything else is a view of it.** Nothing here requires Obsidian. No command reads or writes editor state, and the plugin never touches `.obsidian/`. Delete every editor tomorrow and the vault is still a directory of readable text.

**Local files are the source of truth.** There is no mirror and no sync, because a sync is a second place for the truth to live, and reconciling two truths is the expensive part. If you want your notes on another device, that is what git is for. This is also why the sources feature is read-only, below.

**Never delete, archive.** `90-archive/` is what makes this affordable — a dead project keeps its inbound links, and the vault stays navigable. "Nothing is deleted" is only a safe rule if there's somewhere for dead things to go.

**The folders are the schema.** Structure goes in the directory tree, not in frontmatter. A field that no query consumes is a small lie you have to keep maintaining, and unused fields rot into wrong ones. The taxonomy is closed: a new top-level folder gets proposed, never created silently.

**One note = one topic.** Filenames are wiki-link targets, so a rename breaks every inbound link. Renames are allowed, but the conventions require repairing inbound links in the same pass — which is why `/pkb-rename` exists rather than leaving that as a sentence to remember. See below.

**Capture and sorting are separate acts.** `/pkb-capture` never asks a question — the moment capture costs a decision, you stop capturing. `/pkb-triage` is where the judgment happens, and it proposes before it moves anything.

**The workboard is literal checkboxes.** Readable and editable as plain text on a phone, in a terminal, in any editor. A Dataview view on top is fine; a Dataview-only workboard is not, because the file has to stay readable as text.

**Wiki-links, and why.** `[[Note Title]]` isn't CommonMark, so GitHub shows it as literal text. It's still the right default for two reasons: it's the shared convention across file-based PKM tools, and it needs only the note's *filename* rather than a relative path — which matters a lot when an AI is writing the link, since a guessed relative path fails silently while a filename is either right or obviously missing. Switching to `[Note](Note.md)` is a mechanical conversion if you'd rather have GitHub-native rendering; decide while the vault is small.

**Templates are the one place the scaffold speaks Obsidian.** `{{title}}` and `{{date:YYYY-MM-DD}}` are Obsidian Templates syntax, kept because it's what makes that plugin useful. It's a deliberate exception, not a precedent — Claude substitutes those variables itself, so a note created by a command is correct with or without Obsidian installed.

## The instance's conventions win

Everything this plugin ships is a **default**. A vault is allowed to amend it, the amendment is recorded in `<root>/AGENTS.md` under `## Local conventions`, and **where the two disagree, the vault wins.**

This is the missing half of an existing rule. The conventions already said to never invent a top-level folder — to propose it instead — but they never said where an accepted proposal goes. Without that, an exception lives in the user's memory, and the next session either re-proposes it or, worse, sees a vault that violates the shipped conventions and "fixes" it back. A structure that is deliberate and undocumented is indistinguishable from a mistake, and every tool reading the vault will treat it as one.

So a vault may allow project subfolders, add a grouping level under `20-goals/`, keep a folder this plugin has never heard of, or add a `type` value. `AGENTS.md` is where that is written down, and it is authoritative for the vault it sits in — the skill and the commands ship the defaults, `AGENTS.md` holds the local law.

The consequence lands hardest on `/pkb-doctor`, because doctor's entire job is deciding what counts as a problem. A linter that checks a vault against a specification the vault has explicitly amended does not produce findings; it produces noise, and noise is what teaches someone to stop reading the report. Doctor therefore reads the local conventions first and lints against the **effective** rules. A structure `AGENTS.md` permits is correct by definition.

There is one constraint, and it is the reason this works at all: **an amendment cannot be silent.** The whole value is that the exception is written where every reader will find it, so it stops being an exception and becomes the convention.

## A rename is one change, not two

Wiki-links are matched on **filename**, which is what makes them robust — no relative paths to get wrong — and it is also what makes a rename dangerous in a specific way.

A broken link in this vault does not look broken. A link to a note that has not been written yet is a normal, deliberate thing here; the conventions say to link liberally to notes that do not exist. So a rename that fails to repair its inbound links produces notes that look exactly like notes that are working: the link renders as literal text in a plain editor, and in a wiki-link-aware one it renders in whatever styling the tool uses for unresolved targets — which is the same styling as a marker you wrote on purpose. There is nothing to notice.

That is the argument for a command rather than a convention. The rule was always correct and always stated, and a rule that depends on remembering to do a second thing in the same pass as the first will eventually be done halfway — and done halfway here means a vault that is quietly full of dead pointers, discovered months later. `/pkb-rename` makes the two halves one operation: find the note, refuse the destination if it is occupied, show the inbound links before touching anything, then move the file, correct the title, and rewrite every link form in a single pass.

Two details generalize. **The destination check is not paranoia.** Renaming onto an existing note destroys one of them, and on a filesystem that is a `mv` that reads as a success. And **the preview before the write** follows the same rule as bulk triage: when one action touches many files, being wrong is expensive and slow to undo, so the plan is shown first and the operation is confirmed before it happens.

A rename also corrects `title` to match the new filename, because that agreement is load-bearing elsewhere — the travels index links trips by their `title` field, so a note whose title and filename disagree produces an index row pointing nowhere. `/pkb-doctor` checks that agreement across the whole vault, which is the other half of the same coin.

## The vault checks itself

`/pkb-doctor` is a linter, not a review, and the distinction is the design.

`/pkb-review` is weekly and behavioural. It asks what is stale, what needs a decision, what has been avoided — questions whose answers are judgments, and whose value comes from being asked on a rhythm. Doctor asks something narrower and answerable: **is the vault internally consistent?** Titles against filenames, frontmatter against the schema, links against what exists, folders against the taxonomy. Every finding is a fact you can verify, which is why it is run on demand rather than on a schedule, and why a clean run is a success rather than a quiet week.

Three stances make it safe to run on a vault full of personal notes.

**It reports; it does not tidy.** The default is read-only, and `fix` is deliberately short — quoting a `title` that breaks YAML, and filling a missing `updated` from `created`. That is the entire automatic list, because those are the only two repairs with exactly one correct answer. Everything else is offered one at a time and never in a batch: a wall of proposed changes is one that gets approved without being read, which is the same reasoning that has `/pkb-triage` propose before it moves anything.

**It splits broken links, because most broken links are not broken.** A link to a note that has not been written yet is a marker in this vault, and reporting forty of them as errors would train you to ignore the report. The actionable list is the near-misses — a target within an edit of an existing note — and that is the only part presented as something to fix. Everywhere else, the answer is "write the note", and only the user knows which case they are looking at.

**It never deletes, never merges, and never guesses a date.** Duplicate notes are reported as candidates, not resolved. A stray file is named, not filed. An ambiguous `03/04/2026` is a finding, not a value.

One check is there because it was previously too late. Doctor reads the committed `.pkb/config.json` for a literal credential using the same value-level test `/pkb-commit` runs — but it runs it *before* anything is staged, rather than at the commit that would have published it.

## The daily loop

`/pkb-morning` and `/pkb-end-of-the-day` are two halves of one thing, and neither is much use alone.

The morning command reads your sources and writes a briefing into `05-daily/YYYY-MM/YYYY-MM-DD.md` — what's fixed, what's carried, what it proposes. The evening command reads the git history and the day's note, writes a log underneath that briefing, and commits. The seam is **`## Carried to tomorrow`**: the evening writes it, the next morning reads it.

That loop is why the log is written *against* the morning list rather than as a free-form diary. If something was on the list and didn't happen, the evening entry says so — and if the same item shows up carried for the third day running, the next morning calls that out instead of listing it a fourth time as if it were new.

Two details make it hold up in practice. The evening command reads `git log --since=midnight` **as well as** `git status`, because after any mid-day commit a status-only check would report a quiet day — the changes exist, they're just not in the working tree. And a day where nothing happened produces a short log, not a padded one.

**Two commands write one file, so the file is split by ownership.** Morning owns the frontmatter and the briefing block; the evening owns `## Log` and `## Habits`. Neither rewrites or regenerates the other's part, which is the only reason either can be re-run safely at any point in the day. It is a small rule with an outsized failure mode: both sections are unreconstructable, and a morning re-run on a day already closed out would have regenerated the note from its briefing — taking the evening's log with it, and taking that day's habit ticks with it. The log would at least have been missed. The ticks would not: they would surface months later as a gap reading as a missed day, which is exactly the false signal the gap-versus-miss rule exists to prevent.

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

## Habits are the one thing that never completes

The vault had two shapes for "something you intend to do". An **action** completes — it is done or it is not, and the workboard holds it. A **goal** arrives — it has a target and then it is reached. Habits are the third shape, and the vault did not have it: a habit neither completes nor arrives. It is either being kept or it is not, and it is never finished. `30-lifestyle/habits.md` holds the definitions for exactly that reason — putting "gym" on the workboard means a line that can never be checked off, and a list of things that can never be checked off is a list you stop reading.

**The ticks live in the daily note, and that decision is the whole feature.** The obvious alternative — a habits file with one row per day — fails on friction: it is a second place to update every day, separate from everything else you already do, and a tracking system that requires its own ritual is one that survives about three weeks. The daily note already exists and `/pkb-end-of-the-day` already writes it, so the tick costs nothing extra. The objection that answering "has gym slipped?" now means reading weeks of daily notes is not a real cost — that is a grep across a month folder, which is what this vault is for.

**A gap is not a miss, and this is the rule that decides whether any of it is trustworthy.** A day with no `## Habits` section is *unknown*; a day with the section and an unchecked box is a *miss*. Collapse the two and you get regressions that never happened, which is the fastest possible route to ignoring the report and then abandoning the tracking. It is the same distinction as *a source that fails is not a source that is empty*, and it forces one behaviour: if the user does not answer the evening prompt, **nothing is written**. An all-unchecked day invented on their behalf would be a fabricated record, and a gap is both more honest and more useful.

**No streak is ever stored.** Same rule as the wishlist's totals and the travels index's rows — a thing that can be derived is not stored — and it is sharper here, because a streak turns the number into the thing being maintained. Worse, a stored streak is simply wrong the moment a day is missed, which is precisely when someone would be tempted to correct it by hand.

**And the report has to be able to say "drop it".** A habit that is consistently missed is often the wrong habit — too ambitious, badly defined, or no longer wanted — so every flag ends in a question whose answers include changing the cadence and abandoning it. A report whose only available verdict is *you failed* becomes a wall of failure, gets skipped, and takes the tracking with it. That is the same reasoning that keeps `## Dreams` from ever reporting an untouched item as overdue: review pressure is a tool, and applied where it cannot help it destroys the thing it was aimed at.

## Indexes are generated, not curated

`40-travels/travels.md` is the one file in the vault that is a table, and it exists because a trip folder is the one place where you want the whole set at a glance. It's built from the frontmatter of the trip notes next to it.

The distinction matters more than the file does. A curated index is a **second place a fact lives**, and a second place is a second thing to keep true — the failure is not that it's wrong on the day you write it, it's that it's right on the day you write it and drifts silently afterwards. That's the same reasoning as the sources being read-only and the wishlist storing no computed totals: one fact, one home.

So the index is a **view**, and the trip note is the record. A row that's wrong means the frontmatter is wrong, and the fix is there — hand-editing a row gets reverted the next time the file is rebuilt, which is a feature. A generated index is allowed to be a *file* rather than a query because the vault has to stay readable without Dataview, Obsidian, or this plugin; a rendered table is still plain Markdown, and a stale one is visible rather than silent.

The line to hold: the scaffold ships an empty index, and only the command writes it. Nothing else in the vault is generated, and no command should acquire a second file like this without the same property — rebuildable from the notes, worth nothing on its own.

One detail generalizes past this file. The table has a **Start column and an End column, not a `2026-11-03 → 2026-11-14` range**, and people get a column of their own next to places. A range in a cell looks tidier and is worse: it's a rendering of two facts that can no longer be sorted, compared, or read by anything but an eye. The same reasoning keeps the wishlist from storing a total and the sources read-only — **a thing that can be derived should not be the thing that is stored.** Render freely; store fields.

## What a trip note refuses to hold

The trip template is shaped by how a trip actually gets planned. The interesting part is what it leaves out.

Two structural findings came first. **A trip is made of legs** — a trip that moves between two cities has two stretches, each with its own stay and its own flight between them, and a flat list of days cannot say so. `## Outline` now holds one row per leg. And **the event is usually the reason for the trip**: a festival pass carries a price, a booking reference, and a payment status, and the flights and the accommodation get arranged around it. A pass is a booking, so it belongs in the same `## Booked` list as everything else.

The day-by-day gained a time column for the same reason: what a trip itinerary is actually made of is *when*, and a flight at 06:50, a check-in at 15:00, and a dinner at 20:00 is three facts, not one. A weekday column was considered and dropped — it follows from the date, and this vault does not store what it can derive.

**A heading true of every trip and specific to none does not go unfilled — it gets copied forward wrong.** A generic "phrases to learn" list and a link to one trip's festival reappear under the next trip's city, still naming the last one. That is the argument against shipping "useful apps" and "emergency contacts", and it is why the template has none.

**No total row in the budget.** Estimated against actual, per category, and stop. A total is a sum, and a stored sum is wrong the moment a line changes — the same rule that keeps a wishlist from carrying its own cost running total. Add the column up when you want to know it; that takes a second and is always right.

**No trip to-do list.** This is the one worth being deliberate about, because the document it came from has a prominent one, and copying it would duplicate the workboard. An action with a date belongs on the workboard, where `/pkb-morning` reads it and `/pkb-review` will notice it going stale; a checklist inside a trip note is a second list nobody sweeps. Trip notes are opened the week before the trip, which is precisely when a forgotten action is too late to fix.

**And `## Booked` does something a record does not.** A checkbox there means *confirmed*, so the section doubles as the trip's status: a trip with dates and nothing ticked is visibly not yet real. That is why the travels index reports dates and the note reports readiness — the index can see a trip's dates from the outside, and only the note knows whether a single thing has been booked.

## Two config files, split by what belongs in git

`~/.config/pv-personal-kb/config.json` holds the vault's path and secrets. `<vault>/.pkb/config.json` holds everything else — the name, the sources — and is committed.

The split is the point. Configuration that *describes the vault* belongs with the vault, so it's versioned, diffable, and survives moving to another machine: clone the repo, set one path, and the vault is itself again. Only the two things that genuinely can't live there are kept out — the path that finds the vault when you're not standing in it, and secrets.

Which means **the vault config is committed, so no credential ever goes in it.** A source that needs auth references it as `$SECRET:<key>`, resolved from the machine config at read time. `/pkb-commit` checks for this specifically, at the value level rather than by filename — a token pasted into a source's `command` would sail straight past a filename scan.

## The plugin and the vault update separately

The plugin's commands update through `claude plugin update`. The vault's folders and scaffold files do not — `/pkb-setup` copies them once and nothing links the copy back.

That's why `/pkb-upgrade` exists, and why it is **additive only**: it creates folders that are new and copies scaffold files that are missing, shows a diff rather than overwriting anything that differs, and never deletes or renames. A vault is meant to be a folder of files you own, and silently rewriting them on every plugin update is the wrong behaviour for personal notes. It touches structure and scaffold files only — **never a note**, not one line.

## The conventions skill is split by when you need it

The skill began as one file and grew to 28 KB. Every command loads it — which meant `/pkb-capture`, a command whose entire job is to append one bullet without asking a question, was loading the wishlist's cooling-off periods, the travels table's column rules, and the workboard's tag syntax along with the twenty lines it actually needed.

**Context is a budget, and a skill that is always loaded should hold only what is always true.** The core `SKILL.md` is now 7.9 KB — 72% below where it started — and it got there in two passes that cut along different lines.

The first was **by area**. The core keeps what every task touches: resolving the vault root, the folder taxonomy, the frontmatter schema, the link forms, the hard rules. Reference files hold what only some tasks touch — desire, habits, travels, workboard, daily notes, sources — each read only when the task is in it.

The second was **by kind**, and it is the more interesting cut. What remained in core was correct but twice the size it needed to be, because it carried its own justification. "What this vault depends on" is a table of what is required against what is optional, with a paragraph explaining what each option costs. Why wiki-links are chosen over relative paths. Why the template variables are the one place Obsidian syntax is allowed. All of it is worth reading once and none of it is worth loading on every message.

So the rule that settled the second pass: **core holds what a task must do; a reference holds why it is done that way.** The instruction stays — link with `[[Note Title]]`, keep templates free of identity fields, prefer plain Markdown where it costs nothing — and the argument for it moves to `references/format.md`. An agent following the core still does the right thing; it simply stops paying for the reasoning every time, and reads it when it is actually choosing between two features or editing a template.

The risk in both passes is the same, and it is the one to watch: **content that moves out of core stops being seen by default.** A reference nobody knows to open is worse than a verbose core, because the material becomes invisible rather than merely expensive. That is why the reference table names the *trigger* for each file rather than its topic, and why the most load-bearing material — the taxonomy, the hard rules, the precedence of the vault's own conventions — deliberately stayed in core even where it could have been compressed further.

Two properties make the split hold rather than quietly rot.

**A reference nobody knows to open is worse than no split**, because the content becomes invisible rather than merely verbose. So `SKILL.md` does not list its references as a table of contents — it names the *trigger* for each one: read `references/travels.md` when the task touches a trip or the index, `references/sources.md` when a task reads from outside the vault. The reader is told when, not just what.

**The conflict rule is written down.** Where a reference and the core disagree, the reference is the more specific statement and wins for its own area. Without that line, a split document develops two answers to one question and the reader has to guess which is current.

Nothing was dropped in the move, and the organizing principle is the one the vault already uses everywhere else: one fact, one home, and the home is wherever it is actually needed.
