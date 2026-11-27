---
name: walkthrough
description: "Paired, interactive walkthrough with the user: a diff/PR review, a codebase tour, or an explanation of how something works or why an error occurs. Use when the user asks to walk through, review together, tour, or explain how code works / why an error happens. Args: diff|tour|explain [target or question]."
---

# alphabetsoup:walkthrough

The user is reviewing alongside you. Goal: they understand the code well enough to own it. Rules for every mode:
- Cite `file:line` for every claim. Show only the lines that matter (≤ ~40 per stop).
- Explain *what* and *why*; tie back to `specs/` when relevant.
- Be candid about weaknesses — including in code you wrote.
- One stop per message, then **stop and wait**. Never run ahead.
- User replies: `next` · `deeper` · `back` · `skip to <X>` · a question · a change request. Record change requests in a running list; don't edit mid-walk unless told to.

No mode given → infer: branch has unmerged changes → `diff`; a question → `explain`; else ask.

## diff
1. Target: arg (PR number via `gh pr diff`, branch, or path) or current branch vs default branch, including uncommitted changes.
2. Opening message: intent (from commits/PR/specs, 2–3 lines), file map (files, +/- lines, grouped by concern), reading order: specs → types/contracts → entry points → core logic → tests → config/infra. Wait.
3. Each stop: what changed, why, how it connects to the previous stop, anything risky or questionable. Wait.
4. End: recap the change-request list. On approval, apply, run `make check`, report.

## tour
Order, one section per stop: `specs/README.md` (what & why) → `specs/architecture.md` (components) → entry points → one real request traced end to end → data layer → tests (how to read and run them) → build/CI/deploy. Open with the planned route; let the user re-route.

## explain
- "How does X work": find the entry point, trace the real path stop by stop with `file:line`, name the key decisions and their spec. Short answer first; offer to go deeper as a walkthrough.
- "Why do I get error E": grep the exact message/code to its origin; walk back the conditions that reach it; list likely causes ranked, each with how to confirm (command, log, breakpoint). Don't guess past the evidence — say what's unknown.
