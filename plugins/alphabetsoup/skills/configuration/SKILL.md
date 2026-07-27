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

## 3 — Scaffold project directories

Create standard directories if missing:
```
specs/          # source of truth — aspen owns this
backend/        # gale (Go) or pat (Python)
frontend/       # vic (Vue 3) or randy (React)
```

## 4 — Skill namespacing

Skills from this marketplace are invoked as `<plugin>:<skill>`. Examples:
- `/alphabetsoup:configuration` — this skill
- `/alphabetsoup:coordination` — orchestration loop
- Agents are invoked as subagents by name: `aspen`, `gale`, `pat`, `vic`, `randy`

