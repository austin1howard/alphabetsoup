---
description: "Bootstrap or adopt a repo with alphabetsoup: register the marketplace, enable plugins, scaffold each stack, write CLAUDE.md, Makefile, specs/, compose, and CI. Works on new and existing repos."
disable-model-invocation: true
---

# alphabetsoup:bootstrap

Load `alphabetsoup:standards` first. Templates: `${CLAUDE_SKILL_DIR}/templates/`.

## 1 — Settings
Merge into `.claude/settings.json` (create if missing; never drop existing keys):
```json
{
  "extraKnownMarketplaces": {
    "alphabetsoup": { "source": { "source": "github", "repo": "austin1howard/alphabetsoup" } }
  },
  "enabledPlugins": { "alphabetsoup@alphabetsoup": true, "<lang>@alphabetsoup": true }
}
```
One `<lang>@alphabetsoup` per stack from step 2. If a `<lang>:scaffold` skill isn't available this session, print `/plugin install <lang>@alphabetsoup` and ask the user to run it (then `/reload-plugins`) before continuing.

## 2 — Detect
| Signal | Stack |
|---|---|
| `pyproject.toml` / `*.py` | python |
| `go.mod` | go |
| `package.json` with `vue` | vue |
| `package.json` with `react` | react |
| `*.xcodeproj` / `Package.swift` | swift |

New repo (no code) → AskUserQuestion: project name, stacks, Postgres yes/no, CI provider (default from `git remote`).
Existing repo → go to step 6.

## 3 — Layout
One stack → root. More → `backend/`, `frontend/`, `app/` per `standards`.

## 4 — Scaffold
Per stack, invoke `<lang>:scaffold` with its target dir.

## 5 — Root files
- `.gitignore` ← `templates/gitignore` (+ each scaffold's lines)
- `specs/` ← `templates/specs/{README,architecture,domain}.md`; create `features/` and `decisions/`. Fill what's known from the user's answers; leave the rest as placeholders.
- `compose.yaml` ← template, only services that exist; skip if single service and no DB.
- `Makefile`: multi-stack → `templates/Makefile.root` (`DOMAINS` set); single-stack → language Makefile at root, plus `up`/`down` if compose exists.
- `CLAUDE.md` ← template, filled: summary, conventions line naming the real `<lang>:conventions`, real layout tree, real targets.
- Invoke `alphabetsoup:ci`.

## 6 — Existing repo (adopt)
Never overwrite. Compare against `standards` (layout, Makefile targets, CLAUDE.md sections, specs/, CI stages, Dockerfile, .gitignore) and present a gap list: item, current, proposed. Apply only what the user approves. Conflicting existing patterns → ask per item.

## 7 — Verify
Run `make check` (and `docker compose config` if compose exists). Commit in logical steps as you go (e.g. scaffold per stack, root files, CI) — each commit green. Report results.
