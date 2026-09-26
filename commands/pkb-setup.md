---
description: Set up a new personal knowledge base — choose where it lives, name it, and scaffold it
argument-hint: [optional: path to create the vault at]
allowed-tools: Read, Write, Edit, Bash, Glob
---

Create a personal knowledge base vault and point the plugin at it. `$ARGUMENTS`

Work through the steps in order. **Ask before you build** — do not scaffold anything until the user has answered.

## 1 — Check for an existing configuration

Read `~/.config/pv-personal-kb/config.json`.

- **Exists** → show the user the vault name and path it currently points at, and confirm the path still exists (`test -d`). Then ask whether they want to point at a different vault, repair the existing one, or stop. Do not silently overwrite a working config.
- **Missing** → continue.

## 2 — Ask the two questions

Use `AskUserQuestion` for both, in one call.

1. **Where should the vault live?** Offer a default of `~/pkb` and accept any absolute path, expanding a leading `~`. If `$ARGUMENTS` was supplied, use it as the default.
2. **What should it be called?** A display name for the vault — "Brain", "Notes", whatever the user likes. This is a label, not a folder name, and it does not have to match the directory.

Then confirm the resolved absolute path back to them in one line before continuing.

## 3 — Refuse to clobber

`test -d <path> && ls -A <path>`

- **Does not exist** → fine, `mkdir -p` it.
- **Exists and is empty** → fine.
- **Exists and is not empty** → **stop.** Show what is in there. Do not copy the scaffold over it, do not merge. Explain the conflict and ask the user to pick a different path or an empty directory. A vault is the one thing here that is genuinely irreplaceable, and the cost of asking is one sentence.

## 4 — Lay down the scaffold

The scaffold ships inside this plugin. Resolve its location as `${CLAUDE_PLUGIN_ROOT}/scaffold`; if that variable is unset, find the plugin's install directory (its cache lives under `~/.claude/plugins/cache/`) and use `<plugin-dir>/scaffold`.

Copy the contents of the scaffold into the vault root — **contents, not the directory itself**, so the vault root does not end up with a stray `scaffold/` level.

The scaffold contains:

```
AGENTS.md                  → vault conventions, for any AI or editor tool
Home.md                    → entry note
gitignore                  → MUST be renamed to .gitignore (see below)
workboard.md               → becomes 10-workboard/workboard.md
templates/                 → 5 note skeletons
00-inbox/ … 90-archive/    → the folder taxonomy, emptied, with .gitkeep markers
```

Two adjustments after copying:

- **`gitignore` → `.gitignore`.** It is shipped without the leading dot so that git does not read the vault's ignore rules as rules for the plugin repo itself. Rename it in the vault. Verify with `ls -a <path>/.gitignore`.
- **`workboard.md` → `10-workboard/workboard.md`.** The scaffold keeps it at the top level only for legibility.

Then verify the result with a tree listing and confirm all ten numbered folders plus `templates/` are present. The `.gitkeep` files matter: git cannot track an empty directory, so without them the taxonomy would not survive a clone.

## 5 — Write the config

```bash
mkdir -p ~/.config/pv-personal-kb
```

Write `~/.config/pv-personal-kb/config.json`:

```json
{ "root": "<absolute vault path>", "name": "<display name>", "sources": [] }
```

Include the `sources` key with two `vault` entries that need no setup — `00-inbox/` and `10-workboard/workboard.md` — so `/pkb-morning` has something to read on day one:

```json
"sources": [
  { "id": "vault-inbox", "kind": "vault", "label": "Vault inbox", "path": "00-inbox", "enabled": true },
  { "id": "workboard", "kind": "vault", "label": "Workboard", "path": "10-workboard/workboard.md", "enabled": true }
]
```

Do not add MCP or command sources here. Those depend on what the user has actually connected, and a guessed tool name fails confusingly later. Mention that `/pkb-morning sources` adds them when they want them.

`chmod 600` it. The config holds no secrets, but it is per-machine state and there is no reason for it to be world-readable.

This file is what every other command and the `pkb-librarian` agent resolves the vault from. Confirm the resolved path in the report — a wrong path here shows up as mysterious failures everywhere else.

## 6 — Offer git

`git -C <path> init -b main`, then `git -C <path> add -A && git -C <path> commit -m "Scaffold the vault"`.

Git is what makes "never delete" safe and gives `/pkb-commit` something to work with. Confirm the `.gitignore` is doing its job: `git -C <path> status --porcelain` should show nothing for `.obsidian/` internals, and the commit should not contain `workspace.json`.

**Do not add a remote and do not create a GitHub repository.** The vault holds personal material and a remote publishes it — that decision belongs to the user and needs a **private** repo. Offer it as a next step and stop there.

## 7 — Report

Give the user, compactly:

- Vault path and display name.
- Config path written.
- Folder listing, so they can see what they got.
- **Then:** `/pkb-capture` to start throwing things in, `/pkb-triage` to sort them, `/pkb-workboard` to see what is live.
- **Tomorrow morning:** `/pkb-morning` builds a briefing from the configured sources. It starts with the vault alone; `/pkb-morning sources` adds a calendar, a task list, or a Notion inbox when the user wants them.
- **End of the day:** `/pkb-end-of-the-day` logs what actually changed and commits it. It reads `/pkb-morning`'s briefing and carries unfinished items forward, so the two are worth using as a pair.

**Mention viewers briefly, as an option — not as a next step.** The vault is a folder of Markdown files, and any editor opens it; it is complete and usable without installing anything. If the user uses Obsidian, two things are worth knowing: *Open folder as vault* → pick the path, and set **Template folder location** to `templates/` in Settings → Files & Links so the Templates plugin substitutes the `{{title}}` and `{{date:YYYY-MM-DD}}` variables. Say this once, then move on.

Do not tell the user the vault is "synced" to anything, and do not imply an app is required to use it. It is a folder of files, and that is the point.
