# CLAUDE.md — alphabetsoup maintainer guide

Claude Code plugin marketplace of opinionated skills: conventions, repo layout, testing bar, specs, Makefile-first commands, Docker/CI starting points, paired walkthroughs. No agent orchestration — skills guide a single session; agents exist only where an independent context is the point (review).

## Golden rules

- **Tokens are expensive.** Every file as concise as possible. No preamble, no filler, no restating context.
- No `version` fields in `marketplace.json` or any `plugin.json` — the commit SHA is the version.
- Language plugins are self-contained (no symlinks, no cross-plugin file reads). Cross-plugin references go through skill names (`python:conventions`).
- Changing plugins → keep README, `docs/` (see `docs/CLAUDE.md`), and the bootstrap detection table in sync.
- Test via `/plugin marketplace add ./`, not `--plugin-dir`.
- Skill changes → `make eval-quick ONLY=<plugin>`; a skill that doesn't fire means its `description` needs fixing.
- Commit after each green incremental change; never commit directly to master unless explicitly allowed.
- Plan implemented → move it to `.claude/archive/plans/` in its own commit.

## Layout

```
.claude-plugin/marketplace.json      catalog (pluginRoot: ./plugins)
plugins/alphabetsoup/                core plugin
  skills/bootstrap/                  set up / adopt a repo (+ templates/: CLAUDE.md, Makefile.root, compose, gitignore, specs)
  skills/standards/                  layout, make targets, CLAUDE.md format, always-do rules
  skills/testing/  skills/specs/     testing bar; specs/ structure + upkeep
  skills/ci/                         provider-agnostic CI (+ providers/<p>/ skeletons)
  skills/walkthrough/                diff | tour | explain
  skills/review/  agents/            independent reviewer + security-reviewer
plugins/<lang>/                      python go vue react swift
  skills/conventions/                the "how" for that language
  skills/scaffold/                   init + templates/ + ci.md (toolchain recipe per provider)
.claude/skills/new-plugin/           maintainer meta-skill (not published)
plugins/*/evals/                     claude plugin eval suites (results/ gitignored)
tests/                               lint.py, budget.py (stdlib python); templates/<lang>/ scaffold smoke tests
.github/workflows/                   ci.yml (lint, budget, templates per lang), evals.yml (manual; ANTHROPIC_API_KEY)
docs/                                public GitHub Pages site (master:/docs; see docs/CLAUDE.md)
```

## Commands

| Command | Does |
|---|---|
| `make check` | lint (validate, structure, site path leaks, eval suites load + cover triggering) + always-on token budget — done gate, free |
| `make test-templates` | scaffold each language in a temp dir and run its `make check` (network; `ONLY=<lang>`, `DOCKER_BUILD=1`) |
| `make eval-quick` | plugin evals: 1 run, with-plugin arm (cheap; `ONLY=<plugin>`) |
| `make eval` | plugin evals: 3 runs, with/without-plugin Δ, threshold 0.8 (paid; pinned `EVAL_MODEL`) |
| `/new-plugin` | add a language plugin |
| `open docs/index.html` | preview site |

`make check` green before every commit (version/license/icon validate warnings are expected).
