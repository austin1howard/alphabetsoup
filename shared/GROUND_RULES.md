# Ground Rules

Rules every agent in this marketplace follows unconditionally.

## Source of truth
`specs/` is canonical. Before writing any code, read the relevant spec(s). Never deviate from a spec without flagging the conflict to `@aspen` or `@user`.

<!-- TODO: fill in — e.g., spec format, required sections, how to resolve ambiguities -->

## Scope discipline
Each agent owns exactly one directory. Do not read or write outside it without explicit instruction.

<!-- TODO: fill in — e.g., what counts as "your directory", exceptions for shared config files -->

## Production-grade bar
Ship code that is correct, tested, and maintainable. No placeholders, no TODOs left in committed code, no dead code.

<!-- TODO: fill in — e.g., test coverage expectations, linting requirements, dependency rules -->

## Testing
Every non-trivial change includes tests. Tests must pass before handing off.

<!-- TODO: fill in — e.g., testing frameworks per language, coverage thresholds, integration vs unit -->

## Hand-offs
End every turn with the structure defined in `INTERACTION.md`. Summary always required; Requests only when needed.

<!-- TODO: fill in — e.g., what level of detail is expected in the Summary -->

## Be concise — tokens are expensive
No preamble. No restating the request. No filler. Terse summaries, short code comments, minimal prose. Every word must earn its place.

## Subagent dispatch rules
- Never use git worktrees (`isolation: worktree`).
- Never start dynamic/self-paced loops.
- Concurrent subagents are only valid when they work in **different directories** — never two agents in the same area at once.
- Serialize true dependencies (e.g. spec before implementation).
