package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.violation

repository_phases := {"Cloning", "Indexing", "Populating", "Populated", "Failed"}

violations contains v if {
	verify := object.get(object.get(input.spec_tree.repository, "spec", {}), "verify", null)
	not is_array(verify)
	v := violation.build(
		policy_id,
		"repository-verify-missing",
		violation.location("repository", "", "repository.yaml", "/spec/verify"),
		"repository.yaml names no verify vector, so a realization has nothing to pass before it is accepted",
		{},
	)
}

violations contains v if {
	verify := object.get(object.get(input.spec_tree.repository, "spec", {}), "verify", [])
	is_array(verify)
	count(verify) == 0
	v := violation.build(
		policy_id,
		"repository-verify-missing",
		violation.location("repository", "", "repository.yaml", "/spec/verify"),
		"repository.yaml names an empty verify vector, so every realization passes without running anything",
		{},
	)
}

violations contains v if {
	branch := object.get(object.get(input.spec_tree.repository, "spec", {}), "branch", null)
	not is_string(branch)
	v := violation.build(
		policy_id,
		"repository-branch-missing",
		violation.location("repository", "", "repository.yaml", "/spec/branch"),
		"repository.yaml names no code branch, so no commit can be judged current",
		{},
	)
}

violations contains v if {
	phase := object.get(object.get(input.spec_tree.repository, "status", {}), "phase", null)
	is_string(phase)
	not phase in repository_phases
	v := violation.build(
		policy_id,
		"repository-phase-invalid",
		violation.location("repository", "", "repository.yaml", "/status/phase"),
		sprintf("repository.yaml records phase %q, which is not Cloning, Indexing, Populating or Populated", [phase]),
		{"phase": phase},
	)
}
