# Fill in GROUND_RULES.md TODOs

## Context

`shared/GROUND_RULES.md` is the universal rulebook every agent reads unconditionally (symlinked into each plugin root, dereferenced on install). It currently ships with five `<!-- TODO: fill in -->` placeholders left for the maintainer. Placeholders are dead noise and leave real policy undefined. This change replaces all five with concrete, terse rules, decided via interview. Editing `shared/GROUND_RULES.md` propagates to every plugin automatically through the symlinks — no per-plugin edits needed.

Design constraints: match the repo's terse ethos (README "Why", CLAUDE.md authoring standard), single source of truth (no duplication with `aspen.md` or `CONVENTIONS.md`), monorepo layout.

## Decisions (from interview)

- **Ambiguity** → split by what/how. *How* gaps: apply CONVENTIONS.md/default + flag, continue. *What* gaps: stop, raise to @aspen.
- **Scope** → monorepo; all language config lives inside the owned dir. Root holds only language-agnostic files (README, CLAUDE.md, Makefile, .gitignore); no agent edits root without explicit instruction.
- **Dependencies** → CONVENTIONS.md picks only. Need something else → raise to @user; approved additions get recorded in `specs/`. A lib named in a spec is pre-authorized even if absent from CONVENTIONS.md.
- **Done gate** (before hand-off) → formatter clean, linter clean, typecheck clean (where the language has one), tests pass, coverage ≥ 80%.
- **Spec format** → defer to aspen; do not restate required sections in GROUND_RULES.
- **Hand-off detail** → Summary lists files changed, specs referenced, decisions/assumptions; enough to act on without re-reading the work.

## Change — `shared/GROUND_RULES.md`

Single file. Replace each TODO block; add ambiguity + dependencies rules. Proposed section content:

**Source of truth** — append ambiguity handling:
> When a spec is silent or ambiguous:
> - *How* gap (library, pattern, file structure) → apply `CONVENTIONS.md` or a reasonable default, note the assumption in your Summary, continue.
> - *What* gap (behavior, API contract, data shape) → stop and raise to `@aspen` (or `@user`). Never invent behavior.
> `aspen` owns spec format and required sections — do not duplicate them here.

**Conventions precedence** — keep the 1/2/3 list; drop the TODO; add:
> A library named in a spec may be used even when absent from `CONVENTIONS.md` — the spec authorizes it.

**Dependencies** (new short section):
> Use only the libraries in `CONVENTIONS.md` (or ones a spec names). Need anything else → raise to `@user`; once approved the choice is recorded in `specs/`. Never silently add a dependency.

**Scope discipline** — replace TODO:
> This is a monorepo. Each agent owns exactly one directory: `aspen`→`specs/`, backend engineer (`gale`/`pat`)→`backend/`, frontend engineer (`vic`/`randy`)→`frontend/`. All language config lives inside the owned directory (`go.mod`, `package.json`, `tsconfig`, lockfiles). The repo root holds only shared, language-agnostic files (README, CLAUDE.md, Makefile, `.gitignore`) — no agent edits these without explicit instruction; raise a request instead.

**Production-grade bar** — replace TODO with the done gate:
> Before hand-off every change must pass the done gate (tooling per `CONVENTIONS.md`):
> - Formatter clean — no diff
> - Linter clean — no errors
> - Typecheck clean where the language has one (`go vet`, `tsc`/`vue-tsc`; Python has none per conventions)
> - Tests pass, coverage ≥ 80% (see Testing)

**Testing** — replace TODO:
> Every non-trivial change ships tests that exercise real behavior, not coverage padding. Line/branch coverage ≥ 80%, enforced before hand-off. Framework per `CONVENTIONS.md`.

**Hand-offs** — replace TODO:
> Summary must be specific and verifiable: files changed, specs referenced, decisions and assumptions made — enough for the next agent or the orchestrator to act without re-reading your work.

## Verification

- `ls -l shared/GROUND_RULES.md plugins/*/GROUND_RULES.md` — confirm the symlinks still resolve to the shared file (edit reaches every plugin).
- `grep -n "TODO" shared/GROUND_RULES.md` — expect no matches.
- `claude plugin validate .` and `claude plugin validate ./plugins/aspen` — no errors.
- Read-through: confirm no duplication of aspen's required-section list and that terse ethos holds.
