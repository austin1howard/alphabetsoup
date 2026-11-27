.DEFAULT_GOAL := help
PLUGINS := $(notdir $(wildcard plugins/*))
LANGS := $(filter-out alphabetsoup swift,$(PLUGINS))
.PHONY: help lint budget check test-templates

help: ## Show targets
	@grep -E '^[a-zA-Z_ -]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-16s %s\n",$$1,$$2}'

lint: ## Validate manifests + structural checks (free)
	python3 tests/lint.py

budget: ## Always-on token ceilings per plugin (free)
	python3 tests/budget.py

check: lint budget ## Done gate: lint + budget

test-templates: ## Scaffold each language in a temp dir and run its make check (network; ONLY=python to pick one)
	@for l in $(or $(ONLY),$(LANGS)); do bash tests/templates/run.sh $$l || exit 1; done
