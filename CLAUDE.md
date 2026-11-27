# CLAUDE.md — alphabetsoup maintainer guide

Claude Code plugin marketplace of opinionated skills: conventions, repo layout, testing bar, specs, Makefile-first commands, Docker/CI starting points, paired walkthroughs. No agent orchestration — skills guide a single session; agents exist only where an independent context is the point (review).

## Golden rules

- **Tokens are expensive.** Every file as concise as possible. No preamble, no filler, no restating context.
- No `version` fields in `marketplace.json` or any `plugin.json` — the commit SHA is the version.
- Language plugins are self-contained (no symlinks, no cross-plugin file reads). Cross-plugin references go through skill names (`python:conventions`).
- Changing plugins → keep README, `docs/` (see `docs/CLAUDE.md`), and the bootstrap detection table in sync.
- Test via `/plugin marketplace add ./`, not `--plugin-dir`.

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
docs/                                public GitHub Pages site (master:/docs; see docs/CLAUDE.md)
```

## Commands

| Command | Does |
|---|---|
| `claude plugin validate .` | validate marketplace |
| `claude plugin validate ./plugins/<name>` | validate one plugin |
| `/new-plugin` | add a language plugin |
| `open docs/index.html` | preview site |

Run both validate commands before committing; fix all errors (version/license/icon warnings are expected).
