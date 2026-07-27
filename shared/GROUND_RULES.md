# Ground Rules

Rules every agent in this marketplace follows unconditionally.

## Source of truth

`specs/` is canonical. Before writing any code, read the relevant spec(s). Never deviate from a spec without flagging the conflict to `@aspen` or `@user`.

When a spec is silent or ambiguous:
- *How* gap (library, pattern, file structure) → apply `CONVENTIONS.md` or a reasonable default, note the assumption in your Summary, continue.
- *What* gap (behavior, API contract, data shape) → stop and raise to `@aspen` (or `@user`). Never invent behavior.

`aspen` owns spec format and required sections.

## Conventions precedence

`CONVENTIONS.md` defines implementation defaults (tooling, libraries, patterns). Precedence:
1. Explicit spec choice — always wins.
2. `CONVENTIONS.md` defaults — apply when the spec is silent.
3. Existing project code matching neither → raise to `@user`, never silently adopt.

A library named in a spec may be used even when absent from `CONVENTIONS.md` — the spec authorizes it.

## Dependencies

Use only the libraries in `CONVENTIONS.md` (or ones a spec names). Need anything else → raise to `@user`; once approved the choice is recorded in `specs/`. Never silently add a dependency.

## Scope discipline

This is a monorepo. Each agent owns exactly one directory: `aspen`→`specs/`, backend engineer→`backend/`, frontend engineer→`frontend/`. All language config lives inside the owned directory (`go.mod`, `package.json`, `tsconfig`, lockfiles). The repo root holds only shared, language-agnostic files (README, CLAUDE.md, Makefile, `.gitignore`) — no agent edits these without explicit instruction; raise a request instead.

## Production-grade bar

Ship code that is correct, tested, and maintainable. No placeholders, no TODOs left in committed code, no dead code.

Before hand-off every change must pass the done gate (tooling per `CONVENTIONS.md`):
- Formatter clean — no diff
- Linter clean — no errors
- Typecheck clean where the language has one (`go vet`, `tsc`/`vue-tsc`; Python has none per conventions)
- Tests pass, coverage ≥ 80%

## Testing

Every non-trivial change ships tests that exercise real behavior, not coverage padding. Line/branch coverage ≥ 80%, enforced before hand-off. Framework per `CONVENTIONS.md`.

## Hand-offs

End every turn with the structure defined in `INTERACTION.md`. Summary must be specific and verifiable: files changed, specs referenced, decisions and assumptions made — enough for the next agent or the orchestrator to act without re-reading your work.

## Be concise — tokens are expensive

No preamble. No restating the request. No filler. Terse summaries, short code comments, minimal prose. Every word must earn its place.

## Subagent dispatch rules

- Never use git worktrees (`isolation: worktree`).
- Never start dynamic/self-paced loops.
- Concurrent subagents are only valid when they work in **different directories** — never two agents in the same area at once.
- Serialize true dependencies (e.g. spec before implementation).
