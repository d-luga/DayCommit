# DayCommit

Instructions and context for Claude when working in this repository. This file is the single source of truth for the project: requirements, workflow, backlog and decisions. Keep it up to date when decisions change, and add a line to the Decisions log for every decision.

## What this is

DayCommit is a personal routine and task tracker: a weekly schedule with checkboxes, up to three important tasks per day, a running daily log, and a weekly review. Every change to the log, tasks and checkboxes is kept as a history of "commits" with diffs, so you can see what was planned, what changed and when.

It grew out of a single-file HTML prototype that Denis (the owner) has used daily since October 2026. The prototype lives in `public/prototype/index.html`. This repository is the proper rebuild.

The project has two goals, and both matter equally:

1. **A real tool** that Denis uses every day. He is the first user and the main tester.
2. **A portfolio project and a practice ground** for modern React and TypeScript. Denis is a senior frontend engineer refreshing his skills. Code quality, commit history and pull requests here will be seen by potential employers.

**Platforms:** web first, mobile-friendly and installable on a phone as a PWA (Progressive Web App). Native Android and iOS apps are a possible later step, not a current goal.

## Language

English everywhere: code, comments, commit messages, issues, pull requests, docs and UI text. Denis is improving his English: when he makes a noticeable mistake or uses unnatural phrasing, point it out briefly at the end of the reply (one or two items at most).

## How we work together

- **Denis writes part of the code himself.** Issues labeled `owner: denis` are his. Do not implement them unless he asks. When he asks for help on them, give hints, explanations and review first, and full solutions only on request.
- **Claude writes the rest.** Issues labeled `owner: claude`. For these, explain the approach and any non-obvious decisions in the pull request description, so Denis can review and understand every line. Assume he may be asked about this code in an interview.
- **Explain thoroughly.** Denis prefers complete explanations, including basics, over only "what changed". Link to official docs (react.dev, typescriptlang.org, MDN) where useful.
- **Abbreviations:** explain any abbreviation the first time it appears in an explanation to Denis.
- **Architecture decisions:** briefly list the alternatives and trade-offs, then recommend one. Only propose what fits the current infrastructure (see below).
- **Decisions:** when a decision is made, suggest a line for the Decisions log at the end of the reply.
- **Say it directly** when a request contradicts this file or common sense, or when new goals are added before current ones are finished.
- **Every change goes through a pull request** from a feature branch into `main`, docs included. Never push directly to `main`, except the initial commit.
- **One issue, one branch, one pull request.** Keep pull requests small enough to finish and review in one session.
- **Sessions:** Denis works on DayCommit Mon/Wed/Fri, 14:30-17:00. End every session with a one-line "next step" note in the issue or pull request.

### Branches and commits

- Branch names: `feat/<short-name>`, `fix/<short-name>`, `docs/<short-name>`, `chore/<short-name>`.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/): `feat: add daily log editor`, `fix: keep focus after save`, `docs: describe storage layer`, `test: ...`, `refactor: ...`, `chore: ...`.
- Small, meaningful commits. Each commit should build and pass tests.
- Merge pull requests with **rebase and merge** or a regular merge, not squash, so the individual commits stay visible in history.

## Privacy rule

**No personal data in this repository.** No real journal entries, task texts, names, personal schedules or exported data. Test fixtures and examples use invented, neutral content. Data files and exports belong in `.gitignore`. The repository is public.

## Tech stack

- React + TypeScript (strict mode, no `any`), built with Vite.
- Testing: Vitest + React Testing Library.
- Code quality: ESLint + Prettier.
- Styling: CSS Modules (SCSS allowed). Theme colors as CSS custom properties, light and dark themes.
- State: React state, `useReducer` and context to start with. Redux Toolkit may be introduced later as a deliberate learning step; that decision is open.
- Storage: behind a storage interface. First implementation: browser `localStorage`. Later: a small backend on the VPS. Components must not talk to storage directly.

## Infrastructure

- Hosting: OVHcloud VPS-1 (EU). The same server hosts Denis's other project.
- Domains: daycommit.com (primary) and daycommit.net. DNS at OVH.

## Product requirements

### Week view

- A week runs Monday to Sunday. Navigate to previous and next weeks, and back to the current week.
- **Weekdays (Mon-Fri):** the full schedule.
- **Saturday:** a buffer day. A morning block (up to 3 hours) to finish what the week left undone, plus the weekly review. The rest is free.
- **Sunday:** a full day off. Nothing to plan: Monday is planned on Friday.

### Daily schedule

- The schedule is data, not hard-coded markup: a list of blocks, each with a time range, a label, a group (Morning, Work, Evening, Weekend), a type and the days it applies to.
- Block types:
  - **tracked**: a checkbox per day;
  - **counter**: a number per day (for example, messages sent);
  - **untracked**: shown for orientation only, no checkbox (meals, a flexible slot, free time). These keep the day free of "empty" gaps.
- A block can apply to all seven days and have a different label on weekends (for example, "Get up at 7:30" on weekdays and "Get up by 8:30" on weekends). The label shown follows the day selected in the tasks panel.
- The column of the day selected in the tasks panel is highlighted in the schedule table.
- The default schedule ships as an example config with neutral English labels. Making the schedule editable in the UI is a later feature.

#### Example schedule

The default config, with neutral labels. Real personal schedules stay out of the repository.

| Time | Block | Type | Days |
| --- | --- | --- | --- |
| 7:30 (weekends by 8:30) | Get up | tracked | Mon-Sun |
| 7:45-8:30 | Morning walk | tracked | Mon-Fri |
| 8:30-9:00 | Breakfast | untracked | Mon-Fri |
| 9:00-11:45 | Deep work 1: learning | tracked | Mon-Fri |
| 12:00-13:00 | Admin and outreach | tracked | Mon-Fri |
| - | Messages sent | counter | Mon-Fri |
| 13:00-14:00 | Lunch | untracked | Mon-Fri |
| 14:00-14:30 | Short break | untracked | Mon-Fri |
| 14:30-17:00 | Deep work 2: project | tracked | Mon-Fri |
| 17:00-17:45 | Flexible slot | untracked | Mon-Fri |
| 17:45-18:00 | Plan tomorrow: 3 important tasks (on Friday, plan Monday) | tracked | Mon-Fri |
| 18:00-19:30 | Dinner and chores | tracked | Mon-Fri |
| 19:30-22:15 | Free time | untracked | Mon-Fri |
| 22:15-22:30 | Day summary written | tracked | Mon-Sun |
| 22:30-23:30 | Screens off, in bed by 23:30 (ticked the next morning) | tracked | Mon-Sun |
| Sat morning | Buffer: finish the week's leftovers (up to 3 hours) | tracked | Sat |
| Sat | Weekly review (20 minutes) | tracked | Sat |

### Tasks

- **Weekdays:** up to 3 important tasks (a hard limit; the point is focus) and any number of secondary tasks.
- **Weekends:** no important tasks, only secondary ones.
- Each task has text and a done state. Secondary tasks can be added and deleted.
- The day selector shows progress per day, for example `Wed 2/3` (important tasks on weekdays, secondary tasks on weekends).
- Today's tab in the day selector is clearly marked, even when another day is selected.
- A short hint encourages tasks that can be finished within one day.
- Task fields wrap long text and grow with it. Enter finishes editing (closes the on-screen keyboard); Shift+Enter adds a new line.

### Daily log and summary

- **Daily log:** a free-text field written throughout the day (not only in the evening).
- **Day summary:** a separate short field (1-2 lines) for the evening.
- Text fields must be large enough to read comfortably and grow with their content.

### Weekly review

- One free-text field per week, written on Saturday.
- Summary figures for the week: share of tracked items done, number of "minimum days", the weekly total of the counter.
- **Minimum day:** a weekday counts as a minimum day when a few key blocks are all checked. In the default config: the morning walk, the admin and outreach block, and at least one deep work block. The rule should be configurable later.

### History ("commits")

- Every editable field (log, summary, tasks, checkboxes, counters, weekly review) records history.
- A **commit** is a snapshot taken when the user finishes editing a field: on blur, or after about 2 minutes without typing. Not on every keystroke.
- A history panel per day lists commits with the time and what changed (for example `10:42 daily log`, `14:15 task 2 done`).
- Text changes show a diff: added text in green, removed text in red.
- Use an existing diff library rather than writing a diff algorithm.

### Multiple devices

- Denis uses the tracker on a laptop and a phone, sometimes with both open at once.
- **The prototype has a known bug:** each open tab saves the whole week from its own copy, so an older tab can overwrite newer changes (last write wins). DayCommit must not repeat it.
- Design sync from the start: save per field rather than whole documents, detect conflicts (for example, with a version number per record), and refresh open views when data changes elsewhere. The history of commits can help to recover from conflicts.

### Mobile

- Fully usable at phone width (about 400px), no horizontal page scroll.
- Tapping outside a text field or number input blurs it, so the on-screen keyboard closes.
- Installable as a PWA.

### Saving

- Autosave with a visible status ("Saving…", "Saved", or a clear error).
- Export and import of all data as JSON, for backups and for migrating data from the prototype.

## Backlog (to be turned into GitHub issues)

Suggested order. Owner can change when issues are created.

1. Finish project setup: Prettier, Vitest + React Testing Library, `test` and `format` scripts (owner: denis)
2. Data model and TypeScript types for weeks, days, blocks, tasks, history (owner: claude, reviewed by denis)
3. Storage interface + `localStorage` implementation, designed for per-field saves and sync (owner: claude)
4. Week navigation and layout shell (owner: denis)
5. Schedule table from config, with tracked, counter and untracked blocks and weekend labels (owner: denis)
6. Important and secondary tasks per day, weekend rules, today marker (owner: denis)
7. Daily log and day summary fields (owner: denis)
8. Weekly review and summary figures (owner: claude)
9. Saturday and Sunday modes (owner: denis)
10. History: commit capture on blur and idle (owner: claude)
11. History panel with text diffs (owner: denis, with guidance)
12. Mobile: blur on outside tap, layout checks, PWA manifest (owner: denis)
13. JSON export and import, including import from the prototype format (owner: claude)
14. Light and dark themes (owner: denis)
15. Deployment to the VPS with automatic deploys from `main` (owner: together)
16. Multi-device sync (owner: claude, design reviewed together)

### Prototype data format (for the importer)

One document per ISO week, id like `2026-W43`:

```json
{
  "week": "2026-W43",
  "checks": { "<blockId>_<dayIndex>": true },
  "apps": { "<dayIndex>": 3 },
  "tasks": { "<dayIndex>": [{ "t": "important task", "done": false }] },
  "tasks2": { "<dayIndex>": [{ "t": "secondary task", "done": true }] },
  "notes": { "<dayIndex>": "daily log text" },
  "summary": { "<dayIndex>": "day summary text" },
  "review": "weekly review text",
  "updated": "ISO timestamp"
}
```

- `dayIndex` is 0 for Monday to 6 for Sunday. Weeks before 2026-W43 only have 0-4.
- `tasks` always holds 3 slots per weekday; empty slots have `"t": ""`. `tasks2` and `summary` appear from 2026-W43.
- Current block ids: `wake`, `walk`, `deep1`, `job` (the outreach block), `apps` (the counter), `deep2`, `plan`, `wife` (the dinner and chores block), `review` (day summary written), `sleep`, `buffer`, `weekrev`. The ids are historical; the importer maps them to the new config.
- Legacy ids that may appear in older weeks: `read` (dropped), `ai` (a separate learning block, now part of `deep1`), `wakeWe` (merged into `wake`). `plan` used to be a morning block at 9:00; the habit is the same.

## Decisions log

Newest at the bottom. Format: date, decision, short reason.

- 2026-10-19: Name: DayCommit; domains daycommit.com and daycommit.net. The Git-style history is the core idea.
- 2026-10-19: Public repo d-luga/DayCommit, separate from SumBlend. Portfolio visibility.
- 2026-10-19: Stack: Vite + React + TypeScript (strict), Vitest + React Testing Library, ESLint + Prettier, CSS Modules. Matches Denis's learning plan.
- 2026-10-19: Workflow: every change through a pull request; roles `owner: denis` / `owner: claude`; Conventional Commits; no squash merges. Practice and a readable history.
- 2026-10-19: The history of changes is built in DayCommit only, not in the prototype. It's the project's core feature and worth building properly.
- 2026-10-21: Weekends: no important tasks, Saturday buffer and review, Sunday off. Planning moves to 17:45 on weekdays; Friday plans Monday.
- 2026-10-21: Web first, installable as a PWA; native apps maybe later. Keeps the scope realistic.
- 2026-10-21: Prototype kept in `public/prototype/`; real data stays in the Claude-hosted prototype until DayCommit has storage with sync. Avoids splitting data between two places.
- 2026-10-21: This file is the single source of truth (no separate brief). One document can't drift out of sync with itself.
- 2026-10-21: The example schedule in this file uses neutral labels. The repository is public; personal routines stay private.
