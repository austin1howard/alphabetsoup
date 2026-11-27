.DEFAULT_GOAL := help
PLUGINS := $(notdir $(wildcard plugins/*))
LANGS := $(filter-out alphabetsoup swift,$(PLUGINS))
EVAL_FLAGS = --trust-plugin --scaffold --allow-tools Write Edit --no-publish --model $(EVAL_MODEL) -j $(EVAL_JOBS)
EVAL_THRESHOLD ?= 0.8
EVAL_MAX_COST ?= 10
EVAL_MODEL ?= claude-sonnet-5-5
EVAL_JOBS ?= 4
.PHONY: help lint budget check test-templates eval eval-quick clean

help: ## Show targets
	@grep -E '^[a-zA-Z_ -]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-16s %s\n",$$1,$$2}'

lint: ## Validate manifests, structure, eval suites load (free)
	python3 tests/lint.py

budget: ## Always-on token ceilings per plugin (free)
	python3 tests/budget.py

check: lint budget ## Done gate: lint + budget (free)

test-templates: ## Scaffold each language in a temp dir and run its make check (network; ONLY=<lang>, DOCKER_BUILD=1)
	@for l in $(or $(ONLY),$(LANGS)); do bash tests/templates/run.sh $$l || exit 1; done

eval: ## Plugin evals: with/without-plugin arms, 3 runs (paid; ONLY=<plugin>, EVAL_MAX_COST per plugin)
	@for p in $(or $(ONLY),$(PLUGINS)); do \
	  claude plugin eval ./plugins/$$p $(EVAL_FLAGS) --threshold $(EVAL_THRESHOLD) --max-cost-usd $(EVAL_MAX_COST) || exit 1; done

eval-quick: ## Plugin evals: with-plugin arm, 1 run (cheap iteration)
	@for p in $(or $(ONLY),$(PLUGINS)); do \
	  claude plugin eval ./plugins/$$p $(EVAL_FLAGS) --ablation none --runs 1 --threshold $(EVAL_THRESHOLD) --max-cost-usd $(EVAL_MAX_COST) || exit 1; done

clean: ## Remove eval results
	rm -rf plugins/*/evals/results
