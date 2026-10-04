package deno_kcp.policies.code_safety

import rego.v1

import data.deno_kcp.lib.code
import data.deno_kcp.lib.text

# A guest is born from the RFP flow's cloud-init user_data: a requester posts a
# compute.vm record and a signed market.rfp, bidders bid, the winner provisions
# the guest through `buildUserData`, and the requester reaches it only through
# the relay. These rules catch a change that provisions a guest, or reaches one,
# by hand instead.

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["docker run", "podman run", "container run", "nerdctl run"])
	v := finding(
		"provisioning-container-run",
		row,
		sprintf("added command starts a container directly: %q; a guest is born from the RFP flow's cloud-init user_data, never from a container run", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["docker exec", "podman exec", "container exec", "nerdctl exec"])
	v := finding(
		"provisioning-container-exec",
		row,
		sprintf("added command runs inside a container directly: %q; a guest is configured by the cloud-init user_data the bidder applies, not by exec into a container", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)(apt-get\s+install|apt\s+install|apk\s+add|yum\s+install)`, row.text)
	text.contains_any(row.text, ["docker", "podman", "container", "nerdctl"])
	v := finding(
		"provisioning-apt-install-in-container",
		row,
		sprintf("added line installs a package inside a container: %q; the guest agent is installed by the cloud-init user_data, never by apt inside a container", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	contains(row.text, "authorized_keys")
	v := finding(
		"provisioning-manual-authorized-keys",
		row,
		sprintf("added line writes authorized_keys by hand: %q; a guest is reached through the relay's ProxyCommand over the websocket tunnel, so no authorized_keys is assembled by hand", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	contains(row.text, "ssh-keygen")
	v := finding(
		"provisioning-ssh-keygen",
		row,
		sprintf("added line generates an ssh keypair by hand: %q; guest access is over the relay, and a guest's keys are placed by the cloud-init user_data, not by ssh-keygen", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)(--mount|--volume|--bind)\b`, row.text)
	text.contains_any(row.text, ["docker", "podman", "container", "nerdctl"])
	v := finding(
		"provisioning-mount-binary",
		row,
		sprintf("added command mounts a host path into a container: %q; a guest-side binary is installed by the cloud-init user_data, never mounted in", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(^|\s)-v\s+\S+:/`, row.text)
	v := finding(
		"provisioning-mount-binary",
		row,
		sprintf("added command bind-mounts a host path into a container: %q; a guest-side binary is installed by the cloud-init user_data, never mounted in", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`\bGOOS\s*=|\bGOARCH\s*=`, row.text)
	text.contains_any(row.text, ["docker", "podman", "container", "nerdctl", "--mount", "--volume", "docker cp", "container cp", " -v ", "mount "])
	v := finding(
		"provisioning-cross-compiled-agent",
		row,
		sprintf("added line cross-compiles an agent and mounts or copies it into a guest: %q; installing an agent this way is exactly the cloud-init bypass the project forbids", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["user_data", "userData", "cloud-init", "cloud_config", "cloud-config"])
	text.contains_any(row.text, ["skip", "bypass", "without", "disable", "no-user-data", "no-userdata"])
	v := finding(
		"provisioning-cloud-init-bypass",
		row,
		sprintf("added line skips the cloud-init user_data path: %q; every guest must come up through the user_data the RFP flow produces", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["ssh ", "nc ", "ncat ", "curl ", "wget "])
	contains(row.text, "svc.kcp.local")
	not contains(row.text, "ProxyCommand")
	not contains(row.text, "relay")
	v := finding(
		"provisioning-direct-guest-access",
		row,
		sprintf("added line reaches a guest address without the relay: %q; a guest is reached only through the relay, over the websocket tunnel via ssh ProxyCommand", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["websocat", "wstunnel", "chisel", "frpc", "frps", "autossh", "rathole", "socat"])
	not text.contains_any(row.text, ["UserDataModule", "user_data", "userData", "cloud-init", "cloud_config"])
	v := finding(
		"provisioning-new-guest-transport",
		row,
		sprintf("added line introduces a guest transport the cloud-init does not deploy: %q; a new guest transport is a UserDataModule in cloud-init-common's registry, so the RFP flow stays the only way a guest comes up", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_test_file(row.path)
	text.contains_any(row.text, ["docker run", "container run", "podman run", "nerdctl run", "docker exec", "container exec"])
	v := finding(
		"provisioning-test-stands-up-own-container",
		row,
		sprintf("added test line stands up its own container: %q; a test that needs a live guest drives runComputeContract against a real local bidder, it never runs a container itself", [trim_space(row.text)]),
		{"test": true},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["sshd", "openssh-server", "ssh-server", "ssh -R", "ssh -L"])
	not text.contains_any(row.text, ["user_data", "userData", "cloud-init", "cloud_config", "UserDataModule"])
	v := finding(
		"provisioning-second-ssh-transport",
		row,
		sprintf("added line adds an SSH transport the RFP cloud-init does not deploy: %q; a guest's sshd is installed by the cloud-init user_data, and the relay's tunnel is the only transport to it", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["user_data", "userData", "cloud-config", "cloud_config", "#cloud-config"])
	not text.contains_any(row.text, ["skip", "bypass", "disable"])
	not contains(row.text, "buildUserData")
	v := finding(
		"provisioning-hand-written-user-data",
		row,
		sprintf("added line builds cloud-config by hand: %q; user_data is composed through buildUserData and its module registry, never written by hand", [trim_space(row.text)]),
		{},
	)
}
