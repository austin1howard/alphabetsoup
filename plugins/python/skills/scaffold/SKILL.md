---
name: scaffold
description: "Scaffold Python in a repo (root if single-stack, else backend/): uv init, tool config, Makefile, Dockerfile. Used by alphabetsoup:bootstrap or when adding Python to an existing repo."
---

# Python scaffold

`<dir>` = repo root (single-stack) or `backend/`. `<name>` = project/image name, `<pkg>` = import name (snake_case). Templates in `${CLAUDE_SKILL_DIR}/templates/`; replace `{{name}}`/`{{pkg}}`.

1. `cd <dir> && uv init --app --package --name <name> .`
2. Dev deps: `uv add --dev ruff pytest pytest-cov pytest-asyncio`.
   Runtime deps by kind (ask if unknown): service → `fastapi[standard] pydantic structlog` (+ `asyncpg` with Postgres); CLI → `typer rich pydantic structlog`.
3. Append `pyproject.toml` template sections to `<dir>/pyproject.toml`.
4. Copy `Makefile`; for services also `Dockerfile` + `.dockerignore`. CLI: drop `dev`/`docker-build` bodies to `@echo n/a`.
5. Service: `src/<pkg>/main.py` exposes `app` with `GET /healthz`; `tests/test_main.py` covers it via ASGITransport — so `make check` is green from day one.
6. Append to root `.gitignore`: `.venv/ __pycache__/ *.pyc .pytest_cache/ .ruff_cache/ .coverage dist/ reports/` (unanchored, so they cover `backend/` too).
7. Run `make fmt && make check` (normalizes generated files).

CI toolchain recipe: `${CLAUDE_SKILL_DIR}/ci.md`.
