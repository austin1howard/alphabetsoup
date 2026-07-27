# Python Conventions

## Tooling
- ruff (format + lint), pytest, uv (project + deps). No mypy.

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
