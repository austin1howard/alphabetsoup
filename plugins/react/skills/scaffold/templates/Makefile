.DEFAULT_GOAL := help
IMAGE ?= {{name}}
.PHONY: help setup dev fmt lint typecheck test check build docker-build clean

help: ## Show targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-14s %s\n",$$1,$$2}'

setup: ## Install deps from lockfile
	npm ci

dev: ## Vite dev server
	npm run dev

fmt: ## Format + autofix
	npx prettier --write .
	npx eslint . --fix

lint: ## Format check + lint (read-only)
	npx prettier --check .
	npx eslint .

typecheck: ## Type check
	npx tsc -b

test: ## Tests + coverage (reports/)
	npx vitest run --coverage --reporter=default --reporter=junit --outputFile.junit=reports/junit.xml

check: lint typecheck test ## Done gate

build: ## Production build to dist/
	npm run build

docker-build: ## Build image
	docker build -t $(IMAGE) .

clean: ## Remove build/test artifacts
	rm -rf dist reports coverage
