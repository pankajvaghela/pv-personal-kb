# Workboard

Read this when a task **adds, completes, moves, or reviews action items** — `/pkb-workboard`, `/pkb-triage`, `/pkb-review`, `/pkb-morning`, `/pkb-end-of-the-day`.

`10-workboard/workboard.md` holds action items as **literal GFM task lists**, grouped by horizon:

```markdown
## Now

- [ ] Ship the plugin #project/pv-personal-kb 📅 2026-09-30

## Next

- [ ] Book the Kyoto ryokan #travel/japan

## Waiting

- [ ] Awaiting quote from the builder #people/sam

## Someday

- [ ] Learn to sail #area/lifestyle
```

Rules:

- One line per action. State the action, not the topic.
- Trailing `#tag` and `📅 YYYY-MM-DD` are the only inline metadata.
- The source is literal checkboxes, so `grep` works and any editor's task queries work. A Dataview view on top is fine; a Dataview-only workboard is not — the file has to stay readable as text.
- Completed items are checked, not deleted. `/pkb-review` sweeps them into `## Done — <month>`.
- Per-project action items may live inside the project note under `## Actions`. The workboard is for what is live _now_ — promote, do not duplicate.

**The four horizons are a promise about attention, not a priority ranking.** `Now` is what is actually being worked on this week; anything sitting there for more than two weeks without moving is a `Next` item wearing a costume. `Waiting` is blocked on someone or something else — if nothing is blocking it, it is not waiting. `Someday` is for things that are real but not scheduled.
