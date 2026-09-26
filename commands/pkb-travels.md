---
description: Travels index — the table overview of every trip, kept in sync with the trip notes
argument-hint: [list | add <place> | been <trip>]
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then work with `<root>/40-travels/`.

Request: $ARGUMENTS

**The index is generated, not curated.** `<root>/40-travels/travels.md` is a view of the trip notes in the same folder, rebuilt from their frontmatter. That is the whole reason it stays true: a hand-maintained index rots the moment you stop tending it, and nothing in this vault should require remembering to update a second place.

So: **never ask the user to fix a row, and never hand-edit one to fix a discrepancy.** If a row is wrong, the note's frontmatter is wrong — fix that and regenerate.

**Never overwrite a trip note.** This command writes `travels.md` and, on `add`, creates one new note. Everything else in the folder is out of scope, permanently.

## `list` (or empty)

Rebuild `travels.md` from the trip notes.

1. Read every `*.md` in `<root>/40-travels/` except `travels.md`, taking `title`, `start`, `end`, `places`, and `status` from each.
2. Group by status: `active` → `## Planned`, `done` → `## Been`. **Anything else — `paused`, `archived`, or a note with no status — is listed separately at the end as unplaced**, with the reason. Do not silently drop a trip that exists; a note missing from its own index is worse than an untidy one.
3. Sort `Planned` by `start` ascending, soonest first. Sort `Been` by `end` descending, most recent first. A trip with no dates sorts last within its group, because an undated plan is the least actionable thing on the list.
4. Render one table per section:

   ```
   | Trip | Dates | Places |
   | --- | --- | --- |
   | [[Kyoto 2026]] | 2026-11-03 → 2026-11-14 | Kyoto, Nara |
   ```

   **Dates** are `start → end`, or just `start` when there is no end, or `—` when there is neither. **Places** joins the `places` list with commas, or `—`. **Trip** is a wiki-link to the note, using its title — which is why the note's filename and title must agree.

   When a section is empty, keep the header row and put one italic line beneath it rather than leaving a blank table.

5. Report what changed in a line or two: rows added, removed, or moved between sections. If nothing changed, say that — an unchanged index is a normal result, not a failure.

**After the rebuild, offer one thing:** any trip in `## Planned` whose `end` date has passed, and which is still `status: active`. Ask whether to mark it done. The command does not infer this itself — a trip you came back from last week and have not written up yet is not the same as one you never took — but it is the one kind of staleness this index can actually see.

## `add <place>`

Two writes, in this order.

1. **The note** — `<root>/40-travels/<Title>.md` from `templates/trip.md`. Title is the trip, not the place: `Kyoto 2026`, not `Kyoto`. Two trips to the same city need two notes, and one note per place is how you end up overwriting the first with the second. If the user gave dates, set `start` and `end`; otherwise leave them empty — a trip can start as an intention.
2. **The index** — regenerate as above.

Then say what is worth doing next, briefly: the note's `## Plan` table and `## Booked` list are where it earns its place, and a trip with dates but nothing booked is the state this is designed to make visible.

If a note with that title already exists, say so and ask whether to update it instead of creating a second.

## `been <trip>`

Set `status: done` and update `updated` in the trip note, then regenerate the index. Confirm in one line — it moved from `## Planned` to `## Been`.

Then offer the thing that actually preserves the trip: `## After` in the note is where "what was worth it, what to skip next time" goes, and it is worth nothing to anyone but you, which is exactly why it belongs in the note rather than in a message.

## Hard rules

- **Never hand-edit a row to fix it.** Fix the note's frontmatter and regenerate. A row that has been hand-patched is a row that will be silently reverted on the next `list`.
- **Never modify a trip note except on `add` and `been`.** No tidying, no reformatting, no filling in blanks.
- **Never drop a note from the index because its status is unexpected.** List it separately and say why.
- **Never delete a row or a note.** A trip that did not happen is `status: archived`, or stays where it is. `90-archive/` is for notes that have stopped mattering, and a trip you took always mattered.
