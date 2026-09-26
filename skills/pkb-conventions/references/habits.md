# Habits

Read this when a task touches **a standing habit or its trend** — `/pkb-habits`, the habits step of `/pkb-end-of-the-day`, the habits section of `/pkb-review`.

A habit is neither an action nor a goal. An action completes, a goal arrives, and a habit does neither — it is either being kept or it is not. That is why habits live in `30-lifestyle/` and not on the workboard, where every line is expected to close.

## The definition file

`30-lifestyle/habits.md`, `type: lifestyle`, one line per habit under `## Active`:

```markdown
- **Gym** — 4×/week — a session, not a visit
- **Reading** — daily — ten pages
```

**Cadence is `daily`, `N×/week`, or `N×/month`** — a number, because it is what "on track" is measured against. "What counts" is the definition that makes the tick unambiguous; a habit whose definition is vague is one you argue with yourself about at eleven at night, and the argument is what kills it.

`## Dropped` holds abandoned habits, checked and kept. A cadence consistently missed may simply be the wrong cadence, and a habit that was dropped is a fact about the last attempt — so it is recorded rather than deleted, and the same one does not get re-added every few months.

## Where a tick lives, and why it is not here

**Ticks go in the day's note, under `## Habits`** — every active habit listed, checked or not:

```markdown
## Habits

- [x] Gym — legs
- [ ] Reading
```

This is the single most important decision in the feature, and it is about friction. A tracking system that has to be updated in its own place, separately from everything else you do that day, does not survive. The daily note already exists, `/pkb-end-of-the-day` already writes it, and the tick is therefore part of a ritual that was happening anyway rather than a new one.

The obvious objection — that answering "has gym slipped?" now means reading weeks of daily notes — is not a real cost here. That is a grep across a month folder, which is what this vault is for. The alternative, a single habits table with a row per day, would mean a second per-day record: a second place a fact lives, and one you have to remember to update.

The definition file holds *what the habits are*; the daily note holds *what happened*. Changing a cadence never rewrites history, and a year of ticks stays where the year already is.

## A gap is not a miss

**A day with no `## Habits` section is unknown. A day with the section and an unchecked box is a miss.** These are different facts and everything that reads a trend must keep them apart.

This is the same rule as *a source that fails is not a source that is empty*, and it matters for the same reason: a report that counts a day you never logged as a day you failed produces a regression that did not happen. That is the fastest way to make someone stop trusting the report and then stop tracking.

So `/pkb-end-of-the-day` **asks once** — showing the whole list rather than interviewing habit by habit — and if the user does not answer, it **writes no section at all**. An all-unchecked day written on the user's behalf would be a fabricated record, and the honest thing to write is nothing.

## Never store a streak

No streak, no adherence percentage, no "regressing" flag is ever written to a file. All of it is computed from the days, at read time.

A stored streak is wrong the moment a day is missed, and it is worse than merely wrong: it turns the number into the thing being maintained. This is the vault's standing rule — *a thing that can be derived is not stored* — and it is sharper here than anywhere else, because the whole point of a habit is the behaviour, not the count.

## The trend, and what "regressing" means

`/pkb-habits check` reports adherence against each habit's cadence, and it has to be built so that it is worth reading.

**Compare against a trailing baseline, not against last week.** One bad week is not a regression — it is a week. So a decline is only reported when it holds across consecutive periods, and nothing about trend is said at all until there are enough weeks to have a trend.

**State the coverage.** Report how many days in the window actually carry a `## Habits` section, before reporting anything else. A conclusion drawn from four logged days out of twenty-eight should be visibly that, and often the honest answer is that there is not enough data to say.

**Every flag is a question, and one of the answers is "drop it".** A cadence that is consistently missed is often the wrong cadence rather than a personal failure — too ambitious, badly defined, or no longer wanted. A report whose only available verdict is *you failed* becomes a wall of failure and gets ignored, which is the same reason `## Dreams` never reports an untouched item as overdue.

**Never report a single missed day.** And never report an unlogged one at all.
