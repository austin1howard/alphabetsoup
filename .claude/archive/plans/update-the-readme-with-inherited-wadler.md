# Plan: Add a "Why" section to README.md

## Context

`README.md` explains *what* alphabetsoup is and *how* to use it, but never *why* it exists. From interviewing the maintainer, the real motivations are:

1. **A single generalist agent loses the plot** on a whole repo as context grows — it drifts, forgets constraints, contradicts itself.
2. **Specs get ignored** — agents deviate from intended design; there needs to be a durable, canonical source of truth they must obey.
3. **Cost.** Existing multi-agent frameworks (BMAD, superpowers, gsd) are expensive because they port *human* team ceremony — role-play, persona chatter, negotiation rituals — onto agents. Agents don't need the social scaffolding humans do; those interactions burn tokens on theater.

The synthesis, and the section's thesis: **specs are a coordination protocol, not documentation.** Durable spec files replace expensive re-explanation between agents. That is simultaneously the correctness play (agents obey a canonical spec) and the token-efficiency play (no ceremony, no re-context).

Audience: public/community. Tone: measured maintainer rationale. Contrast with rival frameworks: **allude, don't name.**

## Change

Insert a new `## Why` section into `/Users/austin/Documents/git_repos/alphabetsoup/README.md`, placed **after the intro paragraph (line 3) and before `## Install`**. Rationale before mechanics.

Keep it tight — 4 short claims, measured voice, no named rivals. Draft:

```markdown
## Why

Most multi-agent coding frameworks model a team of humans: personas that chat,
negotiate, and hold standups. Agents don't need that. The rituals that keep human
teams aligned are, for agents, tokens spent on theater — expensive and beside the point.

alphabetsoup keeps only what agents actually need to coordinate:

- **Specs are the protocol, not documentation.** `specs/` is canonical and owned by
  one architect agent. Coordination happens through durable spec files instead of agents
  re-explaining intent to each other every turn. This is both the correctness mechanism
  (agents implement from a spec they must obey, and flag conflicts rather than drift) and
  the efficiency mechanism (no context is paid for twice).
- **Scoped context beats a generalist.** One agent responsible for a whole repo loses the
  plot as its context grows. Each agent here owns exactly one directory, carrying a smaller,
  sharper context — better output, fewer tokens, no cross-contamination.
- **Coordination is mechanical, not conversational.** Every turn ends with a structured
  Summary + Requests block that the orchestrator routes automatically. No chatter, no
  role-play — just hand-offs.
- **Parallel by construction.** Agents in different directories run concurrently; only true
  dependencies (spec before implementation) are serialized.
```

Wording is a starting point — tune for concision against the repo's "tokens are expensive" authoring standard during implementation.

## Files

- `/Users/austin/Documents/git_repos/alphabetsoup/README.md` — insert `## Why` between line 3 and `## Install`.

## Verification

- Re-read `README.md` top-to-bottom: intro → Why → Install flows logically, no duplicated claims with the existing "How it works" section (line 50). If overlap emerges, keep the mechanism detail in "How it works" and the *reasoning* in "Why."
- `claude plugin validate .` — confirm the marketplace still validates (README edits shouldn't affect it, but cheap to confirm).
- Markdown renders cleanly (headings, list nesting).
