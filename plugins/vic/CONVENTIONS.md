# Vue Conventions

## Tooling
- Vue 3 + TypeScript (always), ESLint + Prettier, Vitest, vue-tsc

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
