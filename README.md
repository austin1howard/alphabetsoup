# alphabetsoup

A Claude Code plugin marketplace of opinionated skills. They guide Claude to build and work the way I do — same conventions, same repo shape, same commands — so every repo looks and feels familiar when I review it.

**Site:** https://austin1howard.github.io/alphabetsoup/

## Why

v1 was a team of agents: an architect, one engineer per language, hand-offs between them. Current models don't need that. A single session (Opus on low/medium effort, Sonnet for simple fixes) handles the whole task, and multi-agent churn costs more tokens than it saves.

What still earns its place is the *opinion*:

- **Conventions** per language — library picks, patterns, anti-patterns, layout, testing.
- **Consistent structure** — repo layout, a fixed CLAUDE.md shape, Makefile-first commands, small green commits.
- **Specs as the throughline** — `specs/` holds what the system does and why, kept current with the code.
- **Starting points** — Dockerfiles, compose, CI (GitHub or GitLab, swappable), image release on tag.
- **Paired review** — walk a diff or a codebase together, or trace how something works.
- **Independent review** — the one place a fresh-context agent is worth it.

## Install

1. Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "alphabetsoup": { "source": { "source": "github", "repo": "austin1howard/alphabetsoup" } }
  }
}
```

2. Install the core plugin and bootstrap:

```
/plugin install alphabetsoup@alphabetsoup
/alphabetsoup:bootstrap
```

Bootstrap detects (or asks for) your stack, enables the language plugins, and scaffolds or adopts the repo. On an existing repo it reports gaps and changes only what you approve.

## Plugins

| Plugin | Provides |
|---|---|
| `alphabetsoup` | Core skills + reviewer agents |
| `python` | uv · ruff · pytest · FastAPI · pydantic · explicit SQL (no ORM) |
| `go` | huma + chi · pgx + sqlc · slog · golangci-lint · `-race` always |
| `vue` | Vue 3 + TS · `<script setup>` · Pinia · Vitest · oxfmt |
| `react` | TS · Zustand · React Query · React Router · Vitest + Testing Library |
| `swift` | SwiftUI · Swift 6 strict concurrency · GRDB · Swift Testing |

Each language plugin has two skills: `<lang>:conventions` (loaded whenever Claude writes that language) and `<lang>:scaffold` (init, Makefile, Dockerfile, CI recipe).

## Core skills

| Skill | Use |
|---|---|
| `/alphabetsoup:bootstrap` | Set up a new repo or adopt an existing one |
| `alphabetsoup:standards` | Layout, make targets, CLAUDE.md format, always-do rules (auto) |
| `alphabetsoup:testing` | Testing bar: real deps, ≥ 80% coverage, regression tests (auto) |
| `alphabetsoup:specs` | `specs/` structure and upkeep (auto) |
| `/alphabetsoup:ci [github\|gitlab]` | Generate or swap CI: lint → typecheck → test → build → release, one job per stage per domain |
| `/alphabetsoup:walkthrough [diff\|tour\|explain]` | Paired review of a diff, codebase tour, or "how does X work / why this error" |
| `/alphabetsoup:review [security\|general\|both]` | Independent fresh-context review by `reviewer` and `security-reviewer` agents |

## What a bootstrapped repo looks like

```
CLAUDE.md        summary · golden rules · layout · commands
Makefile         setup dev fmt lint typecheck test check build docker-build up down
specs/           README · architecture · domain · features/ · decisions/
backend/         (or the project at root if single-stack)
frontend/
compose.yaml
.github/workflows/ or .gitlab-ci.yml
```

## Testing

| Tier | Command | Cost |
|---|---|---|
| Static | `make check` — manifests, structure, eval suites load and cover triggering, always-on token budget | free |
| Templates | `make test-templates` — scaffold each language for real and run its `make check` | free, network |
| Evals | `make eval` — [`claude plugin eval`](https://code.claude.com/docs/en/plugin-evals.md): each skill fires when it should, stays quiet when it shouldn't, and changes the output (with vs. without plugin) | paid |

CI runs the first two on every push; evals run on manual dispatch.

## Add a language

Maintainers: run `/new-plugin` in this repo.
