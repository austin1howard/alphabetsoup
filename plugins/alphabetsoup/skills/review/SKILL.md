---
description: "Independent review of a change by fresh-context agents: correctness/conventions/specs (reviewer) and security (security-reviewer). Args: [security|general|both] [PR#|branch|path]."
disable-model-invocation: true
---

# alphabetsoup:review

1. Scope: first arg `security` | `general` | `both` (default `both`). Target: PR number, branch, or path; default current branch vs default branch incl. uncommitted changes.
2. Determine stacks touched (for the agents' `<lang>:conventions`).
3. Dispatch in parallel (single message): `alphabetsoup:reviewer` and/or `alphabetsoup:security-reviewer`. Pass only: target, how to get the diff (exact git/gh command), stacks touched. Don't pass your own opinions of the change — independence is the point.
4. Merge findings: dedupe, rank by severity then confidence. Present as a table: severity · `file:line` · finding · fix.
5. Ask which to fix. Apply, run `make check`, report.
