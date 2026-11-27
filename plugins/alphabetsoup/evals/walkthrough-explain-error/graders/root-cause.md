---
type: llm
weight: 2
---

PASS if the answer identifies the unit mismatch: token age is computed in milliseconds but compared against TOKEN_TTL_SECONDS (seconds), so tokens expire after ~3.6 seconds; points to the comparison in verify(); and says how to confirm or fix it (e.g. compare against TTL * 1000 or compute age in seconds). FAIL otherwise.
