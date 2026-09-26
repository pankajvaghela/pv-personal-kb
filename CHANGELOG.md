# Changelog

Two kinds of change live here, and the difference matters if you have a vault already:

- **Plugin changes** — commands, the skill, the agent. These arrive with `claude plugin update`. Nothing to do.
- **Existing vaults** — anything that changes the folder structure or the scaffold files (`AGENTS.md`, `Home.md`, `.gitignore`, `templates/`, `workboard.md`, `.pkb/`). These do **not** propagate on their own. Run `/pkb-upgrade`.

Every version below states which it is, so you can tell at a glance whether an upgrade needs action.

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
