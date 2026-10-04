# Context: third-party-openbao-internal-builtin-logical-rabbitmq-cmd-rabbitmq

Repository: `deno-kcp`

This context exists because the RabbitMQ logical backend must be runnable as an out-of-process plugin: the engine logic lives in the rabbitmq package, but something has to expose it over the plugin protocol with the correct TLS handshake and backend factory. main.go is that something — it is the packaging seam, not the engine, and it is the only place where the backend factory, the AutoMTLS-compatible TLS provider, and the operator-facing TLS flags meet.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/rabbitmq/cmd/rabbitmq/main.go` file main.go (third_party/openbao/internal/builtin/logical/rabbitmq/cmd/rabbitmq/main.go)
<!-- SPECD_MANAGED_END -->
