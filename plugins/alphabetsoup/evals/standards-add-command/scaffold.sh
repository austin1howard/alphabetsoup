set -e
cat > CLAUDE.md <<'EOF'
# demo

Python API for demo.

## Golden rules

- Use `make` targets, never raw tool commands.

## Layout

```
src/demo/   API package
alembic/    migrations
```

## Commands

| Command | Does |
|---|---|
| `make setup` | install deps |
| `make check` | lint + typecheck + test |
EOF
cat > Makefile <<'EOF'
.DEFAULT_GOAL := help
.PHONY: help setup lint typecheck test check

help: ## Show targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-14s %s\n",$$1,$$2}'

setup: ## Install deps from lockfile
	uv sync --locked

lint: ## Format check + lint
	uv run ruff format --check .
	uv run ruff check .

typecheck: ## n/a for Python
	@echo "typecheck: n/a"

test: ## Tests + coverage
	uv run pytest

check: lint typecheck test ## Done gate
EOF
cat > pyproject.toml <<'EOF'
[project]
name = "demo"
version = "0.1.0"
dependencies = ["fastapi", "asyncpg", "alembic"]
EOF
mkdir -p src/demo alembic/versions && touch src/demo/__init__.py && printf '[alembic]\nscript_location = alembic\n' > alembic.ini
