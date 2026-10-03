package livegate

import (
	"os"
	"testing"
)

func RequiresLive() bool {
	return os.Getenv("DENO_KCP_REQUIRE_LIVE") == "1"
}

func Require(t *testing.T, format string, args ...any) {
	t.Helper()
	if RequiresLive() {
		t.Fatalf(format, args...)
	}
	t.Skipf(format, args...)
}

func Short(t *testing.T, format string, args ...any) {
	t.Helper()
	if testing.Short() {
		Require(t, format, args...)
	}
}
