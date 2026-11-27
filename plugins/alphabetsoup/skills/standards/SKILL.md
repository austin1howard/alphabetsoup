---
name: standards
description: "House standards for repo layout, Makefile targets, CLAUDE.md format, commit cadence, and always-do rules. Load when starting work in a repo, creating or restructuring a repo or directory, adding a command/script/tool, editing CLAUDE.md or a Makefile, adding a dependency, or committing."
---

# Standards

## Layout
- **Single-stack** → project lives at repo root.
- **Multi-stack** → one dir per domain: `backend/`, `frontend/`, `app/` (native). Each is self-contained: own lockfile, tool config, Makefile, Dockerfile.
- Root holds only shared files: `CLAUDE.md`, `README.md`, `Makefile`, `.gitignore`, `compose.yaml`, `specs/`, CI config.
- Plans: active in `.claude/plans/`, implemented ones in `.claude/archive/plans/` (deny-read, so stale plans never re-enter context).
- In-domain layout: `<lang>:conventions`.

## Makefile-first
Every command run more than once is a make target. Run `make <target>`, not the raw tool. Repeating a raw command → add a target first, then list it in CLAUDE.md `## Commands`.

Standard targets (same names in every Makefile; `## ` comment on each feeds `help`):

| Target | Does |
|---|---|
| `help` | default goal; lists targets |
| `setup` | install deps from lockfile |
| `dev` | run locally with reload |
| `fmt` | format + autofix (writes) |
| `lint` | format check + linter (read-only) |
| `typecheck` | type checker; `@echo "typecheck: n/a"` where none |
| `test` | tests + coverage gate; JUnit + cobertura into `reports/` |
| `check` | `lint typecheck test` — the done gate |
| `build` | build artifact |
| `docker-build` | build image (`IMAGE ?= <name>`) |
| `up` / `down` | compose stack (root only) |
| `clean` | remove artifacts |

Multi-stack root Makefile delegates: `$(MAKE) -C <domain> <target>` for each domain. Domain-specific extras (e.g. `migrate`, `sqlc`) live in the domain Makefile.

## CLAUDE.md format
Fixed section order; template at `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/CLAUDE.md`.
1. `# <project>` + 1–3 sentence summary
2. `## Golden rules` — standing rules (from template) + project-specific ones
3. `## Layout` — tree, one line per dir
4. `## Commands` — table of make targets

Terse. No prose beyond these sections. Domain `CLAUDE.md` only for rules that don't belong at root.

## Always do
- Non-trivial work starts in plan mode; resolve open requirements there (AskUserQuestion), record decisions in `specs/`.
- Same change that alters layout, commands, or rules → update CLAUDE.md.
- Same change that alters behavior or contracts → update `specs/` (`alphabetsoup:specs`).
- `make check` green before calling anything done.
- Commit early and often, like a human: after each incremental change that leaves `make check` green, commit it — one logical change per commit, imperative subject line. Never batch unrelated work into one commit; never commit red.
- Never commit directly to `main`/`master` unless the user explicitly allows it for this repo or task. On the default branch → create a feature branch first.
- Plan implemented → `git mv` it from `.claude/plans/` to `.claude/archive/plans/` in its own commit.
- New dependency → ask first.
- Existing code conflicts with conventions → ask; never silently adopt or silently rewrite.
- Precedence: explicit spec choice > `<lang>:conventions` > ask.
