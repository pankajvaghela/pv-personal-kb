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

1. Read every `*.md` in `<root>/40-travels/` except `travels.md`, taking `title`, `start`, `end`, `places`, `people`, and `status` from each.
2. Group by status: `active` → `## Planned`, `done` → `## Been`. **Anything else — `paused`, `archived`, or a note with no status — is listed separately at the end as unplaced**, with the reason. Do not silently drop a trip that exists; a note missing from its own index is worse than an untidy one.
3. Sort `Planned` by `start` ascending, soonest first. Sort `Been` by `end` descending, most recent first. When the sort key is missing, fall back to the other date; a trip with neither sorts last within its group, because an undated plan is the least actionable thing on the list.
4. Render one table per section:

   ```
   | Trip | Start | End | Places | People |
   | --- | --- | --- | --- | --- |
   | [[Kyoto 2026]] | 2026-11-03 | 2026-11-14 | Kyoto, Nara | [[Ana]], [[Ravi]] |
   ```

   **Start** and **End** are separate columns, each the plain ISO date or `—`. Never render a range like `2026-11-03 → 2026-11-14` — the two dates are separate facts and a merged cell cannot be sorted, compared, or read by anything. **Places** joins the `places` list with commas. **People** joins the `people` list with commas, each name wiki-linked **only if a note of that name exists in `<root>/60-people/`** — otherwise plain text. **Trip** is a wiki-link to the note, using its title — which is why the note's filename and title must agree.

   Every empty cell is `—`, not blank. A blank cell in a Markdown table reads as a rendering mistake; an em dash reads as "there is nothing here", which is a different and true statement.

   When a section is empty, keep the header row and put one italic line beneath it rather than leaving a blank table.

5. Report what changed in a line or two: rows added, removed, or moved between sections. If nothing changed, say that — an unchanged index is a normal result, not a failure.

**After the rebuild, offer one thing:** any trip in `## Planned` whose `end` date has passed, and which is still `status: active`. Ask whether to mark it done. The command does not infer this itself — a trip you came back from last week and have not written up yet is not the same as one you never took — but it is the one kind of staleness this index can actually see.

## `add <place>`

Two writes, in this order.

1. **The note** — `<root>/40-travels/<Title>.md` from `templates/trip.md`. Title is the trip, not the place: `Kyoto 2026`, not `Kyoto`. Two trips to the same city need two notes, and one note per place is how you end up overwriting the first with the second. If the user gave dates, set `start` and `end`; otherwise leave them empty — a trip can start as an intention. Fill `places` and `people` from what they told you, and leave either empty rather than guessing.
2. **The index** — regenerate as above.

Then say what is worth doing next, briefly: `## Outline` is the part worth writing first, since it is what changes when the plan moves, and `## Booked` is where the trip becomes real — an unchecked line there is the outstanding work. A trip with dates and an empty `## Booked` is the state this is designed to make visible.

**`people` is a list of names, not of links.** Write `Ana`, not `[[Ana]]` — the index decides whether a person note exists and links accordingly, so the field holds the name and the rendering holds the decision. That keeps a trip note readable on its own and keeps the link honest.

If a note with that title already exists, say so and ask whether to update it instead of creating a second.

## `been <trip>`

Set `status: done` and update `updated` in the trip note, then regenerate the index. Confirm in one line — it moved from `## Planned` to `## Been`.

Then offer the thing that actually preserves the trip: `## After` in the note is where "what was worth it, what to skip next time" goes, and it is worth nothing to anyone but you, which is exactly why it belongs in the note rather than in a message.

## Hard rules

- **Never hand-edit a row to fix it.** Fix the note's frontmatter and regenerate. A row that has been hand-patched is a row that will be silently reverted on the next `list`.
- **Never modify a trip note except on `add` and `been`.** No tidying, no reformatting, no filling in blanks.
- **Never drop a note from the index because its status is unexpected.** List it separately and say why.
- **Never delete a row or a note.** A trip that did not happen is `status: archived`, or stays where it is. `90-archive/` is for notes that have stopped mattering, and a trip you took always mattered.
