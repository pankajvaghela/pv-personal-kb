---
description: Show, add to, or resolve items on the PKB wishlist
argument-hint: [show | add <wish> | review | buy <item> | drop <item> | promote <item>]
allowed-tools: Read, Edit
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then work with `<root>/30-lifestyle/wishlist.md`.

Request: $ARGUMENTS

**What this is: an inbox for desire.** Something you want, captured cheaply, held until it is clear what to do with it — then promoted into a goal, a project, a trip, or a workboard line, or dropped.

It is an inbox, but not one you clear in a sitting. **Every other inbox in this vault is processed as fast as possible; this one is processed slowly, on purpose**, because desire is not legible on the day you feel it. That one constraint produces the whole design:

- **Capture asks nothing.** Like `/pkb-capture`, `add` never interviews you — the judgment happens at review. A wishlist entry that costs a question to write is one that does not get written.
- **Desire is tested by waiting, not recorded.** "How much do I want this?" answered at the moment of wanting is the impulse talking. Time is the only honest measure, so every wish gets a hold period, and the hold is the triage delay rather than a delay before triage.
- **Importance exempts you from the wait.** A thing you need but do not want will never clear a cooling-off period with any enthusiasm. Those go to `## Needed` and have no hold.

A wishlist does not fail at storing things — storing is free. It fails because nothing ever forces a decision, so the list only grows and eventually stops being read. The review below is the forcing function.

## `show` (default)

Print `## Off hold` in full — what, cost, how long it has been waiting, why. Then counts only for `Holding` and `Needed`. Then **the total cost of everything off hold**: that number is the point of the section, and it is the one thing a quote-a-day file cannot give you.

Flag anything off hold for more than **60 days**. Say plainly that it is not a pending purchase but a decision being avoided, and offer the three exits.

Compute totals from the lines. **Never write a total into the file** — a stored total is a number that goes stale and has to be maintained.

## `add <wish>`

One line under `## Holding` (or `## Needed` if the user says it is a need):

```
- [ ] <what> — ~$<cost> — added <YYYY-MM-DD> — <why> #wish/<kind>
```

**Ask nothing.** If the user volunteered a cost, use it to set the hold and state the resulting date. If they did not, use the 30-day default and move on — a wish captured without a price is not an incomplete entry, it is a normal one, and the price can be filled in at review.

| Cost | Hold | Because |
| --- | --- | --- |
| Under $100 | 7 days | Deliberating longer costs more than the thing does. |
| $100–$500 | 14 days | |
| Over $500 | 30 days | |
| No cost — `#wish/do` `#wish/go` `#wish/learn`, or simply unknown | 30 days | Money is capped; time is not. Experiences and commitments deserve the longest wait, not the shortest, and an unassessed wish should wait longer rather than less. |

The `why` is one honest line, taken from what the user said. It is what they will read in three weeks when the impulse has faded but the reason has not — or when they discover there was no reason.

**Never ask more than the user volunteered.** The hold starts at capture, not at assessment, because the desire is already ageing and restarting the clock at review would defeat the only mechanism that works.

## `review`

The sweep. This is the command's real job; `show` is just reading.

1. **Off hold — process it.** This is the inbox triage, and it is the reason the command exists. List them with their total, then force one of four answers on each:
   - **Promote** — the usual answer, and the sign the wish has become legible. It is now clear what it is: a goal, a project, a trip, or a workboard line. Buying a specific thing counts here too — "buy the keyboard" is a task, and if it is more than a ten-minute act it belongs on the workboard rather than in this file.
   - **Extend** — still genuinely unclear. Give a new date and one line saying what is unresolved. An extension is allowed, but it has to say something.
   - **Drop** — the desire did not survive contact with time. That is the mechanism working, not a failure.
   - **Buy** — small, decided, done. Mark it and move on.

   Do not accept "leave it" as an answer. That is the failure mode this whole feature exists to make impossible.
2. **Off hold for 60+ days** — the honest section. Say what they are: things the user has now passed over many times. Recommend dropping them, and note that dropping is not a loss — the wish is recorded in `## Done` and can be re-added later at the cost of one line.
3. **Long-held without a cost** — a wish that has been on the list for months with no price attached is usually not a wish but a mood. Ask what it would actually take to do it; if the answer is a plan rather than a purchase, it belongs somewhere else.
4. **Promotion candidates** — anything tagged `#wish/do`, `#wish/go`, or `#wish/learn` that needs sustained effort or a date. Propose the destination and say why: `40-travels/` for a place, `20-goals/` for an outcome with a target date, `10-workboard/workboard.md` if it is really just an action.
5. **`Needed`** — read it back. These have no hold by design, so the only question is whether they have been bought. If one has been sitting for weeks, the honest report is that it is not actually needed.

**Propose every change and get confirmation before editing.** Report the review as a short list of decisions, not a document.

## `buy <item>` / `drop <item>` / `promote <item>`

- **`buy`** — mark `- [x]` in place and note the date. Do not move it; `/pkb-review` sweeps checked items into `## Done`.
- **`drop`** — ask why in one line, then mark `- [x]` with the reason. **Kept, not deleted** — the record is what stops the same wish being re-added every few months. Treat "never mind" as a complete answer.
- **`promote`** — act on the desire, which means it stops being a wish. Create or update the real destination (goal, trip, project, or workboard line) and only then **remove** the wish line. It is not dropped, it moved — the destination is a better record than the line ever was. Never remove it before the destination exists. This is the primary exit and the one to steer toward: a wish that has been promoted has done its job.

If the request is ambiguous about which item, list the close matches and ask. Otherwise make the edit and confirm in one line.

## Hard rules

- **The file stays literal GFM task lists.** No Dataview, no query-only views. Readable and editable on a phone, in a terminal, in any editor.
- **Never delete a wish line.** Bought and dropped items are checked, kept, and swept — the record is the anti-re-add mechanism.
- **Never write a computed value into the file** — no totals, no day counts, no "waited 42 days." Those are derived at read time.
- **Never accept "leave it" as a review answer.** The whole feature exists to make that answer impossible.
