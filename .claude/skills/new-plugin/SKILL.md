---
description: "Create a new language or framework plugin in this marketplace. Invoke when asked to add or create a new language plugin."
---

# new-plugin

Plugin name = lowercase language/framework name (`rust`, `svelte`). Check `ls plugins/` for collisions. Model every file on an existing plugin (`plugins/python/` is the reference).

## 1 — Ask
If not stated: language/framework, domain dir (`backend/`, `frontend/`, `app/`), and the opinionated picks (tooling, libraries, patterns, anti-patterns). Propose defaults; let the user override.

## 2 — Create
```
plugins/<name>/.claude-plugin/plugin.json      # name, description, author; no version
plugins/<name>/skills/conventions/SKILL.md     # Tooling, Libraries, Patterns, Anti-patterns, Layout, Testing
plugins/<name>/skills/scaffold/SKILL.md        # init command, deps, which templates, gitignore lines, make check
plugins/<name>/skills/scaffold/ci.md           # one column per provider in plugins/alphabetsoup/skills/ci/providers/
plugins/<name>/skills/scaffold/templates/      # Makefile (all standard targets), Dockerfile (+ .dockerignore) if deployable, tool config
```
- `conventions` description must say "Load before writing, editing, or reviewing any <Language> code."
- Makefile must implement every target in `alphabetsoup:standards`; `test` writes `reports/junit.xml` + cobertura coverage and fails under 80%.

## 3 — Register
- Append to `.claude-plugin/marketplace.json` `plugins[]`: `{ "name": "<name>", "source": "./plugins/<name>", "description": "<Language> conventions and scaffold." }`
- Add a detection row to `plugins/alphabetsoup/skills/bootstrap/SKILL.md` step 2.
- Add a row to README's language table.

## 4 — Site
Follow `docs/CLAUDE.md` → "Adding a language".

## 5 — Validate
```bash
claude plugin validate .
claude plugin validate ./plugins/<name>
```
Fix all errors.
