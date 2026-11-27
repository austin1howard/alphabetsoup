// Command demo runs the API server.
package main

import (
	"log/slog"
	"net/http"
	"os"
	"time"

	"example.com/demo/internal/api"
)

func main() {
	srv := &http.Server{Addr: ":8080", Handler: api.NewRouter(), ReadHeaderTimeout: 5 * time.Second}
	if err := srv.ListenAndServe(); err != nil {
		slog.Error("server stopped", "err", err)
		os.Exit(1)
	}
}
