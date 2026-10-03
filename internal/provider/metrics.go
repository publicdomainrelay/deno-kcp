package provider

import (
	"fmt"
	"net"
	"net/http"
	"sync/atomic"
	"time"
)

type providerMetrics struct {
	reconciles atomic.Uint64

	conflicts atomic.Uint64

	errors atomic.Uint64

	reconcileNanos atomic.Uint64

	reconcileCount atomic.Uint64

	lastEventNanos atomic.Int64
}

func (p *Provider) recordReconcile(d time.Duration, err error) {
	p.metrics.reconcileCount.Add(1)
	if d > 0 {
		p.metrics.reconcileNanos.Add(uint64(d))
	}
	if err != nil {
		p.metrics.errors.Add(1)
	}
}

func (p *Provider) recordConflict() {
	p.metrics.conflicts.Add(1)
}

func (p *Provider) recordEvent() {
	p.metrics.lastEventNanos.Store(time.Now().UnixNano())
}

func (p *Provider) queueDepth() int64 {
	if p.watch == nil {
		return 0
	}
	return int64(p.watch.queue.Len())
}

func (p *Provider) cacheAgeSeconds() float64 {
	last := p.metrics.lastEventNanos.Load()
	if last == 0 {
		return 0
	}
	return time.Since(time.Unix(0, last)).Seconds()
}

func (p *Provider) handleMetrics(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "text/plain; version=0.0.4")
	var sum float64
	if count := p.metrics.reconcileCount.Load(); count > 0 {
		sum = float64(p.metrics.reconcileNanos.Load()) / float64(time.Second)
	}
	fmt.Fprintf(w, "# HELP denokcp_queue_depth work keys waiting in the reconcile queue\n")
	fmt.Fprintf(w, "# TYPE denokcp_queue_depth gauge\n")
	fmt.Fprintf(w, "denokcp_queue_depth %d\n", p.queueDepth())
	fmt.Fprintf(w, "# HELP denokcp_cache_age_seconds seconds since the last informer event\n")
	fmt.Fprintf(w, "# TYPE denokcp_cache_age_seconds gauge\n")
	fmt.Fprintf(w, "denokcp_cache_age_seconds %.3f\n", p.cacheAgeSeconds())
	fmt.Fprintf(w, "# HELP denokcp_reconciles_total reconciles started\n")
	fmt.Fprintf(w, "# TYPE denokcp_reconciles_total counter\n")
	fmt.Fprintf(w, "denokcp_reconciles_total %d\n", p.metrics.reconciles.Load())
	fmt.Fprintf(w, "# HELP denokcp_conflicts_total writes rejected by optimistic concurrency\n")
	fmt.Fprintf(w, "# TYPE denokcp_conflicts_total counter\n")
	fmt.Fprintf(w, "denokcp_conflicts_total %d\n", p.metrics.conflicts.Load())
	fmt.Fprintf(w, "# HELP denokcp_errors_total reconciles that returned an error\n")
	fmt.Fprintf(w, "# TYPE denokcp_errors_total counter\n")
	fmt.Fprintf(w, "denokcp_errors_total %d\n", p.metrics.errors.Load())
	fmt.Fprintf(w, "# HELP denokcp_reconcile_seconds time spent inside a reconcile\n")
	fmt.Fprintf(w, "# TYPE denokcp_reconcile_seconds summary\n")
	fmt.Fprintf(w, "denokcp_reconcile_seconds_sum %.6f\n", sum)
	fmt.Fprintf(w, "denokcp_reconcile_seconds_count %d\n", p.metrics.reconcileCount.Load())
	fmt.Fprintf(w, "# HELP denokcp_active_runs workloads started and not yet terminal\n")
	fmt.Fprintf(w, "# TYPE denokcp_active_runs gauge\n")
	fmt.Fprintf(w, "denokcp_active_runs %d\n", p.ActiveRuns())
	fmt.Fprintf(w, "# HELP denokcp_max_active_runs high-water mark of denokcp_active_runs\n")
	fmt.Fprintf(w, "# TYPE denokcp_max_active_runs gauge\n")
	fmt.Fprintf(w, "denokcp_max_active_runs %d\n", p.MaxActiveRuns())
}

type metricsServer struct {
	listener net.Listener
}

func (p *Provider) serveMetrics(listen string) error {
	l, err := net.Listen("tcp", listen)
	if err != nil {
		return fmt.Errorf("provider: bind metrics endpoint on %s: %w", listen, err)
	}
	mux := http.NewServeMux()
	mux.HandleFunc("/metrics", p.handleMetrics)
	go func() {
		_ = http.Serve(l, mux)
	}()
	p.metricsSrv = &metricsServer{listener: l}
	return nil
}

func (s *metricsServer) close() error {
	if s == nil || s.listener == nil {
		return nil
	}
	return s.listener.Close()
}
