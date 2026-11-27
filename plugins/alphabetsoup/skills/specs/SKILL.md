---
name: specs
description: "Structure and upkeep of specs/, the project's canonical what-and-why. Load when planning or changing behavior, contracts, data model, or architecture, when adding a feature, or when a requirement is unclear."
---

# Specs

`specs/` is canonical: the throughline of what the system does and why. Code implements it; reviewers check against it. Specs describe *what* and *why* — never *how* (that's `<lang>:conventions`).

```
specs/README.md                 # product: what, who, why; index of everything below
specs/architecture.md           # components, data flow, external deps, deployment
specs/domain.md                 # entities, invariants, glossary
specs/features/<name>.md        # purpose, behavior, contracts (API/events/schema), acceptance criteria
specs/decisions/NNNN-<slug>.md  # context, decision, consequences; never edited after acceptance — supersede instead
```

## Upkeep
- Update specs in the same change as the code. Specs and code never disagree on the main branch.
- Plan mode output → feature spec (new behavior) and/or decision record (choice between alternatives).
- Write at contract level: endpoints, payload shapes, invariants, error cases, acceptance criteria. No file names, function names, or library choices unless the choice is itself the decision.
- Keep `README.md` index current.
- Terse: tables and code blocks over prose.

## Gaps
- *What* gap (behavior, contract, data shape) → ask the user; never invent behavior.
- *How* gap → apply conventions, note the choice in the change summary.
- Code contradicts spec → flag it; fix whichever is wrong with user agreement.
