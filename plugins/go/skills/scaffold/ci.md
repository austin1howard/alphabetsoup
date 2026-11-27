# Go CI recipe

| | github | gitlab |
|---|---|---|
| Toolchain | `actions/setup-go` with `go-version-file: go.mod` (caches modules + build) | image `golang:<go.mod version>` |
| Cache | handled by setup-go | `GOPATH: $CI_PROJECT_DIR/.go`, `GOCACHE: $CI_PROJECT_DIR/.go-build`, key `go.sum` |
| Typecheck | `make typecheck` (`go vet`) | same |
| Reports | `reports/junit.xml`, `reports/coverage.xml` (cobertura) | same |
