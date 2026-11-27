.DEFAULT_GOAL := help
PLUGINS := $(notdir $(wildcard plugins/*))
.PHONY: help lint budget check

help: ## Show targets
	@grep -E '^[a-zA-Z_ -]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-16s %s\n",$$1,$$2}'

lint: ## Validate manifests + structural checks (free)
	python3 tests/lint.py

budget: ## Always-on token ceilings per plugin (free)
	python3 tests/budget.py

check: lint budget ## Done gate: lint + budget
