---
description: Snapshot the vault — stage, summarize, commit, and push if a remote exists
argument-hint: [optional: your own commit message, or "dry" to preview only]
allowed-tools: Read, Bash, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it. Call that path `<root>`. Snapshot the vault: `$ARGUMENTS`

## 1 — Preflight

`git -C <root> status --porcelain`

- Not a git repo → say so, offer `git init`, and stop.
- Nothing to commit → say so in one line and stop.
- `dry` was requested → show the preflight result and the message you *would* write, then stop.

**Secret check — do this before staging anything.** Editors and plugins keep credentials in plain text, and a vault is exactly where they accumulate. Scan the list of changed and untracked paths for anything matching:

`data.json`, `.env`, `*token*`, `*secret*`, `*credential*`, `*.key`, `*.pem`, `*password*`

If any path matches, **stop and report it** — do not stage, do not commit, and do not "fix" it by deleting the file. Name the file, say why it looks sensitive, and let the user decide.

Also confirm the vault's own ignore rules are intact: `git -C <root> check-ignore -v .obsidian/workspace.json` should return a match. If `.gitignore` is missing or has been emptied, say so before staging — an editor config directory committed once is very hard to walk back.

Never run `git add -A` before this check passes. If a suspicious path is present but the user wants to proceed anyway, stage explicit paths instead of the whole tree.

## 2 — Stage and read

`git add -A`, then read `git diff --cached --stat` and the actual diff.

## 3 — Write the message

Summarize in **note terms, not file terms** — "added 3 knowledge notes on X", not "modified 3 files". Group the changes: new notes (with titles), edits, workboard movement, archive moves, deletions.

```
<one-line summary of what changed in the vault>

- <a bullet per meaningful change>
```

If the user supplied a message, use their words as the subject line and keep the generated detail as the body.

End the message with:

```
Co-Authored-By: Claude Code <noreply@anthropic.com>
```

## 4 — Commit

Commit with that message. Report the short hash.

## 5 — Push

`git -C <root> remote -v`

- **No remote configured** → the commit stands; say plainly that there is nowhere to push. Do **not** create a repository or add a remote on your own initiative. The vault holds personal material and pushing it publishes it — that is the user's decision, made deliberately, and anything outward-facing needs a **private** repository. Offer the options and stop.
- **Remote exists** → `git push`, then report the branch and whether it went through.

## 6 — Report

Short: commit hash, what was in it, push status. If a hook or conflict blocked anything, report the actual error rather than working around it.

## Hard rules

- Never force-push. Never `--amend` a commit that has been pushed. Never `reset --hard` anything.
- Never add a remote, create a repo, or make a repository public.
- Never commit through a failed secret check.
- If a pre-commit hook fails, report it — do not bypass with `--no-verify`.
