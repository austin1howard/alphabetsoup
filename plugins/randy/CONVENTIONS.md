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
