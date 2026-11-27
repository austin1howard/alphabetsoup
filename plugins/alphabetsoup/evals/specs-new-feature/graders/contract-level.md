---
type: llm
focus: {source: file, path: specs/features/password-reset.md}
weight: 2
---

PASS if ALL hold:
1. Has Purpose, Behavior, Contracts, and Acceptance criteria sections.
2. Behavior covers single-use links, expiry, and no account enumeration.
3. Contracts give endpoints with request/response shapes and error cases.
4. Acceptance criteria are observable and testable.
5. No implementation detail: no library or framework names, source file paths, or class/function names. (Endpoint paths, payload fields, entity fields, and status codes are contracts, not implementation — they are allowed.)
Open questions flagged for the user are fine. FAIL otherwise.
