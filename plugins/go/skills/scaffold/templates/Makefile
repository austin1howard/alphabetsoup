.DEFAULT_GOAL := help
IMAGE ?= {{name}}
COVERAGE_MIN ?= 80
# cmd/ is wiring only; coverage measured over internal/
COVER_PKGS ?= ./internal/...
.PHONY: help setup dev fmt lint typecheck test check build docker-build clean

help: ## Show targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-14s %s\n",$$1,$$2}'

setup: ## Download modules + tools
	go mod download

dev: ## Run locally
	go run ./cmd/{{name}}

fmt: ## Format + autofix
	gofmt -w .
	go tool golangci-lint run --fix

lint: ## Format check + lint (read-only)
	@test -z "$$(gofmt -l .)" || { gofmt -l .; echo "gofmt: files need formatting"; exit 1; }
	go tool golangci-lint run

typecheck: ## go vet
	go vet ./...

test: ## Tests (-race) + coverage (reports/)
	@mkdir -p reports
	go tool gotestsum --junitfile reports/junit.xml -- -race -coverpkg=$(COVER_PKGS) -coverprofile=reports/cover.out ./...
	go tool gocover-cobertura < reports/cover.out > reports/coverage.xml
	@go tool cover -func=reports/cover.out | awk -v min=$(COVERAGE_MIN) '/^total:/{gsub("%","",$$3); if ($$3+0 < min) {printf "coverage %s%% < %s%%\n",$$3,min; exit 1}}'

check: lint typecheck test ## Done gate

build: ## Build binary to bin/
	CGO_ENABLED=0 go build -trimpath -o bin/{{name}} ./cmd/{{name}}

docker-build: ## Build image
	docker build -t $(IMAGE) .

clean: ## Remove build/test artifacts
	rm -rf bin reports
