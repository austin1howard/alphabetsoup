// Package api defines the HTTP API.
package api

import (
	"context"
	"net/http"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
)

// HealthOutput is the health check response.
type HealthOutput struct {
	Body struct {
		Status string `json:"status"`
	}
}

// NewRouter builds the router with all operations registered.
func NewRouter() http.Handler {
	r := chi.NewRouter()
	a := humachi.New(r, huma.DefaultConfig("demo", "1.0.0"))
	huma.Get(a, "/healthz", func(_ context.Context, _ *struct{}) (*HealthOutput, error) {
		out := &HealthOutput{}
		out.Body.Status = "ok"
		return out, nil
	})
	return r
}
