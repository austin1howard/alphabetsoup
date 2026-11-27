---
name: scaffold
description: "Scaffold Go in a repo (root if single-stack, else backend/): go mod init, tools, Makefile, Dockerfile, golangci config. Used by alphabetsoup:bootstrap or when adding Go to an existing repo."
---

# Go scaffold

`<dir>` = repo root (single-stack) or `backend/`. `<module>` = module path (ask; default `github.com/<owner>/<repo>`), `<name>` = binary/image name. Templates in `${CLAUDE_SKILL_DIR}/templates/`; replace `{{name}}`.

1. `cd <dir> && go mod init <module>`
2. Tools (go.mod `tool` directive): `go get -tool github.com/golangci/golangci-lint/v2/cmd/golangci-lint gotest.tools/gotestsum github.com/boumenot/gocover-cobertura`. With Postgres add `github.com/sqlc-dev/sqlc/cmd/sqlc` + runtime `github.com/jackc/pgx/v5`.
   Service runtime: `github.com/danielgtaylor/huma/v2 github.com/go-chi/chi/v5`.
3. Copy `Makefile`, `Dockerfile`, `.dockerignore`, `.golangci.yml`. Replace `{{go-version}}` in Dockerfile with the major.minor from `go.mod`.
4. `cmd/<name>/main.go` wires a chi router + huma API with `GET /healthz`; `internal/api/api_test.go` covers it via `httptest` — `make check` green from day one.
5. Append to root `.gitignore`: `/bin/ reports/ *.test` (prefix with `backend/` for `/bin/` in multi-stack).
6. Run `make fmt && make check` (normalizes generated files).

CI toolchain recipe: `${CLAUDE_SKILL_DIR}/ci.md`.
