# Travels

Read this when a task touches **a trip or the travels index** — `/pkb-travels`, and the travels section of `/pkb-review`. A place you want to go but have not started planning is not here; it is a dream (see `desire.md`).

`40-travels/` is flat — one note per trip, titled with the trip rather than the place (`Kyoto 2026`, not `Kyoto`; two trips to the same city need two notes). `travels.md` in the same folder is the **index**: a table of every trip, generated from the trip notes.

**The index is generated, not curated.** `/pkb-travels` rebuilds it from each note's `title`, `start`, `end`, `places`, `people`, and `status`. Never hand-edit a row — fix the note's frontmatter and regenerate, or the next rebuild silently reverts it. The file exists so the whole travel history is visible as a table in any editor; it is not a second place where trip facts live.

The table is `| Trip | Start | End | Places | People |`. **Dates are separate columns, never a `start → end` range** — a range is a rendering of two fields, and a column you cannot sort or read is a column that has thrown the data away. Missing values are `—`.

`people` names who the trip was with, and each one wiki-links to their `60-people/` note **when that note exists** — otherwise the name is plain text. A link to a person note that has not been written yet is allowed, but a name rendered as a link that nothing resolves is a broken link `/pkb-review` will report forever, so the link is earned rather than assumed. The field itself holds names, not links: `Ana`, never `[[Ana]]`.

`## Planned` holds `status: active` trips soonest-first by `start`; `## Been` holds `status: done` trips most-recent-first by `end`. A note with any other status is listed separately as unplaced rather than dropped — **a trip missing from its own index is worse than an untidy one.**

**The note is the record; the index is a view of it.** A trip note carries the `## Outline` — the trip in **legs**, one row per city or stretch, which is what makes a two-city trip legible before anything is booked — the day-by-day `## Plan` with a time column, a `## Booked` list where a checkbox means *confirmed*, a `## Budget` estimated against actual, `## Packing / prep`, and `## After` for what was worth it.

`## Plan` is one row per thing, not one row per day. A day with four things on it gets four rows with the date left blank on the repeats, because the unit being scheduled is the flight, the check-in, the set — not the day. The `Date` column is ISO; **there is no weekday column, because the weekday follows from the date.**

**A trip built around an event is the ordinary case, not the exotic one.** A festival pass is a booking: it belongs in `## Booked` under `### Events` with its price and payment status, and everything else in the itinerary arranges itself around it.

Three things deliberately do not live in a trip note:

- **A total.** A sum is derived, and a stored sum goes stale the moment a line changes.
- **A trip to-do list.** An action with a date belongs on the workboard, where `/pkb-morning` reads it and `/pkb-review` notices it going stale. A checklist inside a trip note is a second list nobody sweeps, and a trip note gets opened the week before the trip — exactly when a forgotten action is too late to fix.
- **Generic prep boilerplate.** "Useful apps", "emergency contacts", "phrases to learn" are the sections that get copied from the last trip, still naming the last trip's city. Anything that is true of every trip is not worth a heading in this one.

`## Booked` does something a record does not: a checkbox there means *confirmed*, so the section doubles as the trip's status. A trip with dates and nothing ticked is visibly not yet real. That is why the index reports dates and the note reports readiness — the index can see a trip's dates from the outside, and only the note knows whether a single thing has been booked.

**A trip's title and its filename must agree.** The note is created as `<Title>.md`, and the index links to it by the `title` field — so if the two drift apart the index produces a link that resolves to nothing. This is the one note type where that matters enough to check.
