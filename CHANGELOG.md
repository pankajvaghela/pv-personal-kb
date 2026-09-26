# Changelog

Two kinds of change live here, and the difference matters if you have a vault already:

- **Plugin changes** — commands, the skill, the agent. These arrive with `claude plugin update`. Nothing to do.
- **Existing vaults** — anything that changes the folder structure or the scaffold files (`AGENTS.md`, `Home.md`, `.gitignore`, `templates/`, `workboard.md`, `.pkb/`). These do **not** propagate on their own. Run `/pkb-upgrade`.

Every version below states which it is, so you can tell at a glance whether an upgrade needs action.

## 0.14.0

- **A vault's own conventions now beat the plugin's defaults.** Everything the plugin ships is a *default*; `<root>/AGENTS.md` is the vault's own law, and where the two disagree, `AGENTS.md` wins. A vault is allowed to nest project subfolders, group goals by area, keep a folder this plugin has never heard of, or add a `type` value — none of that is a violation, and nothing should report it as one. The conventions skill now reads `<root>/AGENTS.md` at the start of every task.
- **An accepted exception finally has somewhere to go.** The rule was always "never invent a top-level folder — propose it instead", but nothing said where a proposal went once agreed. `## Local conventions` in `AGENTS.md` is that place. The other half matters as much: an exception that lives only in someone's memory is indistinguishable from a mistake, and the next session will either re-propose it or helpfully undo it.
- **`/pkb-doctor` lints against the effective rules, not the shipped ones.** This is the command the change matters most for, because deciding what counts as a problem is its whole job — a linter checking a vault against a specification the vault has explicitly amended does not produce findings, it produces noise. It reads the local conventions first, states which ones it applied, and skips the type/folder and stray-file checks entirely for anything `AGENTS.md` permits.
- **Add `/pkb-habits`, and `30-lifestyle/habits.md`.** A habit is the third shape of intention the vault was missing: an action completes and a goal arrives, but a habit never finishes — it is either being kept or it is not. That is why it is not on the workboard, where every line is expected to close.
- **The ticks live in the daily note, under `## Habits`, not in the definition file.** This is the decision the feature turns on, and it is about friction: a tracker that needs its own daily ritual dies in about three weeks, while the daily note already exists and `/pkb-end-of-the-day` already writes it. The definitions file holds what the habits *are*, so changing a cadence never rewrites history.
- **A gap is not a miss.** A day with no `## Habits` section is *unknown*; a day with the section and an unchecked box is a *miss*. Collapsing the two invents regressions that did not happen, which is the fastest way to stop trusting the report — the same rule as "a source that fails is not a source that is empty". It forces one behaviour: if you do not answer the evening prompt, **nothing is written**. An all-unchecked day invented on your behalf is a fabricated record.
- **Never a stored streak.** Adherence, streaks, and regression flags are all computed from the days at read time — a stored streak is wrong the moment a day is missed, and it turns the number into the thing being maintained.
- **The daily note now has two writers with split ownership.** `/pkb-morning` owns the frontmatter and the briefing; `/pkb-end-of-the-day` owns `## Log` and `## Habits`. Neither may rewrite or regenerate the other's sections, so a second run of either is safe at any point in the day. Without this, re-running `/pkb-morning` on a day already closed out would have regenerated the file from its briefing and silently destroyed the evening log and that day's habit ticks — and the habit loss would have been invisible, showing up months later as a gap reading as a missed day.
- **`/pkb-habits check` reports a decline only when it holds across consecutive weeks**, states its coverage first, and ends every flag with a question whose answers include **dropping the habit**. A cadence you keep missing is often the wrong cadence, and a report that can only say "you failed" is one that gets skipped. `/pkb-review` gains a Habits section with the same rules.
- **Existing vaults:** run `/pkb-upgrade`. It copies in the new `30-lifestyle/habits.md`. `AGENTS.md` has changed — it gained a Habits section and the `## Local conventions` area, and its opening now says it is authoritative for your vault rather than a fallback — so the upgrade will show you that diff and ask rather than overwriting, since you may have edited it. No notes are touched.

## 0.13.0

- **Add `/pkb-rename`.** The conventions have always said a rename must repair inbound wiki-links in the same pass, and until now there was no tool that did it — the rule was a sentence someone had to remember. The command resolves the note, refuses to rename onto an existing file, shows the inbound links it found before touching anything, then moves the file, corrects `title` to match the new filename, and rewrites every link form (`[[Old]]`, `[[Old|alias]]`, `[[Old#Heading]]`, `![[Old]]`, `[[Old.md]]`) in one pass. It regenerates the travels index afterwards when the note was a trip. It refuses to rename structural files — `travels.md`, `wishlist.md`, `workboard.md`, `Home.md` — because a command owns each of those paths.
- **Add `/pkb-doctor`.** A read-only structural check: title/filename agreement, frontmatter validity, `type` against folder, broken wiki-links, duplicate notes, files outside the taxonomy, orphaned attachments, a literal credential in the committed `.pkb/config.json`, and scaffold drift. It is not `/pkb-review` — that is weekly and behavioural, this is on-demand and structural, and the review now points at it for the exhaustive link pass.
- **A title and a filename that disagree is the finding that matters most**, because links resolve against filenames and the travels index links trips by their `title` field. Doctor reports both directions and applies neither on its own.
- **Broken links are split, because most are not broken.** A link to a note that does not exist yet is a marker in this vault, not a fault. Doctor separates near-misses — targets within an edit or two of an existing note — from links whose target has never existed, and only presents the first group as actionable.
- **`/pkb-doctor fix` is deliberately short.** It quotes a `title` that breaks YAML and fills a missing `updated` from `created`, and that is the whole automatic list. Everything else — a title mismatch, a near-miss link, a duplicate, a stray file — is offered one at a time and never batched, because each is a judgment and a wall of them is one that gets approved without being read.
- **The conventions skill is split.** It had grown to 350 lines and 28 KB, loaded in full by every command — including `/pkb-capture`, which needs about twenty of them. The core `SKILL.md` now holds what applies to every task (vault root, taxonomy, frontmatter, links, hard rules) and five reference files hold the areas that only some tasks touch: `desire.md`, `travels.md`, `workboard.md`, `daily.md`, `sources.md`. Nothing was dropped, and the split is by *when you need it*, not by topic size.
- **The core skill is then cut again, to 7.9 KB — 72% below where it started.** The first split moved whole areas out; this pass moved *rationale* out. "What this vault depends on", why wiki-links are deliberate, what Obsidian syntax costs, and how templates handle variables are all worth reading once and not worth loading on every message, so they now live in `references/format.md`. The rule that decided it: **core holds what a task must do; a reference holds why it is done that way.** The instruction stays, the argument for it moves.
- **Existing vaults:** nothing to do. No folder, scaffold file, or note changed — only commands and the skill, which update with the plugin.
- _0.13.0 and 0.14.0 shipped together in one commit and one release — `v0.14.0`. Only 0.14.0 needs a vault action._

## 0.12.2

- **The trip template handles the trips people actually take.** `## Outline` is now explicitly **legs** — one row per city or stretch — because a trip that moves between two cities could not be expressed at all before. `## Plan` gained a **Time** column, because what a trip itinerary is made of is *when*: a flight at 06:50, a check-in at 15:00, and a dinner at 20:00 is three rows, not one.
- **A trip built around an event is the ordinary case.** `### Events` now says what a pass actually carries — place, dates, pass type, booking reference, whether it is paid — since the pass is a booking like any other and the thing the rest of the trip arranges itself around.
- The `## Plan` weekday column was considered and dropped: it follows from the date, and this vault does not store what it can derive. The date column is ISO.
- `## Budget` now notes where a shared cost goes — the notes column, as `900/3 = 300`, which says more than `300`.
- **A generic section does not go unfilled, it gets copied forward wrong.** A "phrases to learn" list and a link to one trip's festival survive into the next trip, still naming the last city. The template therefore has no "useful apps" and no "emergency contacts" — headings true of every trip and specific to none.
- **Existing vaults:** run `/pkb-upgrade`. It copies the updated `templates/trip.md` — it will show you the diff and ask rather than overwriting, since you may have reshaped that template.
- _0.12.0 through 0.12.2 are one feature released in three commits: the travels index, its columns, and the trip note it reads._

## 0.12.1

- **The travels table changes shape.** Columns are now `| Trip | Start | End | Places | People |` — start and end are separate columns instead of one `2026-11-03 → 2026-11-14` range, and who you travelled with gets a column of its own.
- A range in a single cell is a rendering of two facts that can no longer be sorted or compared. The dates were always two fields; now the table says so. Missing values are `—` rather than blank, which reads as "nothing here" instead of a rendering mistake.
- New `people` field on `trip` notes. It holds plain names, not links — the index links each one to their `60-people/` note **when that note exists**, and leaves it as text when it does not, so the index never manufactures a broken link.
- `## Planned` sorts by `start`, `## Been` by `end`, each falling back to the other date when the sort key is missing.
- **The trip template grows up.** `templates/trip.md` was `## Plan` / `## Booked` / `## Packing` / `## After` and treated a trip as a list of days. It now follows what a trip note actually turns out to need: a `**Why:**` line, an `## Outline` in phases before the day-by-day `## Plan`, a `## Booked` list split into travel / stay / events where **a checkbox means confirmed**, and a `## Budget` of estimated against actual.
- Two things the template deliberately leaves out. **No total row** in the budget — a total is a sum, and a stored sum is wrong the moment a line changes. And **no trip to-do list** — an action with a date belongs on the workboard, where it will actually be seen, rather than in a note nobody opens until the week before.
- A one-line note on booking references: they are not secrets, but the vault is committed and may be pushed, so an unshared repo is the assumption.
- **Existing vaults:** run `/pkb-upgrade`. It copies the updated `templates/trip.md` — it will show you the diff and ask rather than overwriting, since you may have reshaped that template. `40-travels/travels.md` is regenerated by `/pkb-travels list`; the old three-column header is replaced on the next rebuild, so there is nothing to fix by hand.

## 0.12.0

- **The travels folder gets an index.** `40-travels/travels.md` is a table of every trip, under `## Planned` (sorted by `start`) and `## Been` (sorted by `end`, most recent first).
- **It is generated, not curated.** `/pkb-travels list` rebuilds it from the `title`, `start`, `end`, `places`, and `status` frontmatter of the trip notes in the same folder. A row is never hand-edited: if it is wrong, the note is wrong. A hand-patched row would be silently reverted on the next rebuild, which is the point — the index cannot become a second place a fact lives.
- `/pkb-travels add <place>` creates the note (`Kyoto 2026`, named for the trip rather than the place, so two trips to the same city get two notes) and regenerates the index; `been <trip>` flips it to `done` and moves it from `## Planned` to `## Been`.
- A trip whose status is neither `active` nor `done` is **listed separately as unplaced** rather than dropped. A note missing from its own index is worse than an untidy one.
- New `travels` frontmatter type. `/pkb-review` regenerates the index and flags any trip still `active` past its `end` date — the one kind of staleness an index can actually see, and it asks rather than assuming, since a trip you have not written up yet is not one you never took.
- `AGENTS.md` caught up: it was missing `wishlist` from its `type` list, `seed` from its `status` list, and `## Dreams` from its wishlist section.
- **Existing vaults:** run `/pkb-upgrade`. It copies an empty `40-travels/travels.md` in. Nothing else changes, and no notes are touched.

## 0.11.1

- **Documentation only — no vault action.** `README.md` is now a reference and nothing else: install, commands, vault layout, config, sources, updating, frontmatter. The design reasoning that had accumulated there — the daily loop, the desire space, the principles — moved to `DESIGN.md`.
- The split is not cosmetic. The README's frontmatter block had gone stale (`type` was missing `wishlist`, `status` was missing `seed`) because the file had grown past the point of being read carefully. Reference and reasoning now have separate homes so the reference stays short enough to keep correct.
- **Existing vaults:** nothing to do.

## 0.11.0

- **The life-scale tier is `## Dreams`, not a bucket list.** 0.10.0 put it in `20-goals/` as goal notes with `horizon: life`. That was wrong for the ordinary case: "skydive" needs no research plan, and turning every dream into a project is how a dream list stops being a pleasure. `## Dreams` is now a one-line section at the end of `30-lifestyle/wishlist.md`, alongside wishes and with the same treatment — the difference between a dream and a wish is **time horizon, not weight**.
- `/pkb-bucket` is replaced by `/pkb-dreams` (`list` / `add` / `done` / `pursue`). No waiting period, no review pressure, no count that should trend to zero.
- **The wording is deliberate and load-bearing.** It is *dreams* and *things you want to do in your life* — never "bucket list", which comes from "kick the bucket". A list that reads as an invitation gets used; one that reads as a deadline gets avoided.
- `pursue` is the exit: when a dream gets real, it's promoted to a goal note in `20-goals/` (`horizon: life`) and removed from the list. It hasn't stopped being a dream; it has acquired somewhere to be worked on.
- `/pkb-review` surfaces only dreams that have started to move. An untouched one is never reported as overdue.
- **Existing vaults:** add a `## Dreams` section to `30-lifestyle/wishlist.md`, above `## Done`. Nothing else.

## 0.10.0

- Add `/pkb-curious` and `status: seed`: things worth knowing about eventually — an artist, a period, a question — that are not tasks and not purchases. A seed is a **note** in `70-knowledge/` rather than a list line, because the note is where the learning lands and because a note can be linked to. One line of body is a complete seed.
- Seeds carry no dates, holds, or deadlines, and `/pkb-review`'s orphan-notes section now excludes them — an unlinked seed is the expected state, not a problem.
- `/pkb-triage` files "check out X" captures as seeds rather than as actions.
- **The wishlist is an inbox for desire.** `/pkb-wishlist add` no longer asks for a cost — capture asks nothing, exactly like `/pkb-capture`, and the judgment happens at review. An unpriced wish gets the 30-day default hold, which starts at capture rather than at assessment since the desire is already ageing.
- `review` now leads with **promotion** as the primary exit: acting on a desire usually means it has become legible enough to move into a goal, a project, a trip, or a workboard line. Buying a specific thing counts — "buy the keyboard" is a task.
- The dividing line between the two is what a thing **ends in**: an act (buy, go, do) → wishlist; knowing → seed.
- Add `/pkb-bucket`, and `horizon: life` for goals. **There is no bucket list file** — a bucket list item is a goal that has not got a date yet: `20-goals/`, no `target`. The goal template's `## Leading actions` and `## Progress` are already the "slowly work towards it" loop, and `/pkb-bucket work <item>` is that loop with somewhere to put what you find out. When a date appears, set `target` and narrow `horizon` — same note, now scheduled.
- `/pkb-review` surfaces bucket list items only when they have started to move. An undated one is never reported as overdue; waiting years is what makes it a bucket list rather than a backlog.
- **Existing vaults:** nothing to do. No new folders or files; `status: seed` and `horizon: life` are new values on existing fields. Copy in the updated `templates/goal.md` if you want the horizon hint.
- _Superseded in 0.11.0: the life-scale tier is a `## Dreams` section in the wishlist file, not goal notes. `/pkb-bucket` is now `/pkb-dreams`._

## 0.9.0

- Add `/pkb-wishlist` and `30-lifestyle/wishlist.md`: things that might be wanted, held until they have been wanted long enough to trust. Each wish gets a cooling-off period derived from its cost — 7 days under $100, 14 days to $500, 30 days above, and 30 days for anything with no cost at all, since money is capped and time is not.
- Desire is tested by waiting rather than recorded; `## Needed` is the escape hatch for things actually needed, where the delay is the problem rather than the signal.
- The wishlist is an antechamber, not a destination: a wish that gains a target date is promoted to `20-goals/`, a place to `40-travels/`, a single action to the workboard. Nothing leaves by being ignored.
- `/pkb-review` now sweeps the wishlist — its only forcing function.
- New `wishlist` frontmatter type.
- **Existing vaults:** run `/pkb-upgrade`. It copies an empty `30-lifestyle/wishlist.md` in if you do not have one. Nothing else changes, and no notes are touched.

## 0.8.0

- **Config splits in two, by whether it belongs in git.** `<vault>/.pkb/config.json` now holds the vault's own settings — `name` and `sources` — and is committed with the vault, so it is versioned and travels to a new machine. `~/.config/pv-personal-kb/config.json` shrinks to the vault's `root` plus a `secrets` map: the two things that genuinely cannot be committed.
- `.pkb/` replaces the loose `.pkb-version` file at the vault root, holding `config.json` and `version` together. The scaffold now ships `.pkb/config.json`.
- Command sources can take credentials as `"env": { "TOKEN": "$SECRET:key" }`, resolved from the machine-local `secrets` at read time. Never written into the vault.
- `/pkb-commit` now reads `.pkb/config.json` and checks its **values**, not just its filename — the filename scan would never have caught a token pasted into a `command`.
- **Existing vaults:** run `/pkb-upgrade`. It moves `name` and `sources` out of the machine config into `<root>/.pkb/config.json`, reduces the machine config to `root` and `secrets`, and moves `.pkb-version` to `.pkb/version`. If a source in the old machine config held a literal credential, the upgrade converts it to a `$SECRET:` reference and moves the value into `secrets` rather than copying it into the committed file. No notes are touched.

## 0.7.0

- Add `/pkb-upgrade`, and a `.pkb-version` stamp at the vault root recording which scaffold a vault was built from. New vaults get stamped by `/pkb-setup`.
- **Existing vaults:** nothing to do. Vaults created before this version have no stamp; `/pkb-upgrade` treats that as "unknown" and does a full comparison rather than assuming they are current. To start tracking from here, run `/pkb-upgrade` once.

## 0.6.0

- Add `/pkb-end-of-the-day`: reads what actually changed (`git log --since=midnight` as well as `git status`), writes an evening log under the morning's briefing, then commits and pushes.
- `/pkb-morning` now reads the previous daily note's `## Carried to tomorrow` list, closing the loop between the two.
- **Existing vaults:** nothing to do. Uses the `05-daily/` folder from 0.4.0.

## 0.5.0

- Daily notes move from `05-daily/YYYY-MM-DD.md` to `05-daily/YYYY-MM/YYYY-MM-DD.md`. Month folders are created on demand.
- The conventions now state that daily notes and projects are the only two folders that nest, so the structure stays predictable.
- **Existing vaults:** only if you already have daily notes at the flat path. Move them into a `YYYY-MM/` folder matching their date. A vault with no daily notes yet has nothing to do.

## 0.4.0

- Add `/pkb-morning` and the `05-daily/` folder for its briefing record.
- Add the `sources` array to the config, and the `daily` and `workboard` frontmatter types.
- Move the daily note out of `00-inbox/` deliberately — a log has a different lifecycle from capture, and `/pkb-triage` should not try to file yesterday's briefing.
- **Existing vaults:** create `05-daily/`. Update `AGENTS.md` to include the new folder and types. Vaults made before this version will otherwise work but describe an out-of-date structure to any other tool that reads `AGENTS.md`.

## 0.3.0

- Prefix every command with `pkb-`: `/capture` → `/pkb-capture`, and likewise for setup, triage, workboard, review, commit, new-project, new-person. Breaks the old names.
- **Existing vaults:** nothing structural. The scaffold's `workboard.md` footer names `/pkb-review`; an older vault says `/review`. Cosmetic.

## 0.2.0

- Make the Markdown/Obsidian layering explicit: Obsidian is a viewer you may pick, not a dependency.
- **Existing vaults:** nothing.

## 0.1.0

- First build. Vault scaffolding, capture, triage, workboard, projects, people, review, and commit.
