---
description: Bucket list — life-scale things you want to do, with room to research and work towards them
argument-hint: [list | add <thing> | work <item>]
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`).

Request: $ARGUMENTS

**There is no bucket list file.** A bucket list item is a **goal that has not got a date yet**: a note in `20-goals/` with `type: goal`, `horizon: life`, and no `target`. It is a note rather than a list line because of what you do with it — research, leading actions, progress — and the goal template already has sections for all three.

**The difference from a wish** is scale, not kind. Both end in an act; a wish is something you would *like*, a bucket list item is something you would **regret never doing**. Practically: if one line is enough, it is a wish; if it needs a note to hold what you are finding out, it is a goal.

**The difference from a normal goal** is only the date. When a bucket list item acquires one, `target` gets set and `horizon` narrows — same note, now scheduled.

## `list` (or empty)

Notes in `20-goals/` with `horizon: life`. For each, show the title and whether it has any leading actions or progress recorded.

**Report it flatly.** No count that should trend to zero, no "these have been sitting for a while", no staleness flags. A bucket list item is allowed to wait years — that is what makes it a bucket list rather than a backlog, and a command that nags about it turns something pleasurable into a debt.

Surface, lightly, any that now have a date or a plan forming — that is the one useful signal, because it means one is ready to stop being a bucket list item.

## `add <thing>`

Create `<root>/20-goals/<Title>.md` from `templates/goal.md`, with:

- `horizon: life`
- `target:` left empty
- `## What done looks like` — filled from what the user said, or left as the template's prompt if they gave nothing. **Do not interrogate.** This note will be revisited many times; it does not have to be complete on day one, and one that costs an interview to create is one that never gets created.
- `## Why this one` — one line, if they gave a reason.

**Search `20-goals/` first.** If the item exists, say so and ask whether to develop that note instead of making a second one. If a wishlist line already covers it, offer to promote it — add the note, then remove the line.

Confirm in one line, and mention the one thing that makes the note earn its keep: that `## Leading actions` is where it starts becoming real.

## `work <item>`

The slow loop, and the reason this is a note rather than a line.

1. Read the note.
2. Ask what the user has found out or decided since last time — cost, season, a person to ask, a prerequisite, a place.
3. Write it into the right section: facts into `## Progress`, concrete next steps into `## Leading actions` (as `- [ ]` lines), refinements to the outcome into `## What done looks like`.
4. **Update `updated`.**

Then, if the note now has enough shape to schedule, offer the transition explicitly: set `target` and narrow `horizon`. Do not do it unprompted — a bucket list item is not failing by being undated, and pushing one toward a date it is not ready for is the opposite of the point.

## Hard rules

- **Never a wishlist line and never a workboard line.** If it is small enough for one line, it is a wish — say so and put it there. If it is a single next action with no outcome attached, it belongs on the workboard.
- **Never invent a date to make the note look complete.** `target` stays empty until there is a real one.
- **Never delete a bucket list item.** If it stops being wanted, `status: archived` — and say plainly that this is a fine outcome, not a loss.
- **Never present the list as a to-do, and never imply an undated item is overdue.**
