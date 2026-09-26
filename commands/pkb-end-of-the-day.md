---
description: End of day — log what changed in the vault, then commit and push
argument-hint: [optional: "dry" to write the log but stop before committing]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`). Close out today.

## 1 — Establish what actually changed

Two sources, and both are needed:

- `git -C <root> log --since=midnight --name-status` — what was **committed** today. If the user ran a commit mid-day, or ran this command twice, these changes exist nowhere else.
- `git -C <root> status --porcelain` plus the diff — what is **uncommitted** right now.

Reading only `git status` reports a quiet day after any mid-day commit. That is the exact bug this step exists to prevent, so do not skip the log.

If both are empty, say so and stop. A day where nothing happened is a real answer — do not write a log entry to fill the silence, and do not commit an empty tree.

## 2 — Read today's note

Read `05-daily/YYYY-MM/YYYY-MM-DD.md` if it exists.

- **Exists** → it holds this morning's briefing. The log is written *against* that briefing: what was on the list, and what actually happened to it.
- **Missing** → the user skipped `/pkb-morning`. Create the note with today's frontmatter and log into it anyway. Never refuse to close the day because the morning step was skipped.

## 3 — Tick the habits

If `<root>/30-lifestyle/habits.md` has anything under `## Active`, close out the `## Habits` section at the end of today's note — after `## Log`. Read `references/habits.md` from the conventions skill first; this step is where its rules actually bite.

**Ask once, as a single list.** Show every active habit and let the user mark them in one pass. Do not interview habit by habit — that is the friction that kills tracking, and it is the whole reason the ticks live in the day rather than in a file of their own.

**Write every active habit, checked or not.** The unchecked ones are the point: a list of only what you did is indistinguishable from a day you never logged, and anything reading the trend has to tell "missed" from "no data" or it will invent regressions that did not happen.

**If the user does not answer, write no section at all.** An all-unchecked day written on their behalf is a fabricated record, and a gap is both more honest and more useful — it reads as unknown, which is what it is. Never infer a tick from the day's activity: gym is not a file change, and the vault has no evidence either way.

Tick a habit only if it is under `## Active`. If the user mentions one that is not, offer to add it with `/pkb-habits add` rather than writing a tick for something undefined.

Running this twice in one day rewrites the section rather than appending a second, like the log.

## 4 — Write the log

Append under `## Log`:

```markdown
### <Weekday> <YYYY-MM-DD>, evening

**Done**
- <what actually got finished>

**Changed**
- <notes created, renamed, archived, restructured — in note terms, not file terms>

**Carried to tomorrow**
- [ ] <what is still open, and why>
```

Rules:

- **Every line traces to evidence** — the git diff, the day's note, the workboard. Never write an entry the vault does not support. This is a record, not a diary.
- **Write it against the morning list.** If the briefing said something would happen and it did not, say so plainly. A log that reports only wins is a log nobody trusts.
- **"Carried to tomorrow" is the load-bearing part** — it is what the next `/pkb-morning` reads. Include only what is genuinely still open. An item carried five days running is a signal worth surfacing, not a plan.
- **Record attention, not a changelog.** "Reworked the travel plan around the new dates" beats "edited 4 files in 40-travels/".
- Set `updated:` in the frontmatter to today.

**Running this twice in one day must not double the log.** If an `### <date>, evening` entry already exists, rewrite it in place rather than appending a second.

**This command owns `## Log` and `## Habits`, and nothing above them.** The frontmatter and the briefing block belong to `/pkb-morning` — never rewrite or reorder them, and never regenerate the note from its own sections. Each command touching a daily note writes only its own part, which is what makes two writers safe in one file.

## 5 — Commit and push

Use the protocol in `pkb-commit` — stage, secret check, message, commit, push. Follow it exactly rather than inventing a second path; if the two ever drift, the secret check is the part that rots.

Two differences for this command:

- **The log goes in first.** Write it before staging, so the commit contains it. Committing and then logging leaves the day's record uncommitted, which is the one thing this command was for.
- **Summarize in day terms**, with the date in the subject: `2026-09-26: shipped the Notion removal, filed 3 notes`.

If `$ARGUMENTS` is `dry`, stop after step 4 and show the message you would write.

## Hard rules

- **Never commit through a failed secret check** — the `pkb-commit` protocol is not optional here.
- **Never write a log entry without evidence**, and never pad a quiet day to look productive.
- **Never add a remote or create a repository.** See `pkb-commit`.
- **Never amend a pushed commit, never force-push.**
