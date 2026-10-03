package provider

import (
	"errors"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func TestMetricsExposition(t *testing.T) {
	p := &Provider{}
	p.metrics.reconciles.Add(3)
	p.metrics.conflicts.Add(1)
	p.recordReconcile(10*time.Millisecond, nil)
	p.recordReconcile(30*time.Millisecond, errors.New("conflict"))

	rec := httptest.NewRecorder()
	p.handleMetrics(rec, httptest.NewRequest("GET", "/metrics", nil))
	body := rec.Body.String()

	for _, want := range []string{
		"denokcp_reconciles_total 3",
		"denokcp_conflicts_total 1",
		"denokcp_errors_total 1",
		"denokcp_queue_depth 0",
		"denokcp_reconcile_seconds_count 2",
		"denokcp_reconcile_seconds_sum 0.040000",
	} {
		if !strings.Contains(body, want) {
			t.Fatalf("metrics output missing %q:\n%s", want, body)
		}
	}
}

func TestCacheAgeZeroBeforeEvents(t *testing.T) {
	p := &Provider{}
	if p.cacheAgeSeconds() != 0 {
		t.Fatalf("cache age = %v, want 0 before any event", p.cacheAgeSeconds())
	}
	p.recordEvent()
	if age := p.cacheAgeSeconds(); age < 0 || age > 5 {
		t.Fatalf("cache age = %v, want a small non-negative value", age)
	}
}
