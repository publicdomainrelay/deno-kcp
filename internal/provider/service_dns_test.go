package provider

import "testing"

func TestServiceFQDNShape(t *testing.T) {
	cases := []struct {
		name, namespace, lc, want string
	}{
		{"plc", "default", "root:global", "plc.default.global.svc.kcp.local"},
		{"relay", "default", "root:relay", "relay.default.relay.svc.kcp.local"},
		{"pds", "default", "root:alice", "pds.default.alice.svc.kcp.local"},
		{"pds", "", "root:alice", "pds.default.alice.svc.kcp.local"},
		{"runner", "team-a", "root:acme:prod", "runner.team-a.prod.acme.svc.kcp.local"},
		{"top", "default", "root", "top.default.svc.kcp.local"},
	}
	for _, c := range cases {
		got := serviceFQDN(c.name, c.namespace, c.lc, "kcp.local")
		if got != c.want {
			t.Fatalf("serviceFQDN(%q, %q, %q) = %q, want %q", c.name, c.namespace, c.lc, got, c.want)
		}
	}
}

// ponytail: the shim parses a name back apart to find the workspace, so the labelling has to be reversible; a deeper path must not collapse into a shallower one.
func TestServiceLabelsKeepDepthDistinct(t *testing.T) {
	if serviceLabels("root:prod") == serviceLabels("root:acme:prod") {
		t.Fatal("root:prod and root:acme:prod produced the same labels")
	}
	if got := serviceLabels("root"); got != "" {
		t.Fatalf("the root workspace alone produced %q, want no labels", got)
	}
}
