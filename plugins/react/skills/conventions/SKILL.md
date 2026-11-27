---
name: conventions
description: "React coding conventions: tooling, library picks, patterns, layout, testing. Load before writing, editing, or reviewing any React or frontend TypeScript code in a React project."
---

# React Conventions

## Tooling
- TypeScript (always), ESLint + Prettier, Vitest + Testing Library, tsc

## Libraries (default picks)
- Client state → Zustand
- Server state → React Query
- Routing → React Router

## Patterns to enforce
- Functional components + hooks; colocated state
- Derived state — never duplicate what can be computed
- Custom hooks for reusable logic

## Anti-patterns
- Class components; prop drilling; `any`; effect-driven data fetching

## Layout
```
src/
  main.tsx  App.tsx
  routes/        # route-level components
  components/    # reusable components
  hooks/         # useX() logic
  stores/        # Zustand stores
  api/           # typed fetchers + React Query hooks per backend resource
```

## Testing
- Vitest + @testing-library/react; query by role/label, assert on what the user sees.
- Mock the network at `api/` boundary only (MSW when needed).
- Coverage via `@vitest/coverage-v8`, thresholds 80; junit reporter to `reports/`.
