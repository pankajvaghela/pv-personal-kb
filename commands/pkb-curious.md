---
description: Note something you want to know about — a seed in the knowledge folder, with no deadline
argument-hint: [<thing> | list | open <seed>]
allowed-tools: Read, Write, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`).

Request: $ARGUMENTS

**What this is for.** Things worth knowing about eventually — an artist, a period, a technique, a question — that are not tasks and not purchases. They end in knowing rather than in an act, which is what separates them from the wishlist: a wish decays if you ignore it, a curiosity does not.

**Create a seed, not a list line.** A note in `70-knowledge/` can be linked to from a gallery visit, a project, or a wish to buy a print. A line in a list can be linked from nowhere.

## `<thing>` (default)

Create `<root>/70-knowledge/<Title>.md`:

```yaml
---
title: Jan Schoonhoven
type: note
status: seed
created: <today>
updated: <today>
tags: [art]
---

Nul group, Dutch, white reliefs.
```

- **Title** is the subject, not the question — `Jan Schoonhoven`, not `Look into Jan Schoonhoven`. It is a link target, and `[[Look into Jan Schoonhoven]]` reads badly in every sentence that would ever reference it.
- **One line of body**, taken from what the user said. If they gave no reason, write where it came from instead: "came up re: gallery visit." Do not leave it empty and do not pad it — a seed is allowed to be one line.
- **Search `70-knowledge/` first.** If a note on the subject already exists, append to it and say so rather than creating a near-duplicate. If one exists and is a seed, this is a chance to develop it — ask.
- **Tags** are the subject, plus an occasion tag only if the user named one. Do not invent occasions.

Confirm in one line. **Do not ask a question** — this command exists to be faster than not writing it down. Everything can be refined later; the note is a place for it to land.

## `list`

Every note with `status: seed` — grep the frontmatter, do not maintain an index. Group by occasion tag when any exist, and show the rest as a plain list of titles.

**Report the count flatly, with no pressure attached.** No "you haven't touched these in months", no oldest-first ordering, no suggestion to prune. A seed list is not a backlog and this command must never treat it as one.

## `open <seed>`

Develop one. Read the note, ask what the user now knows about it, and write that into the body — then flip `status: seed` → `status: active` once the note holds something real.

Before flipping, check for links worth making: if the seed mentions something that has its own note, add the wiki-link in both directions. That is how a seed stops being an isolated stub and joins the graph.

**Never flip a seed to `active` on the user's behalf while listing.** Developing is a deliberate act, and an `active` note that says "Nul group, Dutch" is a lie about its own state.

## Hard rules

- **Seeds carry no dates, holds, or deadlines.** No `📅`, no "review by", no due field. The state is explicitly allowed to last years.
- **Never a workboard line and never a wishlist line.** If it needs an act, it belongs on the workboard; if it ends in a purchase or a trip, it belongs on the wishlist. Ask which and put it there instead.
- **Never delete a seed.** If it turns out to be wrong or uninteresting, flip it to `status: archived` — or just leave it. An unwanted seed costs nothing, which is the point.
- **Never present the list as a to-do.** No counts that should trend to zero, no staleness flags, no encouragement to clear it.
