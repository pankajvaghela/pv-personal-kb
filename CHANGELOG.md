# Changelog

Two kinds of change live here, and the difference matters if you have a vault already:

- **Plugin changes** — commands, the skill, the agent. These arrive with `claude plugin update`. Nothing to do.
- **Existing vaults** — anything that changes the folder structure or the scaffold files (`AGENTS.md`, `Home.md`, `.gitignore`, `templates/`, `workboard.md`, `.pkb/`). These do **not** propagate on their own. Run `/pkb-upgrade`.

Every version below states which it is, so you can tell at a glance whether an upgrade needs action.

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
