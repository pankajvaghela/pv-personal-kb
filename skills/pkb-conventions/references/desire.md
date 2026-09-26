# The desire space

Read this when a task touches **something wanted but not yet decided** — `/pkb-wishlist`, `/pkb-curious`, `/pkb-dreams`, and the wishlist/dreams sections of `/pkb-review`. Three tiers live here, and the dividing lines between them are the whole design.

|            | Ends in                | Lives as                         | Review pressure                       |
| ---------- | ---------------------- | -------------------------------- | ------------------------------------- |
| Curiosity  | knowing                | `70-knowledge/` seed             | none, ever                            |
| Wish       | an act, months out     | wishlist line                    | forced at hold expiry                 |
| Dream      | an act, life-scale     | wishlist line, `## Dreams`       | none, but momentum gets surfaced      |

**The review pressure across the three tiers is deliberately uneven, and that is the part to protect from well-meaning improvement.** Ignoring a wish is information about you; ignoring a seed or a dream means nothing. A command that nags about the latter turns something pleasurable into a debt.

## Wishes — an inbox for desire

`30-lifestyle/wishlist.md` — a single file, one line per wish, held until it has been wanted long enough to trust.

```markdown
- [ ] Mechanical keyboard — ~$180 — added 2026-08-15 — typing on a $20 membrane board all day #wish/buy
```

Sections: `## Off hold` (the waiting period is over — needs a decision), `## Holding` (inside it — leave alone), `## Needed` (things actually needed and not being bought, where the delay is the problem rather than the signal; no waiting period), `## Dreams` (below), `## Done` (bought or dropped, checked, never deleted).

**The wishlist is an inbox for desire.** Something you want, captured cheaply, held until it is clear what to do with it. It is an inbox, but not one you clear in a sitting — every other inbox in this vault is processed as fast as possible, and this one is processed **slowly, on purpose**, because desire is not legible on the day you feel it.

That has two consequences worth holding to. Capture asks nothing, exactly like `/pkb-capture` — the judgment happens at review, and a wishlist entry that costs a question to write is one that never gets written. And the hold is the *triage delay*, not a delay before triage: the clock starts when the wish is captured, because the desire is already ageing and restarting it at review would defeat the only mechanism that works.

**A wish leaves by being acted on, not by being ignored.** Acting on it usually means the desire has become legible enough to promote — into a goal, a project, a trip, or a workboard line, including a plain "buy X" task. A small decided purchase is simply done. A wish that no longer looks worth it is dropped, recorded as checked so the same thing is not re-added in three months. "Leave it" is the one answer that is not allowed, and it is the failure mode every wishlist has.

That gives the boundary with everything adjacent, and it is worth holding firmly:

| If it…                                    | It belongs in                              |
| ----------------------------------------- | ------------------------------------------ |
| Has a target date and a plan              | `20-goals/` — the promotion path for most wishes |
| Is a place to go                          | `40-travels/`                              |
| Needs sustained effort over time          | `20-goals/`, or a project if it has a finish line |
| Is a single next action                   | `10-workboard/workboard.md`                |
| Is undecided — wanted, not yet earned     | here                                       |

**Desire is tested by waiting, not recorded.** Do not add a "how much do I want this" field; asked at the moment of wanting, the answer is the impulse talking, and it is why high/medium/low priority collapses within a week. Time is the honest measure, so the hold period is derived from cost — 7 days under $100, 14 days to $500, 30 days above, and 30 days for anything with no cost at all, because money is capped and time is not.

**Importance is what exempts you from the wait**, and that is its only job here. A need does not become more urgent by sitting on a list for a month.

**Nothing computed is stored.** No totals, no day counts, no "waited 42 days" — those are derived at read time. A stored total is a number that goes stale and has to be maintained.

## Seeds — the low-consequence ones

Not everything worth keeping is a task or a decision. "Jan Schoonhoven relief" is neither — it is something to know about, eventually, when it comes up.

A curiosity is a **note**, not a list line: a stub in `70-knowledge/` with `status: seed`. It is a note because the note is where the learning will land, and because a note can be linked to — from a gallery visit, from a wish to buy a print, from a note about the Nul group. A line in a list can be linked from nowhere, which is the entire reason this vault uses wiki-links.

**What separates a seed from a wishlist item is what it ends in.**

|                      | Wishlist                                 | Seed                            |
| -------------------- | ---------------------------------------- | ------------------------------- |
| Ends in              | an act — buy, go, do                     | knowing                         |
| Lives in             | `30-lifestyle/wishlist.md`               | `70-knowledge/`, `status: seed` |
| Has a cost and a hold | yes                                     | no                              |
| Decays if ignored    | yes — and that is information about you  | no — and that is fine           |
| Leaves by            | bought, promoted, dropped                | being developed, or never       |

**A seed has no urgency and must not acquire any.** No due date, no hold, no review section, no count that should trend to zero. A seed you have not gotten to is not a failure and a list of forty is not a problem. The moment seeds are treated as a backlog they stop being curiosities and start being guilt.

Everything else is already in the schema:

```yaml
---
title: Jan Schoonhoven
type: note
status: seed
created: 2026-09-26
updated: 2026-09-26
tags: [art, occasion/home]
---

Nul group, Dutch, white reliefs. Worth knowing how they were made — cardboard and cheap
filler, painted white, which is the opposite of what they look like.
```

The body is optional, and one line is a complete seed — why it is worth knowing, or where it came from. Developing it later means writing the note and flipping `status` to `active`. Nothing moves, nothing is converted, and every link already pointing at it keeps working.

**Occasion tags** are what make a seed findable when its moment arrives: `#occasion/home` for the art you would buy for the flat, `#occasion/date` for the topic you would bring up, `#occasion/gift`. Use them only when there is a real occasion — a tag nobody queries is another field to maintain for nothing.

A seed can lead to a wish, and that is a link rather than a conversion: the wishlist line references `[[Jan Schoonhoven]]` and the seed stays where it is.

## Dreams

`## Dreams` is the last section of `30-lifestyle/wishlist.md`: things you want to do in your life. `Skydive`, `See the Northern Lights`, `Learn to sail`.

**Dreams are what you want your life to have in it; wishes are what you want next.** Both are wants and both are one line — the difference is **time horizon, not weight**. A dream is not a goal, a project, or a note; "skydive" needs no research plan and no `## Leading actions`, and treating every dream as a project is how a dream list stops being a pleasure.

**Language matters, and it is not decoration.** Say *dreams*, *things you want to do in your life*, *what you want your life to have in it*. Never "before you die", and never "bucket list" — that phrase comes from "kick the bucket", and this section is about living, not about mortality. A list that reads as an invitation gets used; one that reads as a deadline gets avoided.

**No waiting period, no review pressure, no count.** A dream sits on the list because it is true about you, not because it is due. It is allowed to wait years and nothing is wrong while it does, so `/pkb-review` surfaces only the ones that have started to move. **Never report an untouched dream as overdue, stale, or forgotten.**

**The exit is pursuit.** When a dream gets real — cost looked into, a date forming, money to save, a skill to build first — it is promoted to a goal note in `20-goals/` (`horizon: life`) and removed from the list. It has not stopped being a dream; it has acquired somewhere to be worked on. That is what `## Leading actions` and `## Progress` in the goal template are for, and it is the only reason to leave the one-line form.

**A place you want to go but have not started planning is a dream, not a trip.** It becomes a `40-travels/` note when it becomes a plan, which is the same promotion every other want goes through.
