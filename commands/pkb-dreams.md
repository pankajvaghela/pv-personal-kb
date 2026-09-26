---
description: Dreams — things you want to do in your life
argument-hint: [list | add <thing> | done <thing> | pursue <thing>]
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then work with the `## Dreams` section of `<root>/30-lifestyle/wishlist.md`.

Request: $ARGUMENTS

**What this is.** Dreams are what you want your life to have in it; the rest of the wishlist is what you want next. Both are wants, and both are one line each — the difference is **time horizon, not weight**. That is why this is a section of the wishlist file rather than a folder of notes: "skydive" needs no research plan, and treating every dream as a project is how a dream list stops being a pleasure.

**Language matters here.** Say *dreams*, *things you want to do in your life*, *what you want your life to have in it*. Never "before you die", never "bucket list" — that phrase comes from "kick the bucket", and this section is about living, not about mortality. The framing is not decoration: it is the difference between a list that feels like an invitation and one that feels like a deadline.

**No waiting period, no review pressure.** A dream is on the list because it is true about you, not because it is due. It is allowed to sit for years and nothing is wrong while it does. Do not apply cost-derived holds here, never put these through the review's forced-decision pass, and never imply an untouched one is overdue.

## `list` (or empty)

The `## Dreams` lines. Report them flatly and warmly — **no count that should trend to zero, no staleness flag, no "these have been sitting a while".** A command that nags turns a pleasure into a debt, which is the one failure mode this section has.

If any have grown past a line — you have started looking into cost, timing, or what it takes — say so and offer `pursue`, below. That is the only useful signal here.

## `add <thing>`

One line under `## Dreams`:

```
- [ ] Skydive — added 2026-09-26
```

Short, imperative, the thing itself: `Skydive`, `See the Northern Lights`, `Learn to sail`, `Write a book`. **Ask nothing and add no metadata beyond the date.** If the user volunteered a reason or a detail, keep it to a trailing clause on the same line — not a sub-bullet, not a second line.

Search the section and the rest of the file first. If it is already there, say so rather than adding a duplicate. If a wish in `## Holding` is really a dream — the user describes it as something for their life rather than something they are deciding about now — offer to move the line up rather than keeping it in both places.

## `done <thing>`

Mark `- [x]`. `/pkb-review` sweeps checked items into `## Done` along with everything else.

Then offer the thing that actually matters: a dream marked done is an experience, and experiences usually deserve more than a line. Offer to write it up as a note in `70-knowledge/` or `40-travels/` — what it was like, what you would tell someone about to do it — linked from here.

## `pursue <thing>`

For a dream that has started to get real: you have looked into it, a date is forming, there is money to save or a skill to build first.

Promote it. Create the goal note in `20-goals/` from `templates/goal.md`, set `horizon: life` and leave `target` empty unless there is a real date, carry over whatever the user has said, and then **remove the line from `## Dreams`**. It is not dropped, it moved — and a goal note has somewhere to put `## Leading actions` and `## Progress`, which is exactly what the dream has outgrown.

Confirm in one line and say what changed: it is now a goal, it will show up in `/pkb-review`, and the dream itself is still true — it just has somewhere to be worked on.

## Hard rules

- **One line per dream.** No sub-bullets, no sections, no per-dream notes in this file. If it needs more than a line, it needs `pursue`.
- **Never a cost, a hold, or a `#wish/` tag.** Those belong to the wishlist above it and would drag this section into the review's forced-decision pass.
- **Never mortality framing.** Not in the section, not in reports, not in passing.
- **Never delete a dream.** Done is `- [x]`; no longer wanted is just leaving the line. A dream list you have drifted away from is still a dream list.
- **Never report an untouched dream as overdue, stale, or forgotten.**
