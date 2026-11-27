.DEFAULT_GOAL := help
IMAGE ?= {{name}}
.PHONY: help setup dev fmt lint typecheck test check build docker-build clean

help: ## Show targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-14s %s\n",$$1,$$2}'

setup: ## Install deps from lockfile
	uv sync --locked

dev: ## Run dev server with reload
	uv run fastapi dev src/{{pkg}}/main.py

fmt: ## Format + autofix
	uv run ruff format .
	uv run ruff check --fix .

lint: ## Format check + lint (read-only)
	uv run ruff format --check .
	uv run ruff check .

typecheck: ## n/a for Python
	@echo "typecheck: n/a"

test: ## Tests + coverage (reports/)
	@mkdir -p reports
	uv run pytest

check: lint typecheck test ## Done gate

build: ## Build wheel
	uv build

docker-build: ## Build image
	docker build -t $(IMAGE) .

clean: ## Remove build/test artifacts
	rm -rf reports dist .pytest_cache .ruff_cache .coverage
