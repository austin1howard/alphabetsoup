---
description: "Orchestrate the alphabetsoup agents toward a user-stated goal: route work to the right agents, run independent tasks concurrently, relay hand-offs, and iterate until the goal is met."
disable-model-invocation: true
---

# alphabetsoup:coordination

Read `${CLAUDE_PLUGIN_ROOT}/INTERACTION.md` and the project's `CLAUDE.md` before doing anything else. From `CLAUDE.md`, locate the `## alphabetsoup agents` section and note the agent name for each declared role (Backend, Frontend). These names are the subagent names you will dispatch.

## Step 1 — Require a goal

If the user did not state a goal with this invocation, call `AskUserQuestion` now:

```
What should the agents work on?
Options (or describe your own goal):
- "Implement everything in specs/"
- "Build the backend for spec X"
- "Wire the frontend to the new API in spec Y"
- "Write/update a spec for feature Z"
[Other — free text]
```

Do not proceed until a goal is stated.

## Step 2 — Route to agents (do minimal pre-work)

Do **not** read specs deeply or pre-decide implementation details. Hand agents **direction, not decisions** — each agent inspects `specs/` itself and makes its own choices.

| Goal type | Agent(s) |
|-----------|----------|
| Create or update specs | `aspen` |
| Backend work | the enabled backend engineer agent |
| Frontend work | the enabled frontend engineer agent |

## Step 3 — Dispatch rules

- **Concurrent**: agents working in **different directories** (e.g. backend agent in `backend/` + frontend agent in `frontend/`).
- **Serial**: true dependencies (e.g. `aspen` writes spec → then implementer reads it).
- **Never**: two agents in the same area at once; `isolation: worktree`; dynamic/self-paced loops.

Dispatch using the Agent tool. Subagent name = `aspen` for spec work; for engineer agents, use the name read from `CLAUDE.md`'s `## alphabetsoup agents` section. Pass the user's goal and relevant context. Do not over-specify — let the agent decide approach.

If `CLAUDE.md` has no `## alphabetsoup agents` section, stop and ask the user to run `/alphabetsoup:configuration` first.

## Step 4 — Collect and relay

Read each agent's `## Summary` and `## Requests` blocks from their output.
- Forward `@<agent>` requests as new subagent dispatches.
- Surface `@user` requests to the user.
- Iterate until the goal is complete or blocked on a user decision.

## Step 5 — End your turn

Follow the format in `${CLAUDE_PLUGIN_ROOT}/INTERACTION.md`: Summary always; Requests only if needed.
