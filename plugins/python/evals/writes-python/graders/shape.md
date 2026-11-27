---
type: llm
weight: 2
---

PASS if the code uses module-level functions (no service/manager classes), full type hints, pydantic models for data, explicit parameterized SQL (asyncpg or psycopg, no ORM), and a typed exception or HTTPException for the missing case. FAIL otherwise.
