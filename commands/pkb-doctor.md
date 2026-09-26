---
description: Check the vault's internal consistency — title/filename agreement, frontmatter, broken links, duplicates
argument-hint: [fix]
allowed-tools: Read, Edit, Glob, Grep
---

Load the `pkb-conventions` skill and resolve the vault root from it (call that path `<root>`), then check the vault's health: $ARGUMENTS

**This command reports; it does not tidy.** Everything here is a structural fact you can verify, not a judgment about your notes. A clean vault is the expected result, and saying "nothing found" is a complete and successful run.

**This is not `/pkb-review`.** The review is weekly and behavioural — what is stale, what needs a decision. This is structural and run on demand: is the vault internally consistent, the way a linter asks. The one overlap is broken links, which the review mentions in passing and this checks exhaustively.

## 0 — Read this vault's rules before checking anything

**The plugin's conventions are defaults. This vault's conventions are the law.** Everything below describes what a vault gets out of the box; a vault is allowed to have amended it, and the amendments live in `<root>/AGENTS.md` under `## Local conventions`.

Read that file first, every time. Then lint against the **effective** rules — defaults with the local amendments applied — and never against the shipped ones.

This matters more here than anywhere else in the plugin, because doctor's whole job is deciding what counts as a problem. A vault that allows project subfolders, groups goals by area, or keeps a folder this plugin has never heard of is not a vault with findings; it is a vault with conventions, and reporting them would teach the user that the report is noise.

**When a check below is about to fire, ask whether `AGENTS.md` permits it.** If it does, it is not a finding — say nothing about it. If the permission is ambiguous, leave it out of the findings and mention it once, separately, as a question about the convention rather than a fault in the vault.

State which local conventions you found at the top of the report, in one line. If there are none, say that — a reader needs to know the defaults were the only thing applied.

Work through the checks in order and report each. Say nothing about a check that found nothing beyond a one-line "clean".

## 1 — Title and filename agreement

The load-bearing check. Wiki-links resolve against **filenames**, and the travels index links trips by their **`title` field** — so when the two disagree, links come out pointing at nothing.

For every note, compare frontmatter `title` to the filename minus `.md`. Report each mismatch with both values.

Do not decide which is right. Both directions are legitimate and only the user knows which: renaming the file preserves the title people see, and rewriting the title preserves the path other things already point at. Offer both, per note, and never apply either silently.

Skip `05-daily/` — those are titled with their date and will match. Skip `travels.md`, `wishlist.md`, `workboard.md`, `Home.md`, and `AGENTS.md`, which are structural rather than notes.

## 2 — Frontmatter

- **No frontmatter block**, or one that does not parse as YAML.
- **Missing** `title`, `type`, `status`, `created`, or `updated`. A note without `type` and `updated` is invisible to every review and query.
- **A `title` containing a colon that is not quoted** — `title: Kyoto: Day 2` is valid-looking and invalid YAML. This is the one frontmatter fault that breaks tooling rather than merely disappointing it.
- **A date that is not ISO-8601** in `created`, `updated`, `due`, `target`, `start`, `end`, or `last_contact`. Report the value; do not guess at `03/04/2026`, which is two different dates depending on where you are standing.
- **`updated` earlier than `created`** — either a typo or a copied note, and worth a look either way.
- **A `type` or `status` value outside the schema.** These are enumerated in the conventions skill; anything else is either a typo or a genuinely new value that should be added to the schema deliberately.

## 3 — Type against folder

A note whose `type` does not match the folder it lives in. `type: trip` outside `40-travels/`, a `person` outside `60-people/`. Report it and say which of the two looks wrong, without moving anything — a note can be in transit, and this is a signal rather than an error.

**Skip this check entirely for any folder or nesting level `AGENTS.md` permits.** A locally-defined folder has no default `type`, and inventing one for it is the mistake this section exists to avoid.

## 4 — Broken wiki-links

Every `[[Target]]` with no file at that name anywhere in the vault.

**Split the results, because most broken links are not problems.** A link to a note that has not been written yet is a deliberate marker in this vault — the conventions say so explicitly. What is worth reporting is narrower:

- **Near-misses** — a target within an edit or two of an existing note, or differing only by case, punctuation, or a trailing "s". These are the ones that are probably typos, and they are the actionable list.
- **Everything else** — links whose target has never existed. List them under a separate heading, once, as a count and the most-linked few. Do not present them as failures.

Never rewrite a broken link on your own initiative. The fix for a near-miss is almost always to correct the link, but the fix for the rest is to write the note, and only the user knows which is which.

## 5 — Duplicate notes

Two notes whose titles match once case, punctuation, and `&`/`and` are normalised — `Ana Ruiz` and `ana ruiz`, or `BKF Kos-Athens` and `BKF Kos — Athens`. Check `60-people/` first and hardest: a split person note is the duplicate that actually costs something, because it splits the history.

Report candidates. **Never merge.** Merging is a decision about content, and this command does not make those.

## 6 — Files outside the taxonomy

Files at the vault root or loose in a folder that the taxonomy does not account for. `AGENTS.md`, `Home.md`, `.gitignore`, `.pkb/`, and `.obsidian/` are expected; anything else is worth naming. A note sitting at the vault root rather than in a folder usually belongs in `00-inbox/`, but ask rather than filing it.

**Anything `AGENTS.md` accounts for is inside the taxonomy, whatever the shipped default says**, including a folder the plugin has never heard of. Check the local conventions before naming a path here — this is the check most likely to produce a false finding.

## 7 — Orphaned attachments

Files in `00-inbox/attachments/` that no note references. **Report only.** An attachment can be referenced from outside the vault, and this command does not delete anything under any circumstances.

## 8 — Secrets in the committed config

The same value-level check `/pkb-commit` runs, surfaced early — before the file is staged rather than at commit time.

Read `<root>/.pkb/config.json` and check the **values**, not the filename: anything in an `env` map or a `command` that is not a `$SECRET:<key>` reference and looks like a token, key, or password. That file is committed, so a literal credential in it is a leaked credential.

**If you find one, stop the report and lead with it.** Name the key it sits under and say what to do — move the value into `secrets` in `~/.config/pv-personal-kb/config.json` and reference it as `$SECRET:<key>`. **Do not echo the value into the transcript**, and do not write a fix yourself: this command cannot reach the machine config, and a half-moved secret is worse than a flagged one.

## 9 — Scaffold drift

Compare `<root>/.pkb/version` against the installed plugin version. If the vault's scaffold is behind, say so in one line and point at `/pkb-upgrade` — this command does not run it, because deciding whether to take a newer scaffold file is the upgrade's job and not a health check's.

## `fix`

**Default is read-only.** Everything above reports and stops.

With `fix`, apply only the repairs that are mechanical and have exactly one correct answer:

- **Quote a `title` that breaks YAML.** The value does not change; only its quoting does.
- **Fill a missing `updated` from `created`.** The only honest value available, and leaving the field absent breaks every query that reads it.

That is the whole automatic list, and it is short on purpose.

Then walk the remaining findings **one at a time**, in order, offering the action and waiting for an answer. Title/filename mismatches get both directions. Near-miss links get the corrected target. Stray files get `00-inbox/`. A secret gets the instruction from check 8 and nothing else.

Never batch these into one confirmation. Each one is a small judgment, and a wall of them is one the user will approve without reading.

## Hard rules

- **Never report a locally-permitted structure as a finding.** `AGENTS.md` wins over the defaults, always. A vault's own conventions are the specification this command checks against, not the plugin's.
- **Never delete anything.** Not an attachment, not a duplicate, not a stray file. `90-archive/` is the only destination for a note that has stopped mattering, and it is not this command's call.
- **Never merge two notes.** Report the candidates and stop.
- **Never rewrite a note's prose.** The only fields this command writes are `title`'s quoting, `updated`, and — on an explicitly accepted suggestion — a link target.
- **Never guess a date.** An ambiguous `03/04/2026` is reported, not interpreted.
- **Never present an unwritten note as an error.** A link to a note that does not exist yet is a marker, not a fault.
- **Never write the report to a file.** It is printed. A stored health report is one more thing that goes stale.
