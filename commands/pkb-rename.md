---
description: Rename a note and repair every inbound wiki-link in the same pass
argument-hint: [<current note> → <new title>]
allowed-tools: Read, Edit, Glob, Grep, Bash
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then rename: $ARGUMENTS

**A rename is never one edit.** The filename is the wiki-link target, so moving a file breaks every note that points at it — silently, because a link to a note that does not exist yet is a normal thing in this vault and nothing will look wrong. The whole point of this command is that the move and the repair happen together or not at all.

## 1 — Find the note

Parse the request into a current note and a new title. If the user gave only one name, ask which note they mean rather than guessing.

Resolve the current note by, in order: exact filename, frontmatter `title`, then a case- and punctuation-insensitive match. Search all of `<root>` except `.obsidian/`, `.git/`, and `.pkb/`.

- **No match** → say so and list the closest few names. Do not create anything.
- **More than one match** → list them with paths and stop. A duplicate is a `/pkb-doctor` finding, not something to rename through.

## 2 — Check the destination before touching anything

Refuse, with the reason, when:

- **A file already exists at the new path.** Renaming onto an existing note destroys one of them. Two notes that should merge is a decision for the user, not a side effect of a rename.
- **The new title is empty, or contains `/`, `\`, `:`, or a leading `.`.** These are not filenames or not titles.
- **The note is structural** — `travels.md`, `wishlist.md`, `workboard.md`, `Home.md`, or anything in `.pkb/`. Those paths are referenced by commands; renaming one breaks the thing that owns it. Say which command owns it.
- **The note is in `05-daily/`.** Daily notes are named for their date and titled with it; there is nothing to rename.

## 3 — Show the plan, then act

**Present this before writing anything**, because it touches more than one file:

- the current path and the new path
- every inbound link you found, as `path:line` with the surrounding text
- anything that referenced the old title but that you cannot rewrite

Then apply it. On confirmation, in this order:

1. **Move the file.** `git mv` when the vault is a git repository, `mv` otherwise. Never `rm`, and never copy-and-delete.
2. **Set `title`** in the moved note to the new title, so the field and the filename agree. This is the one frontmatter edit a rename makes.
3. **Update `updated`** to today, in the renamed note and in every note whose links you rewrote. Those notes did change.
4. **Rewrite every inbound link**, in full:

   | Written as | Becomes |
   | --- | --- |
   | `[[Old]]` | `[[New]]` |
   | `[[Old\|alias]]` | `[[New\|alias]]` |
   | `[[Old#Heading]]` | `[[New#Heading]]` |
   | `[[Old#Heading\|alias]]` | `[[New#Heading\|alias]]` |
   | `[[Old.md]]` | `[[New]]` — drop the extension; the vault does not use it |
   | `![[Old]]` | `![[New]]` — embed, same rule |

   Replace only the link target. **The alias, the heading, and the surrounding prose are untouched** — you are repairing a pointer, not editing a sentence.

5. **Regenerate anything generated.** If the note was a trip, `travels.md` links to it by title, so run the `/pkb-travels list` rebuild. If the renamed note is a person, the travels index renders them by name and the same rebuild settles it.

## 4 — Report

One short block: old path → new path, how many links were repaired and in which files, and anything left. Then, only if it applies, one line about what to do next — a trip whose index needs rebuilding, or a `/pkb-commit` to make the rename reviewable as a single change.

## Hard rules

- **Never rename onto an existing file.** Stop and say so.
- **Never leave an inbound link unrepaired.** If one genuinely cannot be rewritten — outside the vault, in a binary, in a file you were not given access to — name it explicitly. A rename reported as clean that left a broken link behind is the exact failure this command exists to prevent.
- **Never edit prose.** The rename writes `title`, link targets, and `updated`. Nothing else in any note changes, and no note is reformatted or tidied along the way.
- **Never rename a folder.** This command renames one note. Moving a folder is a separate, larger change that rewrites every path beneath it.
- **Never touch `.obsidian/`, `.git/`, or `.pkb/`.**
