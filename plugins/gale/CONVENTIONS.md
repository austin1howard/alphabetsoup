# Go Conventions

## Tooling
- gofmt/goimports, `go vet`, golangci-lint, `go test -race` (always)

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
