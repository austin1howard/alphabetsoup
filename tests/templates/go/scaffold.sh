GO_MM=$(go env GOVERSION | sed -E 's/^go([0-9]+\.[0-9]+).*/\1/')
go mod init example.com/demo 2>/dev/null
go get -tool github.com/golangci/golangci-lint/v2/cmd/golangci-lint gotest.tools/gotestsum github.com/boumenot/gocover-cobertura 2>/dev/null
go get github.com/danielgtaylor/huma/v2 github.com/go-chi/chi/v5 2>/dev/null
for f in Makefile Dockerfile .dockerignore .golangci.yml; do fill "$f" "$f"; done
mkdir -p cmd/demo internal/api
cp "$F/main.go" cmd/demo/main.go
cp "$F/api.go" "$F/api_test.go" internal/api/
go mod tidy 2>/dev/null
