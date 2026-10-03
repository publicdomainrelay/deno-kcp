package runner

import (
	"context"
	"time"
)

type EngineRequest struct {
	Name string

	LogicalCluster string

	Port int

	Env map[string]string
}

type EngineStatus struct {
	State State

	Message string
}

type EngineRunner interface {
	Start(ctx context.Context, req EngineRequest) (string, error)

	Observe(ctx context.Context, runID string) (EngineStatus, error)

	Stop(ctx context.Context, runID string) error

	Probe(ctx context.Context, runID string, command []string, timeout time.Duration) (bool, error)
}
