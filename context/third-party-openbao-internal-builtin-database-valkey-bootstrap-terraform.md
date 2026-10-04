# Context: third-party-openbao-internal-builtin-database-valkey-bootstrap-terraform

Repository: `deno-kcp`

This context exists to stand up a disposable, reproducible Valkey instance for the OpenBao internal builtin database/valkey plugin tests, and to publish the connection settings those tests read from the environment. Terraform owns the lifecycle: apply starts the container and regenerates the environment file, destroy tears the container down, so the test fixture is created and removed by the same tooling that runs everything else.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/valkey/bootstrap/terraform/docker-compose.yml` file docker-compose.yml (third_party/openbao/internal/builtin/database/valkey/bootstrap/terraform/docker-compose.yml)
- `file:third_party/openbao/internal/builtin/database/valkey/bootstrap/terraform/redis.tf` file redis.tf (third_party/openbao/internal/builtin/database/valkey/bootstrap/terraform/redis.tf)
<!-- SPECD_MANAGED_END -->
