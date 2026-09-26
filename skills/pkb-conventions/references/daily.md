# Daily notes

Read this when a task **writes or reads a daily note** — `/pkb-morning`, `/pkb-end-of-the-day`.

`05-daily/YYYY-MM/YYYY-MM-DD.md`, `type: daily`. Two commands write these and they must agree on the shape.

```markdown
---
title: 2026-09-26
type: daily
status: active
created: 2026-09-26
updated: 2026-09-26
sources: [vault-inbox, calendar]
tags: []
---

## Thursday 2026-09-26

**Fixed**
- 10:00 Standup

**Carried**
- [ ] Ship the plugin #project/pv-personal-kb

**Proposed**
- Draft the proposal before 16:00

## Log

### Thursday 2026-09-26, evening

**Done**
- Shipped the plugin

**Changed**
- Archived 2 dormant projects

**Carried to tomorrow**
- [ ] Finish the proposal — blocked on the client's numbers

## Habits

- [x] Gym — legs
- [ ] Reading
```

The `## Habits` section is written by `/pkb-end-of-the-day`, after `## Log`, and only when `30-lifestyle/habits.md` has anything under `## Active`. It lists **every** active habit, checked or not — the unchecked ones are what makes a miss distinguishable from a gap.

**A day with no `## Habits` section is unknown; a day with the section and an unchecked box is a miss.** Never write the section on the user's behalf, and never infer a tick from the day's other activity. See `habits.md`.

`/pkb-morning` writes the briefing and leaves `## Log` empty. `/pkb-end-of-the-day` appends under it. Both are idempotent: re-running either rewrites its own section rather than adding a second copy.

**Each command owns its own sections, and writes nothing else.** Morning owns the frontmatter and the briefing block; the evening owns `## Log` and `## Habits`. Neither may rewrite, reorder, or regenerate the other's part — so a second run of either is safe at any point in the day.

The rule exists because these two sections cannot be rebuilt from the note. The evening log is the day's only narrative record, and the `## Habits` ticks are the **only** record of that day's habits — there is nothing else in the vault to reconstruct them from. A morning re-run that regenerated the file from its briefing would destroy both, and the habit loss would be silent, surfacing months later as a gap that reads as a missed day rather than as missing data.

**The `## Carried to tomorrow` list is the seam between them** — the evening writes it, the next morning reads it into its Carried bucket. That loop is the reason both commands exist; either one alone is just a note-taking prompt.

The log is written *against* the morning list rather than as a free-form diary. If something was on the list and did not happen, the evening entry says so — and if the same item has been carried for the third day running, the next morning calls that out instead of listing it a fourth time as though it were new.

The evening command reads `git log --since=midnight` **as well as** `git status`, because after any mid-day commit a status-only check would report a quiet day — the changes exist, they are just not in the working tree. A day where nothing happened produces a short log, not a padded one.

Daily notes are never triaged. They are a log, not capture — which is exactly why they live outside `00-inbox/`. `/pkb-triage` should not try to file yesterday's briefing.
