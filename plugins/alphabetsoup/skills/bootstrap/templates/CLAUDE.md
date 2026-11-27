# {{project}}

{{1–3 sentence summary: what it is, who uses it.}}

## Golden rules

- `specs/` is canonical (what + why). New feature or behavior/contract change → write or update its spec in `specs/` first (`alphabetsoup:specs`), in the same change as the code.
- Before writing code, load the conventions skill for that language: {{e.g. `python:conventions` (backend/), `vue:conventions` (frontend/)}}.
- Use `make` targets, never raw tool commands. Repeating a command → add a target, list it below.
- Non-trivial work starts in plan mode; resolve requirements there.
- `make check` green before done. New dependency → ask first.
- Commit after each incremental change with `make check` green — one logical change per commit, never red.
- Never commit directly to main/master unless explicitly allowed — branch first.
- Plan implemented → move it to `.claude/archive/plans/` in its own commit.
- Keep this file current when layout, commands, or rules change.
{{project-specific rules}}

## Layout

```
{{tree, one line per dir, e.g.
specs/      canonical specs
backend/    Python API (FastAPI)
frontend/   Vue 3 SPA}}
```

## Commands

| Command | Does |
|---|---|
| `make setup` | install deps |
| `make dev` | run locally |
| `make up` / `make down` | start/stop compose stack |
| `make fmt` | format + autofix |
| `make check` | lint + typecheck + test (done gate) |
| `make build` | build artifacts |
{{domain-specific targets}}

CI: {{github|gitlab}} — runs lint, typecheck, test, build per domain; release on `v*` tag.
