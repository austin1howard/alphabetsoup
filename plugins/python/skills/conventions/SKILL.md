---
name: conventions
description: "Python coding conventions: tooling, library picks, patterns, layout, testing. Load before writing, editing, or reviewing any Python code."
---

# Python Conventions

## Tooling
- uv (project + deps), ruff (format + lint), pytest + pytest-cov. No mypy.

## Libraries (default picks)
- Validation/models → pydantic v2 (always)
- HTTP client → httpx
- Web API → FastAPI
- SQL → explicit SQL via asyncpg/psycopg — no ORM
- CLI (when required) → typer + rich
- Logging → structlog

## Patterns to enforce
- Full type hints; classes ONLY for data objects (pydantic/dataclass)
- Logic lives in module-level functions — modules are Python's singletons
- Data access = dedicated modules holding explicit SQL
- Explicit, typed exceptions; pathlib over os.path

## Anti-patterns
- Service/manager/logic classes; ORMs; bare `except:`; mutable default args;
  `import *`; module-level mutable state; untyped dicts as data carriers

## Layout
```
src/<pkg>/
  main.py        # entry point (FastAPI app / typer app)
  api/           # routers: thin — parse, call logic, return
  db/            # one module per aggregate, explicit SQL
  models.py      # pydantic models (split into models/ when large)
  <feature>.py   # logic as module-level functions
tests/           # mirrors src/<pkg>/; conftest.py holds fixtures
```

## Testing
- pytest; `asyncio_mode = "auto"` (pytest-asyncio) for async code.
- API tests via `httpx.AsyncClient(transport=ASGITransport(app))` — no live server.
- DB tests hit real Postgres (`DATABASE_URL`, compose locally, service in CI); each test runs in a rolled-back transaction.
- Coverage: `--cov=src/<pkg> --cov-fail-under=80`; reports to `reports/` (`--junitxml`, `--cov-report=xml`).
