package provider

import (
	"context"
	"sync"
	"time"

	"github.com/publicdomainrelay/kcp-libs/common/ref"
)

// tokenMemo answers a mint for a service account it has just minted for. A pod
// that is starting asks for its own identity twice: once through the DNS
// layer's KCP_TOKENS table, which is what the shim authenticates with, and once
// as the run's own credential. Both name the same account, so without the memo
// one workload mints two tokens for it. An entry lives for half the requested
// TTL, so a cached token is never served close to its expiry.
type tokenMemo struct {
	inner TokenMinter

	ttl time.Duration

	now func() time.Time

	mu      sync.Mutex
	entries map[string]tokenEntry
}

type tokenEntry struct {
	token   string
	expires time.Time
}

func newTokenMemo(inner TokenMinter, ttl time.Duration) *tokenMemo {
	if ttl <= 0 {
		ttl = time.Hour
	}
	return &tokenMemo{inner: inner, ttl: ttl / 2, now: time.Now, entries: map[string]tokenEntry{}}
}

func (m *tokenMemo) MintServiceAccountToken(ctx context.Context, logicalCluster, namespace, name string, ttl time.Duration) (string, error) {
	// ponytail: Registry already reads an empty namespace as the default one;
	// keying on the same normalised name is what makes the two callers of one
	// workload land on the same entry.
	if namespace == "" {
		namespace = DefaultServiceAccountNamespace
	}
	key := ref.Key(logicalCluster, namespace, name)
	now := m.now()
	m.mu.Lock()
	entry, ok := m.entries[key]
	m.mu.Unlock()
	if ok && now.Before(entry.expires) {
		return entry.token, nil
	}
	token, err := m.inner.MintServiceAccountToken(ctx, logicalCluster, namespace, name, ttl)
	if err != nil {
		return "", err
	}
	life := m.ttl
	if ttl > 0 && ttl/2 < life {
		life = ttl / 2
	}
	m.mu.Lock()
	for k, e := range m.entries {
		if !now.Before(e.expires) {
			delete(m.entries, k)
		}
	}
	m.entries[key] = tokenEntry{token: token, expires: now.Add(life)}
	m.mu.Unlock()
	return token, nil
}
