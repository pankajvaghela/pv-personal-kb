---
description: Bring an existing vault's structure and scaffold files up to the installed plugin version
argument-hint: [optional: "check" to report differences without changing anything]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`). Reconcile the vault against the plugin that is installed now.

**Why this exists.** `/pkb-setup` copies the scaffold once. Nothing updates it afterwards, so a vault drifts: folders the plugin now expects go missing, and `AGENTS.md` keeps describing a structure that is no longer current. The plugin's commands update through `claude plugin update`; the vault needs this.

## 1 — Establish both versions

- **Vault:** read `<root>/.pkb/version`. If that is absent, check the older `<root>/.pkb-version` — a vault stamped by 0.7 only has that, and step 4 moves it.
- **Plugin:** read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`.

Then read `${CLAUDE_PLUGIN_ROOT}/CHANGELOG.md` and pull out every entry between the vault's version and the plugin's, **especially the "Existing vaults" lines**. Those are the structural changes — a moved folder, a new required file — that copying files alone will not fix.

- **Equal versions** → report that, then still offer the file diff below. A vault can be on the current version and still have hand-edited scaffold files worth seeing.
- **No stamp at either path** → the vault predates version stamping. Treat it as unknown, say so plainly, and run the full comparison rather than assuming it is current.
- **Vault version is newer than the plugin** → the plugin was rolled back or the vault was copied from elsewhere. Say so and stop. Do not "fix" a newer vault with an older scaffold.

## 2 — Reconcile folders, additively

Compare the directories in `${CLAUDE_PLUGIN_ROOT}/scaffold/` against `<root>`.

- **Missing in the vault** → create it, with a `.gitkeep` so git tracks it.
- **Present** → leave it alone.
- **Extra in the vault** → leave it alone, and mention it. Extra top-level folders are the user's call, not this command's.

**Additive only. This command never removes or renames a folder.**

## 3 — Reconcile scaffold files

The scaffold ships these, two of them renaming on the way in:

| Shipped as | Lands at |
| --- | --- |
| `AGENTS.md`, `Home.md` | same path in the vault |
| `gitignore` | `<root>/.gitignore` |
| `workboard.md` | `<root>/10-workboard/workboard.md` |
| `templates/*.md` | `<root>/templates/*.md` |
| `.pkb/config.json` | `<root>/.pkb/config.json` — **special case, below** |

**`.pkb/config.json` is the exception.** It ships in the scaffold, but it is the user's configuration rather than scaffold to be kept in sync — the scaffold copy has an empty `name`, and every vault's will differ within minutes of setup. So:

- **Missing in the vault** → copy the scaffold version in. This is the pre-0.8 case, and step 4 fills it from the old machine config if there is one.
- **Present** → **never touch it, not even to offer a diff.** A differing config is the normal state, not a stale copy.

For everything else, compare against the vault copy:

- **Missing in the vault** → copy it in. A file the scaffold now ships but the vault lacks is the easy case.
- **Identical** → nothing to do.
- **Differs** → **show the diff and ask.** Do not decide for the user.

On that last case: you cannot tell whether a difference is a user's deliberate edit or a stale copy of an older scaffold. **Do not guess, and do not resolve it by overwriting.** Show what changed, say which version the file looks like it came from if the CHANGELOG makes that clear, and let the user pick: keep theirs, take the new one, or merge. A `templates/` file they deliberately reshaped is worth more than a newer default.

**Never touch a file the scaffold does not ship.** Notes, project folders, `templates/` files they added — all out of scope, permanently.

## 4 — Structural migrations

Work through the "Existing vaults" lines you collected in step 1, in version order.

A migration that moves or rewrites **notes** — rather than structure — needs its own explicit confirmation, with the list of affected paths shown first. If a migration looks ambiguous or the affected notes are numerous, **stop and report it** rather than running it. A half-applied migration on someone's personal notes is the worst outcome this command can produce.

Most upgrades will have nothing here. Say so when that is the case rather than implying work happened.

**The 0.8 migration, in full** — it moves config, never notes, and is worth spelling out because it touches a file the user may have edited:

1. Read `~/.config/pv-personal-kb/config.json`. If it holds `name` or a non-empty `sources`, the vault is pre-0.8.
2. Merge those into `<root>/.pkb/config.json` — `sources` and `name` as keys, creating the file from the scaffold version if it does not exist. **Vault values win on conflict**: if the vault already has a key, leave it and mention the stale machine value rather than overwriting.
3. **If any source in the old machine config carries a literal credential** — a token, key, or password in a `command`, `args`, or an `env` value that is not a `$SECRET:` reference — do not copy it into the vault. Move the value into `secrets` in the machine config, write the `$SECRET:<key>` reference in its place, and say so explicitly. The vault is committed, and this is the one way this migration could leak something.
4. Rewrite the machine config down to `{ "root": ..., "secrets": ... }`. Nothing else survives there.
5. Move `<root>/.pkb-version` to `<root>/.pkb/version` if the old path exists, then continue to step 5.
6. Report what moved, so the change is legible in the diff before it is committed.

## 5 — Stamp and report

Write `<root>/.pkb/version`:

```json
{ "scaffold": "<plugin version>", "upgraded": "<YYYY-MM-DD>", "plugin": "pv-personal-kb" }
```

Then report, compactly: version moved from → to, folders created, files copied, files still differing and why, migrations run or skipped. Close by suggesting `/pkb-commit`, so the upgrade is a reviewable commit that can be reverted in one step.

If `$ARGUMENTS` is `check`, do steps 1–4 read-only: report everything you would do and change nothing.

## Hard rules

- **Never modify a note.** This command touches structure and scaffold files, nothing else. Not one line of anyone's notes.
- **Never delete, move, or rename.** Folders are created, never removed.
- **Never overwrite a differing file without showing the diff and getting a yes.**
- **Never touch `.pkb/config.json` when it already exists.** Differing is its normal state.
- **Never carry a credential into the vault.** `<root>/.pkb/config.json` is committed. A literal token found in an old machine config becomes a `$SECRET:` reference plus an entry in the machine-local `secrets`, never a copied value.
- **Never upgrade a vault whose stamp is newer than the plugin.**
- **Never leave a migration half-applied.** Either it completes, or nothing was changed.
