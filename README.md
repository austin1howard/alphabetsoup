# alphabetsoup

A Claude Code plugin marketplace for spec-driven development. Each plugin ships an expert senior-engineer agent scoped to its directory, coordinated by a shared architect and a core orchestration plugin.

## Install

```bash
# 1. Register the marketplace (add to your project's .claude/settings.json)
{
  "extraKnownMarketplaces": [{ "github": "austin1howard/alphabetsoup" }]
}

# 2. Install the core plugin
/plugin install alphabetsoup@alphabetsoup

# 3. Run configuration — detects your stack and enables the right plugins
/alphabetsoup:configuration
```

## Plugins & agents

| Plugin | Agent | Specialty | Directory |
|--------|-------|-----------|-----------|
| `alphabetsoup` | — | Configuration + coordination skills | — |
| `aspen` | aspen | Architect — writes and owns `specs/` | `specs/` |
| `gale` | gale | Go backend | `backend/` |
| `pat` | pat | Python backend | `backend/` |
| `vic` | vic | Vue 3 frontend | `frontend/` |
| `randy` | randy | React frontend | `frontend/` |

Install any plugin:
```
/plugin install <name>@alphabetsoup
```

## Workflows

### Configuration
```
/alphabetsoup:configuration
```
Registers the marketplace, detects your stack, enables plugins, and scaffolds `specs/`, `backend/`, `frontend/`.

### Coordination
```
/alphabetsoup:coordination
```
Orchestrates agents toward a goal you describe. Routes work to the right agent(s), runs independent tasks concurrently, and relays hand-offs until the goal is met.

## How it works

`specs/` is the source of truth. `aspen` authors specs; engineer agents implement from them.

Agents end every turn with a structured Summary + optional Requests block (see `shared/INTERACTION.md`), which the coordination skill uses to route follow-up work.

## Add a new language plugin

Use the built-in meta-skill (available to maintainers of this repo):
```
/new-plugin
```
It prompts for a language, suggests gender-neutral names sharing its first letter, scaffolds the plugin, and validates it.
