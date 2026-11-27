.DEFAULT_GOAL := help
SCHEME ?= {{App}}
DEST ?= platform=iOS Simulator,name=iPhone 17
SRC := {{App}} Packages
.PHONY: help setup fmt lint typecheck test check build clean

help: ## Show targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-14s %s\n",$$1,$$2}'

setup: ## Resolve packages
	xcodebuild -resolvePackageDependencies -scheme $(SCHEME)

fmt: ## Format + autofix
	swift format --in-place --recursive $(SRC)
	swiftlint --fix

lint: ## Format check + lint (read-only)
	swift format lint --strict --recursive $(SRC)
	swiftlint --strict

typecheck: ## n/a (compiler)
	@echo "typecheck: n/a"

test: ## Tests + coverage (reports/)
	@rm -rf reports && mkdir -p reports
	xcodebuild test -quiet -scheme $(SCHEME) -destination '$(DEST)' -enableCodeCoverage YES -resultBundlePath reports/Test.xcresult
	xcresultparser -o junit reports/Test.xcresult > reports/junit.xml
	xcresultparser -o cobertura reports/Test.xcresult > reports/coverage.xml

check: lint typecheck test ## Done gate

build: ## Build app
	xcodebuild build -scheme $(SCHEME) -destination '$(DEST)'

clean: ## Remove build/test artifacts
	rm -rf reports .build
