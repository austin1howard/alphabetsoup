---
type: llm
weight: 2
---

PASS if errors are wrapped with %w and never discarded, context is propagated through all I/O, the DB layer uses pgx (or sqlc-generated code), interfaces (if any) are small and defined at the consumer, and the handler uses chi and/or huma. FAIL otherwise.
