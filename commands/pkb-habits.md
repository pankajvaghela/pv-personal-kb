---
description: Standing habits — define them, tick them, and see whether any are slipping
argument-hint: [list | add <habit> | check | tick <habit> | drop <habit>]
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then work with `<root>/30-lifestyle/habits.md`. Read `references/habits.md` from the conventions skill before doing anything here.

Request: $ARGUMENTS

**A habit is not an action and not a goal.** An action completes; a goal arrives; a habit does neither, which is why it is not on the workboard and not in `20-goals/`. This command owns the definitions and the trend. The **ticks belong to the day** — they live in the daily note and `/pkb-end-of-the-day` writes them.

## `list` (or empty)

Read `## Active` and show each habit with its cadence and what counts. Show `## Dropped` as a count only. Then, from the last four weeks of daily notes, one line per habit: how many days were logged and how many were hits.

If `## Active` is empty, say so in one line and offer `add`. An empty list is the normal starting state, not a problem.

## `add <habit>`

Append one line under `## Active`:

```
- **<habit>** — <cadence> — <what counts>
```

**Ask at most two things**: how often (`daily`, `N×/week`, `N×/month`), and what counts as doing it. The cadence is genuinely required — without it there is nothing to measure against, and "whenever I can" cannot be reported on. Do not press for the second; a habit added without a definition is still a habit, and the definition can be filled in later.

Push once, gently, on the cadence being a number rather than an intention. `4×/week` is measurable and `regularly` is not, and this is the only moment where saying so is welcome.

If the habit already exists under `## Active`, say so rather than adding a second line. If it is under `## Dropped`, say when it was dropped and why, and ask whether to re-add it — re-adding is fine, but it should be a decision rather than an accident.

## `tick <habit>`

For ticking today without running the full evening close-out. Write or update today's `## Habits` section in `05-daily/YYYY-MM/YYYY-MM-DD.md`, creating the month folder and the note if needed.

**Write the full list of active habits, not just the one.** A section containing a single checked habit is indistinguishable from a section where the others were missed, and this command must never manufacture a miss. If the section does not exist yet, list every active habit and check only the one named, leaving the rest unchecked only if the user confirms them as misses — otherwise write just what they told you, checked, and leave the section partial rather than inventing the rest.

Never tick a habit that is not under `## Active`. Offer to add it first.

## `check`

The report. **Read `references/habits.md` first** — the rules below are the short version of it, and that file is the authority.

1. **Coverage before conclusions.** Count the days in the window (default: the last four weeks) that actually have a `## Habits` section. State it first, as `N of M days logged`. **A day with no section is unknown, never a miss** — reporting a gap as a failure produces a regression that did not happen, and that is what makes a tracker get abandoned.
2. **Per habit**, against its cadence: hits in the window, and the week-by-week counts so the shape is visible rather than summarised into one number.

   ```
   Gym — 4×/week — 19 of 28 days logged
     weeks: 4, 4, 3, 2
     Down three weeks running.
   ```
3. **Flag a decline only when it holds across consecutive weeks.** One bad week is a week, not a regression. Say nothing about trend at all until there are enough weeks for a trend to exist.
4. **Every flag ends in a question, and "drop it" is always one of the answers.** A cadence that keeps being missed is often the wrong cadence rather than a failure — too ambitious, badly defined, or no longer wanted. Ask whether to change the cadence, redefine what counts, or drop it.
5. **Never report a single missed day**, and never report an unlogged one at all.

Compute everything from the daily notes. **Write no streak, no percentage, and no flag into any file** — a stored streak is wrong the moment a day is missed, and it turns the number into the thing being maintained.

If a habit has almost no data, say that instead of producing a number. "Not enough logged days to say anything about Gym" is a complete and useful answer.

## `drop <habit>`

Ask why in one line, then move the line from `## Active` to `## Dropped` with the date and the reason.

**Dropping is a legitimate outcome, not a failure**, and it should be offered as such — plainly, without a hint that something went wrong. A cadence consistently missed is usually the wrong cadence. The line is kept rather than deleted so the same habit does not get re-added every few months and the reason is there to read when it is.

## Hard rules

- **Never write a tick into `habits.md`.** Definitions only; ticks live in the daily note.
- **Never store a streak, an adherence percentage, or a regression flag.** All of it is derived at read time.
- **Never treat a day with no `## Habits` section as a missed day.** It is unknown.
- **Never write ticks on the user's behalf.** If they do not answer, write nothing — an all-unchecked day invented by a command is a fabricated record, and worse than a gap.
- **Never delete a habit line.** Dropped habits move to `## Dropped` and stay.
- **Never nag about a single missed day.** The report exists to catch a trend, not to keep score.
