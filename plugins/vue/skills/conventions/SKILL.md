---
name: conventions
description: "Vue 3 coding conventions: tooling, library picks, patterns, layout, testing. Load before writing, editing, or reviewing any Vue code (.vue SFCs, Pinia stores, composables). Not for React or other frameworks."
---

# Vue Conventions

## Tooling
- Vue 3 + TypeScript (always), oxfmt (format), oxlint + ESLint (lint), Vitest, vue-tsc

## Libraries (default picks)
- State → Pinia
- Routing → Vue Router
- Utilities → VueUse

## Patterns to enforce
- `<script setup>` + Composition API; typed props and emits
- Composables for shared/reusable logic
- Single-responsibility components

## Anti-patterns
- Options API; mutating props; `any`; business logic in templates

## Layout
```
src/
  main.ts  App.vue
  router/        # route table
  views/         # route-level components
  components/    # reusable components
  composables/   # useX() logic
  stores/        # Pinia stores (setup-store syntax)
  api/           # typed fetch wrappers; one module per backend resource
```

## Testing
- Vitest + @vue/test-utils; test behavior through rendered output and emitted events, not internals.
- Stub the network at `api/` boundary only.
- Coverage via `@vitest/coverage-v8`, thresholds 80; junit reporter to `reports/`.
