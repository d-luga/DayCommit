# DayCommit

Instructions and context for Claude when working in this repository. Keep this file up to date when decisions change.

## What this is

DayCommit is a daily routine tracker: a weekday schedule with checkboxes, three important tasks per day, a running daily log, and a weekly review. Every change to the log, tasks and checkboxes is kept as a history of "commits" with diffs, so you can see what was planned, what changed and when.

It grew out of a single-file HTML prototype that Denis (the owner) used daily for a week. This repository is the proper rebuild.

The project has two goals, and both matter equally:

1. **A real tool** that Denis uses every day. He is the first user and the main tester.
2. **A portfolio project and a practice ground** for modern React and TypeScript. Denis is a senior frontend engineer refreshing his skills. Code quality, commit history and pull requests here will be seen by potential employers.

## Language

English everywhere: code, comments, commit messages, issues, pull requests, docs and UI text. Denis is improving his English: when he writes in English, point out mistakes briefly and politely, with the corrected version.

## How we work together

- **Denis writes part of the code himself.** Issues labeled `owner: denis` are his. Do not implement them unless he asks. When he asks for help on them, give hints, explanations and review first, and full solutions only on request.
- **Claude writes the rest.** Issues labeled `owner: claude`. For these, explain the approach and any non-obvious decisions in the pull request description, so Denis can review and understand every line. Assume he may be asked about this code in an interview.
- **Explain thoroughly.** Denis prefers complete explanations, including basics, over only "what changed". Link to official docs (react.dev, typescriptlang.org, MDN) where useful.
- **Every change goes through a pull request** from a feature branch into `main`. Never push directly to `main`, except the initial commit.
- **One issue, one branch, one pull request.** Keep pull requests small enough to finish and review in one session (about an hour). Denis works on this project in short sessions on alternating days.
- **End every session with a "next step" note** in the issue or pull request: one line saying where to continue.
- **Abbreviations:** explain any abbreviation the first time it appears in an explanation to Denis.

### Branches and commits

- Branch names: `feat/<short-name>`, `fix/<short-name>`, `docs/<short-name>`, `chore/<short-name>`.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/): `feat: add daily log editor`, `fix: keep focus after save`, `docs: describe storage layer`, `test: ...`, `refactor: ...`, `chore: ...`.
- Small, meaningful commits. Each commit should build and pass tests.
- Merge pull requests with **rebase and merge** or a regular merge, not squash, so the individual commits stay visible in history.

## Privacy rule

**No personal data in this repository.** No real journal entries, task texts, names, schedules or exported data. Test fixtures and examples use invented, neutral content. Data files and exports belong in `.gitignore`. The repository is public.

## Tech stack

- React + TypeScript (strict mode), built with Vite.
- Testing: Vitest + React Testing Library.
- Code quality: ESLint + Prettier.
- Styling: CSS Modules (SCSS allowed). Theme colors as CSS custom properties, light and dark themes.
- State: React state, `useReducer` and context to start with. Redux Toolkit may be introduced later as a deliberate learning step; that decision is open.
- Storage: behind a storage interface. First implementation: browser `localStorage`. Later: a small backend on Denis's own VPS (virtual private server). Components must not talk to storage directly.

## Product requirements

### Week view

- A week runs Monday to Sunday. Navigate to previous and next weeks, and back to the current week.
- **Weekdays (Mon-Fri):** the full schedule.
- **Saturday:** a buffer day. A morning block (up to 3 hours) to finish what the week left undone, plus the weekly review. The rest is free.
- **Sunday:** a full day off. Nothing to track except one item: "Plan Monday's three important tasks" in the evening.

### Daily schedule

- The schedule is data, not hard-coded markup: a list of blocks, each with a time range, a label, a group (Morning, Work, Evening) and a type.
- Block types:
  - **tracked**: a checkbox per day;
  - **counter**: a number per day (for example, job applications sent);
  - **untracked**: shown for orientation only, no checkbox (meals, a flexible slot, free time). These keep the day free of "empty" gaps.
- The column of the day selected in the tasks panel is highlighted in the schedule table.
- The default schedule ships as an example config with neutral English labels. Making the schedule editable in the UI is a later feature.

### Tasks

- Per day: **up to 3 important tasks** (a hard limit; the point is focus) and **any number of secondary tasks**.
- Each task has text and a done state.
- The day selector shows progress per day, for example `Wed 2/3`.
- A short hint encourages tasks that can be finished within one day.

### Daily log and summary

- **Daily log:** a free-text field written throughout the day (not only in the evening).
- **Day summary:** a separate short field (1-2 lines) for the evening.
- Text fields must be large enough to read comfortably and grow with their content.

### Weekly review

- One free-text field per week, written on Saturday.
- Summary figures for the week: share of tracked items done, number of "minimum days", total job applications.
- **Minimum day:** a weekday counts as a minimum day when the walk, the job search block and at least one deep work block are all checked. The rule should be configurable later.

### History ("commits")

- Every editable field (log, summary, tasks, checkboxes, counters, weekly review) records history.
- A **commit** is a snapshot taken when the user finishes editing a field: on blur, or after about 2 minutes without typing. Not on every keystroke.
- A history panel per day lists commits with the time and what changed (for example `10:42 daily log`, `14:15 task 2 done`).
- Text changes show a diff: added text in green, removed text in red.
- Use an existing diff library rather than writing a diff algorithm.

### Mobile

- Fully usable at phone width (about 400px), no horizontal page scroll.
- Tapping outside a text field or number input blurs it, so the on-screen keyboard closes.

### Saving

- Autosave with a visible status ("Saving…", "Saved", or a clear error).
- Export and import of all data as JSON, for backups and for migrating data from the prototype.

## Backlog (to be turned into GitHub issues)

Suggested order. Owner can change when issues are created.

1. Project setup: Vite + React + TypeScript, ESLint, Prettier, Vitest (owner: denis)
2. Data model and TypeScript types for weeks, days, blocks, tasks, history (owner: claude, reviewed by denis)
3. Storage interface + `localStorage` implementation (owner: claude)
4. Week navigation and layout shell (owner: denis)
5. Schedule table from config, with tracked, counter and untracked blocks (owner: denis)
6. Important and secondary tasks per day (owner: denis)
7. Daily log and day summary fields (owner: denis)
8. Weekly review and summary figures (owner: claude)
9. Saturday and Sunday modes (owner: denis)
10. History: commit capture on blur and idle (owner: claude)
11. History panel with text diffs (owner: denis, with guidance)
12. Mobile: blur on outside tap, layout checks (owner: denis)
13. JSON export and import, including import from the prototype format (owner: claude)
14. Light and dark themes (owner: denis)
15. Deployment to the VPS (owner: together)

### Prototype data format (for the importer)

One document per ISO week, id like `2026-W42`:

```json
{
  "week": "2026-W42",
  "checks": { "<blockId>_<dayIndex>": true },
  "apps": { "<dayIndex>": 3 },
  "tasks": { "<dayIndex>": [{ "t": "task text", "done": false }] },
  "notes": { "<dayIndex>": "daily log text" },
  "review": "weekly review text",
  "updated": "ISO timestamp"
}
```

`dayIndex` is 0 for Monday to 4 for Friday. Prototype block ids: `wake`, `walk`, `plan`, `deep1`, `job`, `apps` (counter), `deep2`, `review`, `wife` (labeled "Dinner, cooking, noisy chores"), `read` (dropped in the new version), `sleep`.
