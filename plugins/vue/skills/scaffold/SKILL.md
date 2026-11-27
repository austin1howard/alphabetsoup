---
name: scaffold
description: "Scaffold a Vue 3 app in a repo (root if single-stack, else frontend/): create-vue, coverage config, Makefile, Dockerfile. Used by alphabetsoup:bootstrap or when adding Vue to an existing repo."
---

# Vue scaffold

`<dir>` = `frontend` (multi-stack) or `.` (single-stack). Templates in `${CLAUDE_SKILL_DIR}/templates/`; replace `{{name}}`.

1. From repo root: `npm create vue@latest -y -- --bare --ts --router --pinia --vitest --eslint --oxfmt <dir>`, then `cd <dir> && npm install`.
2. `npm install -D @vitest/coverage-v8@<installed vitest version> && npm install @vueuse/core`. Write `.nvmrc` with the current Node LTS major (24).
3. Merge `vitest.coverage.ts` into the `test` block of the Vitest config.
4. Copy `Makefile`, `Dockerfile`, `nginx.conf`, `.dockerignore`.
5. Ensure one component test exists so `make check` is green; add `src/api/` for backend calls (dev proxy `/api` → backend in `vite.config.ts` when there is a backend).
6. Append to root `.gitignore`: `node_modules/ dist/ reports/ coverage/`.
7. Run `make fmt && make check` (normalizes generated files).

CI toolchain recipe: `${CLAUDE_SKILL_DIR}/ci.md`.
