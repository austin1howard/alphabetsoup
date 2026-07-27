# alphabetsoup

A Claude Code plugin marketplace for spec-driven development. Each plugin ships an expert senior-engineer agent scoped to its directory, coordinated by a shared architect and a core orchestration plugin.

**Site:** https://austin1howard.github.io/alphabetsoup/

## Why

Most multi-agent coding frameworks model a team of humans: personas that chat, negotiate, and hold standups. Agents don't need that. The rituals that keep human teams aligned are, for agents, tokens spent on theater — expensive and beside the point.

alphabetsoup keeps only what agents actually need to coordinate:

- **Specs are the protocol, not documentation.** `specs/` is canonical and owned by one architect agent. Coordination happens through durable spec files instead of agents re-explaining intent to each other every turn. This is both the correctness mechanism — agents implement from a spec they must obey, and flag conflicts rather than drift — and the efficiency mechanism: no context is paid for twice.
- **Scoped context beats a generalist.** One agent responsible for a whole repo loses the plot as its context grows. Each agent here owns exactly one directory, carrying a smaller, sharper context — better output, fewer tokens, no cross-contamination.
- **Coordination is mechanical, not conversational.** Every turn ends with a structured Summary + Requests block that the orchestrator routes automatically. No chatter, no role-play — just hand-offs.
- **Parallel by construction.** Agents in different directories run concurrently; only true dependencies (spec before implementation) are serialized.

## Install

1. Register the marketplace by adding it to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": [{ "github": "austin1howard/alphabetsoup" }]
}
```

2. Install the core plugin, then run configuration:

```bash
/plugin install alphabetsoup@alphabetsoup
/alphabetsoup:configuration
```

Step 1 is a one-time manual bootstrap; from then on `/alphabetsoup:configuration` keeps the marketplace registered, detects your stack, and enables the right plugins.

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
Detects your stack, enables plugins, and scaffolds `specs/`, `backend/`, `frontend/` (and keeps the marketplace registered).

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
