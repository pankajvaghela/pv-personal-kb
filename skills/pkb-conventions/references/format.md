# Format and syntax

Read this when a task touches **note content** — choosing between plain Markdown and an app-specific feature, writing or editing a template, or deciding whether something belongs in the file at all.

## What this vault depends on

**Markdown is the format. Everything else is a view of it.** Nothing here requires Obsidian or any other app. Delete every editor tomorrow and the vault is still a directory of readable text. Viewers are interchangeable — Obsidian, VS Code, iA Writer, GitHub, `less`.

| Thing | Status |
| ----- | ------ |
| `.md` files with YAML frontmatter | **Required.** This is the format. |
| The folder taxonomy | **Required.** Ordinary directories. |
| GFM task lists | **Required.** Plain checkboxes. |
| `[[Wiki-links]]` | **Required convention.** Read by Obsidian, Foam, Logseq, Dendron, Quartz, and most other folder-of-Markdown tools. Not CommonMark — see below. |
| A Markdown viewer | **Suggested — pick any.** Obsidian is a good one: it renders the links, draws the graph, and shows frontmatter as properties. It is one option among several, not a requirement, and the vault must never be organized around it. |
| Dataview, callouts, embeds | Optional, and Obsidian-only. Use them where they earn their keep; they render as nothing anywhere else. |
| `📅 YYYY-MM-DD` on a workboard line | An Obsidian **Tasks** plugin convention. Elsewhere it is just an emoji — which is why the date stays readable as plain text. |
| `.obsidian/` | Editor state. Git ignores the churn and keeps your config. |
| `templates/` | Note skeletons using Obsidian's `{{title}}` / `{{date}}` variables. |

## Templates speak Obsidian

They use `{{title}}` and `{{date:YYYY-MM-DD}}` — the one place the vault depends on an app's syntax, kept because it is what makes the Templates plugin useful.

That is a **deliberate exception, not a precedent.** Claude substitutes these variables itself, so a note created by a command is correct with or without Obsidian. If you edit a template, keep the same variable form so both paths keep working, and never let a literal `{{...}}` reach a finished note.

## Why wiki-links are deliberate, not accidental

`[[Note Title]]` is not CommonMark, so GitHub and bare text editors show it as literal text rather than a link. It is still the right default here, for two reasons.

It is the **shared convention** across file-based PKM tools — Obsidian, Foam, Logseq, Dendron, Quartz all read it. And it needs only the note's **filename**, not a relative path, which matters enormously when an AI writes the link: a guessed relative path fails silently, while a filename is either right or obviously missing.

If you ever want GitHub-native rendering, converting to `[Note](Note.md)` is mechanical. It touches every note, so it is worth deciding while the vault is still small.

## Prefer plain Markdown where it costs nothing

A fenced code block over a callout, a table over a query, a real word over an emoji. The vault should still read correctly in any text editor in ten years, and every app-specific feature you lean on is one more thing that renders as nothing elsewhere.

This is a **preference, not a prohibition.** Use the feature when it genuinely earns its keep, and do not contort a note to avoid one. The test is what it costs elsewhere: a Dataview query that saves you maintaining a list is usually worth it, and a callout that only changes a block's colour usually is not.

**Five link forms are in use** and all of them are valid: `[[Note Title]]`, `[[Note Title|display text]]`, `[[Note Title#Heading]]`, `[[Note Title#Heading|display text]]`, and `![[Note Title]]` for an embed. Link liberally — a link to a note that does not exist yet is a useful marker, not an error.
