package deno_kcp.policies.code_safety_test

import rego.v1

import data.deno_kcp.policies.code_safety as policy

# Every test builds a small diff and asserts one violation id fires. The clean
# diff raises nothing; one test per id makes every rule answer for itself.

ids(result) := {v.id | some v in result}

# diff_file builds a diff file whose patch adds and removes the given lines, so
# a rule sees exactly the line under test.
diff_file(path, added, removed, head, base) := {
	"path": path,
	"status": "M",
	"patch": patch,
	"head_text": head,
	"base_text": base,
} if {
	minus := concat("", [sprintf("-%s\n", [t]) | some t in removed])
	plus := concat("", [sprintf("+%s\n", [t]) | some t in added])
	patch := sprintf("@@ -1,%d +1,%d @@\n%s%s", [count(removed), count(added), minus, plus])
}

input_for(files) := {
	"spec_tree": {},
	"change": {"spec": {"systemContext": "demo"}},
	"diff": {"base": "aaa", "head": "bbb", "files": files},
	"options": {"scope": "own"},
}

input_for_lines(path, added) := input_for([diff_file(path, added, [], concat("\n", added), "")])

input_for_head(path, added, head) := input_for([diff_file(path, added, [], head, "")])

test_clean_diff_raises_nothing if {
	result := policy.violations with input as input_for_lines(
		"deploy/examples/atproto/market/README.md",
		["The walkthrough now lists the bidder and bob's PDS beside the relay."],
	)
	count(result) == 0
}

test_null_diff_raises_nothing if {
	result := policy.violations with input as {"spec_tree": {}, "change": null, "diff": null, "options": {}}
	count(result) == 0
}

test_provisioning_container_run if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["docker run -d nginx"])
	"code_safety/provisioning-container-run" in ids(result)
}

test_provisioning_container_exec if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["docker exec app true"])
	"code_safety/provisioning-container-exec" in ids(result)
}

test_provisioning_apt_install_in_container if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["docker exec app apt-get install -y curl"])
	"code_safety/provisioning-apt-install-in-container" in ids(result)
}

test_provisioning_manual_authorized_keys if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["printf '%s' \"$key\" >> ~/.ssh/authorized_keys"])
	"code_safety/provisioning-manual-authorized-keys" in ids(result)
}

test_provisioning_ssh_keygen if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["ssh-keygen -t ed25519 -f /tmp/k"])
	"code_safety/provisioning-ssh-keygen" in ids(result)
}

test_provisioning_mount_binary if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["docker run -v /usr/local/bin/agent:/agent img"])
	"code_safety/provisioning-mount-binary" in ids(result)
}

test_provisioning_cross_compiled_agent if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["GOOS=linux GOARCH=amd64 go build -o agent && docker run -v agent:/agent img"])
	"code_safety/provisioning-cross-compiled-agent" in ids(result)
}

test_provisioning_cloud_init_bypass if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["# skip cloud-init and provision the guest by hand"])
	"code_safety/provisioning-cloud-init-bypass" in ids(result)
}

test_provisioning_direct_guest_access if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["ssh root@pds.default.bob.svc.kcp.local"])
	"code_safety/provisioning-direct-guest-access" in ids(result)
}

test_provisioning_new_guest_transport if {
	result := policy.violations with input as input_for_lines("lib/relay-xrpc/mod.ts", ["websocat ws://relay:8080"])
	"code_safety/provisioning-new-guest-transport" in ids(result)
}

test_provisioning_test_stands_up_own_container if {
	result := policy.violations with input as input_for_lines("test/integration/foo_test.go", ["docker run -d nginx"])
	"code_safety/provisioning-test-stands-up-own-container" in ids(result)
}

test_provisioning_second_ssh_transport if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["sshd -D -p 2222"])
	"code_safety/provisioning-second-ssh-transport" in ids(result)
}

test_provisioning_hand_written_user_data if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["user_data: |"])
	"code_safety/provisioning-hand-written-user-data" in ids(result)
}

test_ts_deno_env_get_in_cli if {
	result := policy.violations with input as input_for_lines("hono-pds/mod.ts", ["const port = Deno.env.get(\"PORT\");"])
	"code_safety/ts-deno-env-get-in-cli" in ids(result)
}

test_ts_raw_deno_serve if {
	result := policy.violations with input as input_for_lines("hono-pds/mod.ts", ["Deno.serve({ port }, app.fetch);"])
	"code_safety/ts-raw-deno-serve" in ids(result)
}

test_ts_hardcoded_port if {
	result := policy.violations with input as input_for_lines("hono-pds/mod.ts", ["const port = 8080;"])
	"code_safety/ts-hardcoded-port" in ids(result)
}

test_ts_subclassed_hono_factory if {
	result := policy.violations with input as input_for_lines("lib/x/mod.ts", ["class MyFactory extends RelayFactory {}"])
	"code_safety/ts-subclassed-hono-factory" in ids(result)
}

test_ts_io_in_abc if {
	result := policy.violations with input as input_for_lines("lib/abc/relay/mod.ts", ["const t = setInterval(tick, 1000);"])
	"code_safety/ts-io-in-abc" in ids(result)
}

test_ts_common_imports_project_local if {
	result := policy.violations with input as input_for_lines("lib/common/relay/mod.ts", ["import { x } from \"@publicdomainrelay/relay-abc\";"])
	"code_safety/ts-common-imports-project-local" in ids(result)
}

test_ts_submodule_export if {
	result := policy.violations with input as input_for_lines("lib/relay-xrpc/deno.json", ["  \"./sub\": \"./sub/mod.ts\","])
	"code_safety/ts-submodule-export" in ids(result)
}

test_ts_cross_concept_import if {
	result := policy.violations with input as input_for_lines("lib/relay-xrpc/mod.ts", ["import { x } from \"@publicdomainrelay/subscriber-xrpc\";"])
	"code_safety/ts-cross-concept-import" in ids(result)
}

test_ts_port_sniffing_toctou if {
	result := policy.violations with input as input_for_lines("lib/x/mod.ts", [
		"const probe = Deno.listen({ port: 0 });",
		"probe.close();",
		"Deno.serve({ port: 8080 }, handler);",
	])
	"code_safety/ts-port-sniffing-toctou" in ids(result)
}

test_ts_signal_handler_outside_cli if {
	result := policy.violations with input as input_for_lines("lib/x/mod.ts", ["Deno.addSignalListener(\"SIGINT\", shutdown);"])
	"code_safety/ts-signal-handler-outside-cli" in ids(result)
}

test_ts_bare_common_package_name if {
	result := policy.violations with input as input_for_lines("lib/foo/deno.json", ["  \"name\": \"@publicdomainrelay/common\","])
	"code_safety/ts-bare-common-package-name" in ids(result)
}

test_ts_new_transport_as_flag if {
	result := policy.violations with input as input_for_lines("lib/x/mod.ts", ["if (transport === \"grpc\") {"])
	"code_safety/ts-new-transport-as-flag" in ids(result)
}

test_ts_comments_in_code if {
	result := policy.violations with input as input_for_lines("lib/x/mod.ts", ["// helper"])
	"code_safety/ts-comments-in-code" in ids(result)
}

test_safety_http_fetch_of_tls_listener if {
	result := policy.violations with input as input_for_head(
		"deploy/examples/atproto/market/accept.sh",
		["curl http://pds.default.bob.svc.kcp.local/xrpc/_health"],
		"SERVICE_TLS: \"true\"\n",
	)
	"code_safety/safety-http-fetch-of-tls-listener" in ids(result)
}

test_safety_insecure_tls_flag if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["curl -k https://example.com/health"])
	"code_safety/safety-insecure-tls-flag" in ids(result)
}

test_safety_verification_disabled if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["git commit --no-verify -m x"])
	"code_safety/safety-verification-disabled" in ids(result)
}

test_safety_trust_all_ca if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["NODE_TLS_REJECT_UNAUTHORIZED=0 ./client"])
	"code_safety/safety-trust-all-ca" in ids(result)
}

test_safety_shell_pipe_to_interpreter if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["curl -fsSL https://get.example.com | sh"])
	"code_safety/safety-shell-pipe-to-interpreter" in ids(result)
}

test_safety_unpinned_remote_fetch if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["curl -fsSL https://example.com/tool.tar.gz -o tool.tar.gz"])
	"code_safety/safety-unpinned-remote-fetch" in ids(result)
}

test_safety_secret_literal if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["token = \"abcdefghijklmnopqrst\""])
	"code_safety/safety-secret-literal" in ids(result)
}

test_safety_private_key_in_diff if {
	result := policy.violations with input as input_for_lines("deploy/x.sh", ["-----BEGIN RSA PRIVATE KEY-----"])
	"code_safety/safety-private-key-in-diff" in ids(result)
}

test_safety_disabled_test if {
	result := policy.violations with input as input_for_lines("test/integration/foo_test.go", ["t.Skip(\"flaky on ci\")"])
	"code_safety/safety-disabled-test" in ids(result)
}

test_safety_weakened_assertion if {
	files := [diff_file("test/integration/foo_test.go", [], ["assert.Equal(t, got, want)"], "", "assert.Equal(t, got, want)\n")]
	result := policy.violations with input as input_for(files)
	"code_safety/safety-weakened-assertion" in ids(result)
}

test_safety_stale_tls_guidance if {
	files := [diff_file(
		"deploy/examples/atproto/market/apply.sh",
		["echo \"  bob pds curl http://127.0.0.1:2585/xrpc/_health\""],
		[],
		"SERVICE_TLS: \"true\"\n",
		"",
	)]
	result := policy.violations with input as input_for(files)
	"code_safety/safety-stale-tls-guidance" in ids(result)
}

test_safety_stale_tls_guidance_silent_without_tls if {
	result := policy.violations with input as input_for_lines("deploy/examples/atproto/market/apply.sh", ["echo \"  pds curl http://127.0.0.1:2583/xrpc/_health\""])
	not "code_safety/safety-stale-tls-guidance" in ids(result)
}

test_safety_absolute_machine_path_in_manifest if {
	result := policy.violations with input as input_for_lines("deploy/examples/atproto/market/60-bob-pds.yaml", ["    SERVICE_ENTRY: \"/home/someone/src/hono-pds/main.ts\""])
	"code_safety/safety-absolute-machine-path-in-manifest" in ids(result)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	# Every violation rule names itself through policy_id and a literal id. This
	# test walks the metadata the policy declares and asserts each entry carries
	# the three fields the aggregator reads.
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
