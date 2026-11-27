---
name: conventions
description: "Go coding conventions: tooling, library picks, patterns, layout, testing. Load before writing, editing, or reviewing any Go code."
---

# Go Conventions

## Tooling
- gofmt/goimports, `go vet`, golangci-lint, `go test -race` (always), gotestsum (reports)

## Libraries (default picks)
- HTTP API → huma + chi
- SQL → pgx + sqlc
- Logging → slog (stdlib)

## Patterns to enforce
- Small, focused interfaces; accept interfaces, return structs
- Explicit error wrapping with `%w`; never discard errors
- Context propagation through all I/O calls
- Table-driven tests

## Anti-patterns
- `panic` for control flow; naked returns; `interface{}`/`any` sprawl;
  ignoring errors; global mutable state

## Layout
```
cmd/<name>/main.go     # wiring only: config, deps, start server
internal/
  api/                 # huma operations + chi router
  db/queries/*.sql     # sqlc input
  db/                  # sqlc output (generated; never hand-edit)
  <domain>/            # logic packages, named by what they provide
migrations/            # SQL migrations
```
No `pkg/` unless code is genuinely imported by other modules. No `utils`/`common` packages.

## Testing
- Table-driven, `t.Run` subtests, `t.Parallel()` where safe.
- Interfaces at consumer side enable fakes; prefer real Postgres for `db/` (`DATABASE_URL`, tx rollback per test).
- HTTP via `httptest` against the real router.
- `gotestsum --junitfile reports/junit.xml -- -race -coverprofile=reports/cover.out ./...`; fail under 80% over `internal/` (`cmd/` is wiring, excluded).
