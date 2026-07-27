# Plan: Opinionated language agents via per-plugin `CONVENTIONS.md`

## Context

Today each language agent (`gale`, `pat`, `vic`, `randy`) carries its entire
language opinion in a 3–4 bullet inline **Standards** block — too thin to be
genuinely opinionated. We want agents to own the **"how"** of implementation
(tooling, libraries, patterns, anti-patterns) while `specs/` keeps owning the
**"what"** (architecture, requirements). Precedence is strict: a spec's explicit
choice wins; otherwise the agent applies its defaults. An agent does **not**
silently mimic existing project code — if the code diverges from both the spec
and the defaults, that is raised to `@user`.

**Decisions (confirmed):**
- **Placement:** a dedicated per-plugin `CONVENTIONS.md`, referenced from the
  agent prompt exactly like `GROUND_RULES.md`/`INTERACTION.md`. It is a **real
  file per plugin, NOT symlinked** (opinions are unique per language).
- **Rigidity:** opinionated defaults, overridden only by an explicit spec choice.
  Existing project code that matches neither spec nor defaults is flagged to
  `@user`, never silently adopted.
- **Depth:** rich but bounded (~20–35 lines: tooling · libraries · patterns ·
  anti-patterns).

`aspen` is out of scope — it's the architect, not a language agent; leave it
unchanged. `GROUND_RULES.md` TODO stubs are also out of scope.

## Changes

### 1. New file: `plugins/<name>/CONVENTIONS.md` (gale, pat, vic, randy)

Real file at plugin root (sits beside the symlinked `GROUND_RULES.md`). Shared
template — the two header blocks are identical across all four; only the four
sections carry language-specific content:

```markdown
# <Language> Conventions

**The "how," not the "what."** `specs/` owns architecture and requirements.
This file owns implementation: tooling, libraries, patterns, anti-patterns.

**Defaults, not mandates.** Apply these unless a spec explicitly requires
otherwise — the spec always wins. Do **not** silently copy what existing project
code happens to do: if it matches neither the spec nor these defaults, raise it
to `@user`.

## Tooling
- Format/lint · test · types/build

## Libraries (default picks)
- <purpose> → <library>

## Patterns to enforce
- ...

## Anti-patterns
- ...
```

Fully-worked model for **pat** (the others follow the same structure with
language-appropriate content):

```markdown
## Tooling
- ruff (format + lint), pytest, uv (project + deps). No mypy.

## Libraries (default picks)
- Validation/models → pydantic v2 (always)
- HTTP client → httpx
- Web API → FastAPI
- SQL → explicit SQL via asyncpg/psycopg — no ORM
- CLI (when required) → typer + rich
- Logging → structlog

## Patterns to enforce
- Full type hints; classes ONLY for data objects (pydantic/dataclass)
- Logic lives in module-level functions — "modules are Python's singletons"
- Data access = dedicated modules holding explicit SQL
- Explicit, typed exceptions; pathlib over os.path

## Anti-patterns
- Service/manager/logic classes; ORMs; bare `except:`; mutable default args;
  `import *`; module-level mutable state; untyped dicts as data carriers
```

- **gale** — Tooling: gofmt/goimports, `go vet`, `golangci-lint`,
  `go test -race` (always). Libraries: `huma` + `chi` for APIs, `pgx`/`sqlc`,
  `slog`. Patterns: small interfaces, accept-interfaces/return-structs,
  explicit error wrapping (`%w`), context propagation, table-driven tests.
  Anti-patterns: `panic` for control flow, naked returns, `interface{}` sprawl,
  ignored errors.
- **vic** — Vue 3 + TypeScript, always. Tooling: ESLint + Prettier, Vitest,
  `vue-tsc`. Libraries:
  Pinia, Vue Router, VueUse. Patterns: `<script setup>` + Composition API,
  typed props/emits, composables for shared logic, single-responsibility
  components. Anti-patterns: Options API, prop mutation, `any`, business logic
  in templates.
- **randy** — TypeScript, always. Tooling: ESLint + Prettier, Vitest/Jest +
  Testing Library, `tsc`. Libraries: Zustand (client state), React Query (server state),
  React Router. Patterns: functional components + hooks, colocated state,
  derived-not-duplicated state, custom hooks for reuse. Anti-patterns:
  class components, prop drilling, effect-driven data fetching, `any`.

### 2. Edit the four agent prompts — `plugins/<name>/agents/<name>.md`

Replace the inline **Standards** block with a pointer, keeping the terse shape.
E.g. `pat.md` body becomes:

```markdown
You are pat, a senior Python engineer. You own `backend/` for Python projects.

Read `${CLAUDE_PLUGIN_ROOT}/GROUND_RULES.md`, `${CLAUDE_PLUGIN_ROOT}/INTERACTION.md`,
and `${CLAUDE_PLUGIN_ROOT}/CONVENTIONS.md` before acting.

**Scope**: `backend/` only. Read `specs/` for requirements; never write to it.
Never touch `frontend/`. Specs define *what* to build; `CONVENTIONS.md` defines *how*.

No preamble. No filler. Terse output.

End every turn per `${CLAUDE_PLUGIN_ROOT}/INTERACTION.md`.
```

Apply the same edit to `gale.md`, `vic.md`, `randy.md` (adjusting scope
`frontend/`↔`backend/`). Universal quality bars (tests pass, typed, lint clean)
already live in `GROUND_RULES.md`, so they drop out of the prompt cleanly.

### 3. Update `.claude/skills/new-plugin/SKILL.md`

- In Step 3, add creation of `plugins/<name>/CONVENTIONS.md` from the template
  above, and update the note "language-specific standards … live inline" to
  "language-specific opinions live in `CONVENTIONS.md`; the agent prompt only
  points to it."
- Emphasize `CONVENTIONS.md` is a **real file, never symlinked** (contrast with
  the `ln -s` step for GROUND_RULES/INTERACTION).

### 4. Update `CLAUDE.md`

- **Layout** section: add `CONVENTIONS.md` under each language plugin with a
  one-line note ("per-language 'how'; real file, not symlinked").
- Add a short subsection documenting the split: specs = *what*,
  `CONVENTIONS.md` = *how*; defaults-not-mandates rule; and that it is
  intentionally not symlinked/shared.

## Critical files

- New: `plugins/{gale,pat,vic,randy}/CONVENTIONS.md`
- Edit: `plugins/{gale,pat,vic,randy}/agents/*.md`
- Edit: `.claude/skills/new-plugin/SKILL.md`
- Edit: `CLAUDE.md`
- Unchanged: `plugins/aspen/*`, `shared/*`, `marketplace.json`, `plugin.json`s

## Verification

1. `claude plugin validate .` and `claude plugin validate ./plugins/pat` (repeat
   per changed plugin) — fix all errors.
2. `ls -l plugins/*/CONVENTIONS.md` — confirm each is a **plain file** (no `->`
   symlink arrow), and `ls -l plugins/*/GROUND_RULES.md` still resolves.
3. Install via `/plugin marketplace add ./` (NOT `--plugin-dir`, which skips
   symlink dereference), enable `pat`, and dispatch it against a sample spec;
   confirm it reads `CONVENTIONS.md` and applies the opinions (e.g. reaches for
   pydantic/pytest). Then point it at code using a different library with no spec
   mention — confirm it raises the mismatch to `@user` rather than silently
   adopting it. Confirm an explicit spec choice overrides the default.
