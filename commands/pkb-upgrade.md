---
description: Bring an existing vault's structure and scaffold files up to the installed plugin version
argument-hint: [optional: "check" to report differences without changing anything]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`). Reconcile the vault against the plugin that is installed now.

**Why this exists.** `/pkb-setup` copies the scaffold once. Nothing updates it afterwards, so a vault drifts: folders the plugin now expects go missing, and `AGENTS.md` keeps describing a structure that is no longer current. The plugin's commands update through `claude plugin update`; the vault needs this.

## 1 — Establish both versions

- **Vault:** read `<root>/.pkb-version`.
- **Plugin:** read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`.

Then read `${CLAUDE_PLUGIN_ROOT}/CHANGELOG.md` and pull out every entry between the vault's version and the plugin's, **especially the "Existing vaults" lines**. Those are the structural changes — a moved folder, a new required file — that copying files alone will not fix.

- **Equal versions** → report that, then still offer the file diff below. A vault can be on the current version and still have hand-edited scaffold files worth seeing.
- **No `.pkb-version`** → the vault predates version stamping. Treat it as unknown, say so plainly, and run the full comparison rather than assuming it is current.
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

For each, compare against the vault copy:

- **Missing in the vault** → copy it in. A file the scaffold now ships but the vault lacks is the easy case.
- **Identical** → nothing to do.
- **Differs** → **show the diff and ask.** Do not decide for the user.

On that last case: you cannot tell whether a difference is a user's deliberate edit or a stale copy of an older scaffold. **Do not guess, and do not resolve it by overwriting.** Show what changed, say which version the file looks like it came from if the CHANGELOG makes that clear, and let the user pick: keep theirs, take the new one, or merge. A `templates/` file they deliberately reshaped is worth more than a newer default.

**Never touch a file the scaffold does not ship.** Notes, project folders, `templates/` files they added — all out of scope, permanently.

## 4 — Structural migrations

Work through the "Existing vaults" lines you collected in step 1, in version order.

A migration that moves or rewrites **notes** — rather than structure — needs its own explicit confirmation, with the list of affected paths shown first. If a migration looks ambiguous or the affected notes are numerous, **stop and report it** rather than running it. A half-applied migration on someone's personal notes is the worst outcome this command can produce.

Most upgrades will have nothing here. Say so when that is the case rather than implying work happened.

## 5 — Stamp and report

Write `<root>/.pkb-version`:

```json
{ "scaffold": "<plugin version>", "upgraded": "<YYYY-MM-DD>", "plugin": "pv-personal-kb" }
```

Then report, compactly: version moved from → to, folders created, files copied, files still differing and why, migrations run or skipped. Close by suggesting `/pkb-commit`, so the upgrade is a reviewable commit that can be reverted in one step.

If `$ARGUMENTS` is `check`, do steps 1–4 read-only: report everything you would do and change nothing.

## Hard rules

- **Never modify a note.** This command touches structure and scaffold files, nothing else. Not one line of anyone's notes.
- **Never delete, move, or rename.** Folders are created, never removed.
- **Never overwrite a differing file without showing the diff and getting a yes.**
- **Never upgrade a vault whose stamp is newer than the plugin.**
- **Never leave a migration half-applied.** Either it completes, or nothing was changed.
