---
description: "Configure the alphabetsoup marketplace in your project: register the marketplace, detect your stack, enable the right plugins, and scaffold standard directories."
disable-model-invocation: true
---

# alphabetsoup:configuration

## 1 — Register the marketplace

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": [
    { "github": "austin1howard/alphabetsoup" }
  ]
}
```

Then install the core plugin:
```
/plugin install alphabetsoup@alphabetsoup
```

## 2 — Detect your stack and enable plugins

| Signal | Plugin |
|--------|--------|
| `go.mod` present | `gale@alphabetsoup` (Go backend) |
| `*.py` or `pyproject.toml` present | `pat@alphabetsoup` (Python backend) |
| `package.json` with `"vue"` dep | `vic@alphabetsoup` (Vue 3 frontend) |
| `package.json` with `"react"` dep | `randy@alphabetsoup` (React frontend) |
| `*.swift` or `Package.swift` present | `sol@alphabetsoup` (Swift native) |

Also enable `aspen@alphabetsoup` (architect) for any project that uses `specs/`.

Install detected plugins:
```
/plugin install aspen@alphabetsoup
/plugin install <detected>@alphabetsoup
```

Enable them in `.claude/settings.json`:
```json
{
  "enabledPlugins": ["aspen@alphabetsoup", "gale@alphabetsoup"]
}
```

## 3 — Declare active agents in CLAUDE.md

Add an `## alphabetsoup agents` section to the project's `CLAUDE.md`. List only the roles in use:

```markdown
## alphabetsoup agents

- Architect: `aspen`
- Backend: `<plugin-name>`   <!-- e.g. gale, pat -->
- Frontend: `<plugin-name>`  <!-- e.g. vic, randy -->
- Native: `<plugin-name>`    <!-- e.g. sol -->
```

Omit roles not applicable to this project (e.g. no `Frontend` line for a backend-only repo). The coordination skill reads this section to resolve which agent to dispatch for each role.

## 4 — Scaffold project directories

Create standard directories if missing:
```
specs/          # source of truth — aspen owns this
backend/        # backend engineer agent
frontend/       # frontend engineer agent
app/            # native engineer agent (Swift)
```

## 5 — Skill namespacing

Skills from this marketplace are invoked as `<plugin>:<skill>`. Examples:
- `/alphabetsoup:configuration` — this skill
- `/alphabetsoup:coordination` — orchestration loop
- Agents are invoked as subagents by plugin name: `aspen` (architect), or the name of the installed engineer plugin

