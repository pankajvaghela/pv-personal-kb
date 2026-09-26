---
description: Show, add to, or resolve items on the PKB wishlist
argument-hint: [show | add <wish> | review | buy <item> | drop <item> | promote <item>]
allowed-tools: Read, Edit
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then work with `<root>/30-lifestyle/wishlist.md`.

Request: $ARGUMENTS

**The operating idea.** A wishlist does not fail at storing things — storing is free. It fails because nothing ever forces a decision, so the list only grows and eventually stops being read. Two rules fix that, and everything below follows from them:

- **Desire is tested by waiting, not recorded.** "How much do I want this?" answered at the moment of wanting is the impulse talking. Time is the only honest measure, so every wish gets a hold period.
- **Importance exempts you from the wait.** A thing you need but do not want will never clear a cooling-off period with any enthusiasm. Those go to `## Needed` and have no hold.

## `show` (default)

Print `## Off hold` in full — what, cost, how long it has been waiting, why. Then counts only for `Holding` and `Needed`. Then **the total cost of everything off hold**: that number is the point of the section, and it is the one thing a quote-a-day file cannot give you.

Flag anything off hold for more than **60 days**. Say plainly that it is not a pending purchase but a decision being avoided, and offer the three exits.

Compute totals from the lines. **Never write a total into the file** — a stored total is a number that goes stale and has to be maintained.

## `add <wish>`

One line under `## Holding` (or `## Needed` if the user says it is a need):

```
- [ ] <what> — ~$<cost> — added <YYYY-MM-DD> — <why> #wish/<kind>
```

Set the hold from the cost, and state the resulting date rather than asking:

| Cost | Hold | Because |
| --- | --- | --- |
| Under $100 | 7 days | Deliberating longer costs more than the thing does. |
| $100–$500 | 14 days | |
| Over $500 | 30 days | |
| No cost — `#wish/do` `#wish/go` `#wish/learn` | 30 days | Money is capped; time is not. Experiences and commitments deserve the longest wait, not the shortest. |

Ask at most **one** question: roughly what it costs. Do not interview — a wishlist with eight required fields gets filled in carelessly and then distrusted. If the user does not know the cost, leave it blank and put the wish under `Holding` with the 30-day default.

The `why` is one honest line. It is what the user will read in three weeks when they have forgotten the impulse but kept the reason — or discovered there was no reason.

## `review`

The sweep. This is the command's real job; `show` is just reading.

1. **Off hold** — list them with their total. For each, force one of four answers: **buy**, **extend** (give a new date and say why), **promote**, or **drop**. Do not accept "leave it" as an answer; that is the failure mode.
2. **Off hold for 60+ days** — the honest section. Say what they are: things the user has now passed over many times. Recommend dropping them, and note that dropping is not a loss — the wish is recorded in `## Done` and can be re-added later at the cost of one line.
3. **Long-held without a cost** — a wish that has been on the list for months with no price attached is usually not a wish but a mood. Ask what it would actually take to do it; if the answer is a plan rather than a purchase, it belongs somewhere else.
4. **Promotion candidates** — anything tagged `#wish/do`, `#wish/go`, or `#wish/learn` that needs sustained effort or a date. Propose the destination and say why: `40-travels/` for a place, `20-goals/` for an outcome with a target date, `10-workboard/workboard.md` if it is really just an action.
5. **`Needed`** — read it back. These have no hold by design, so the only question is whether they have been bought. If one has been sitting for weeks, the honest report is that it is not actually needed.

**Propose every change and get confirmation before editing.** Report the review as a short list of decisions, not a document.

## `buy <item>` / `drop <item>` / `promote <item>`

- **`buy`** — mark `- [x]` in place and note the date. Do not move it; `/pkb-review` sweeps checked items into `## Done`.
- **`drop`** — ask why in one line, then mark `- [x]` with the reason. **Kept, not deleted** — the record is what stops the same wish being re-added every few months. Treat "never mind" as a complete answer.
- **`promote`** — create or update the real note (goal, trip, project, or workboard line) and only then **remove** the wish line. It is not dropped, it moved; the note is a better record than the wishlist line ever was. Never remove it before the destination exists.

If the request is ambiguous about which item, list the close matches and ask. Otherwise make the edit and confirm in one line.

## Hard rules

- **The file stays literal GFM task lists.** No Dataview, no query-only views. Readable and editable on a phone, in a terminal, in any editor.
- **Never delete a wish line.** Bought and dropped items are checked, kept, and swept — the record is the anti-re-add mechanism.
- **Never write a computed value into the file** — no totals, no day counts, no "waited 42 days." Those are derived at read time.
- **Never accept "leave it" as a review answer.** The whole feature exists to make that answer impossible.
