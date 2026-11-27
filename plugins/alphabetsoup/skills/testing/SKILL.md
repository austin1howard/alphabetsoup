---
name: testing
description: "Load before fixing any bug or writing, changing, or reviewing tests. Sets the testing bar: regression test that fails before the fix, real dependencies over mocks, 80% coverage gate."
---

# Testing

- Every non-trivial change ships tests. Tests exercise real behavior through public interfaces — no coverage padding, no testing private helpers directly.
- Coverage ≥ 80% (lines and branches where supported), enforced by `make test`.
- Prefer real dependencies: real Postgres (compose locally, service in CI), in-process HTTP test clients. Mock only at external boundaries (third-party APIs, clock, randomness) — never mock code you own.
- Bug fix → regression test that fails before the fix.
- Name tests for behavior: `test_rejects_expired_token`, not `test_validate_2`.
- One behavior per test; arrange/act/assert visible without scrolling. Shared setup in fixtures, not inheritance.
- Deterministic: no sleeps, no order dependence, no network outside the test's own services.
- Framework, fixtures, layout: `<lang>:conventions`.
