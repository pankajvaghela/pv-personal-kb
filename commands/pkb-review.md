---
description: Weekly PKB review — clear the inbox, sweep the workboard, surface stale work
argument-hint: [optional: week or date range to review]
allowed-tools: Read, Edit, Write, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then run a review of the PKB. Period: $ARGUMENTS (default: the last seven days).

Work through these in order and report each as a short section:

1. **Inbox count.** How many items sit in `00-inbox/`, oldest first. If more than ten, say so plainly — that is the real signal.
2. **Workboard hygiene.** In `10-workboard/workboard.md`: sweep checked items into `## Done — <month>`; list anything past due; list anything sitting in `Now` for more than two weeks without progress and ask whether it should drop to `Next`.
3. **Wishlist.** In `30-lifestyle/wishlist.md`: sweep checked items into `## Done`, then list what is off hold with its **total cost**, and anything off hold for more than 60 days. This is the wishlist's only forcing function — nothing else makes anyone look at it. Follow `/pkb-wishlist review` for how to push on each one; the short version is that "leave it" is not an answer.
4. **Stale projects.** In `50-projects/`, find any with `status: active` whose `updated` is more than three weeks old. Ask for each: still active, or archive?
5. **Orphan notes.** List notes in `70-knowledge/` with no inbound or outbound wiki-links. Do not fix them — just name them.
6. **Broken links.** Report any `[[Wiki Link]]` whose target file does not exist.
7. **This week.** Ask what actually moved, and offer to write it into the relevant project notes.

**Ask before editing.** Sections 1, 5, 6, and 7 are read-only. Present findings, get confirmation, then apply the workboard and wishlist sweeps and any status changes.

Keep the whole report under a screen. The review is a decision point, not a document.
