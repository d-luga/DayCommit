# DayCommit

**Your day, one commit at a time.**

DayCommit is a daily routine tracker for people who work from home and want structure without burning out. Plan three important tasks, follow a weekday schedule, keep a running log of the day, and review the week on Saturday. Every change is saved as a history of commits with diffs, so you can see not only what you did, but how your plans changed during the day.

> Status: early development. The app is being rebuilt in React and TypeScript from a working single-file prototype.

## Features

Planned for the first version:

- **Weekly schedule** with tracked blocks (checkboxes), counters and untracked blocks for orientation
- **Three important tasks a day**, plus any number of secondary ones
- **Daily log** written throughout the day, and a short evening summary
- **Weekly review** with summary figures, on a Saturday buffer day; Sunday stays a day off
- **History with diffs** for every field, in the spirit of Git commits
- **Mobile-friendly**, with light and dark themes
- **Autosave**, plus JSON export and import

## Tech stack

- [React](https://react.dev) and [TypeScript](https://www.typescriptlang.org) (strict mode)
- [Vite](https://vite.dev) for development and builds
- [Vitest](https://vitest.dev) and [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/) for tests
- ESLint and Prettier
- CSS Modules
- Storage: `localStorage` first, a small self-hosted backend later

## Getting started

Requirements: Node.js 20 or newer.

```bash
git clone https://github.com/d-luga/DayCommit.git
cd DayCommit
npm install
npm run dev
```

Then open the address Vite prints (usually http://localhost:5173).

Other scripts:

```bash
npm run build    # production build
npm run preview  # preview the production build
npm test         # run tests
npm run lint     # check code style
```

## Development workflow

- Work happens in feature branches and pull requests into `main`.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, ...).
- Planned work is tracked in [GitHub Issues](https://github.com/d-luga/DayCommit/issues).

This project is built with an AI pair programmer (Claude). Some features are written by me, some by Claude and reviewed by me; every change goes through a pull request.

## Roadmap

- [ ] Project setup
- [ ] Data model and local storage
- [ ] Schedule, tasks, daily log, weekly review
- [ ] Weekend modes
- [ ] History with diffs
- [ ] Mobile polish and themes
- [ ] Export and import
- [ ] Self-hosted deployment

## Author

Denis Lugavtsov · [GitHub](https://github.com/d-luga)
