---
name: scaffold
description: "Scaffold a React app in a repo (root if single-stack, else frontend/): Vite react-ts, test + coverage config, Makefile, Dockerfile. Used by alphabetsoup:bootstrap or when adding React to an existing repo."
---

# React scaffold

`<dir>` = `frontend` (multi-stack) or `.` (single-stack). Templates in `${CLAUDE_SKILL_DIR}/templates/`; replace `{{name}}`.

1. From repo root: `npm create vite@latest <dir> -- --template react-ts`, then `cd <dir> && npm install`.
2. `npm install zustand @tanstack/react-query react-router` and `npm install -D prettier eslint-config-prettier vitest @vitest/coverage-v8 @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom`. Write `.nvmrc` with the current Node LTS major (24).
3. Add a `test` block to `vite.config.ts` (`environment: 'jsdom'`, setup file importing jest-dom) and merge `vitest.coverage.ts` into it. Add `eslint-config-prettier` last in the ESLint config.
4. Copy `Makefile`, `Dockerfile`, `nginx.conf`, `.dockerignore`.
5. Ensure one component test exists so `make check` is green; add `src/api/` for backend calls (dev proxy `/api` → backend when there is a backend).
6. Append to root `.gitignore`: `node_modules/ dist/ reports/ coverage/`.
7. Run `make fmt && make check` (normalizes generated files).

CI toolchain recipe: `${CLAUDE_SKILL_DIR}/ci.md`.
