# Context: third-party-openbao-internal-builtin-database-valkey

Repository: `deno-kcp`

This context exists so the vendored Valkey database plugin can be read, reviewed and modified without opening the whole OpenBao third_party tree. It covers the connection producer that owns config parsing, TLS material and the radix client pool, and the ValkeyDB plugin surface that the database secrets engine drives for user creation, update and deletion. Pinning the producer's validation order, the connection_url versus discrete-parameter exclusivity, the valkeys scheme shortcut and the lazy TLS pool construction gives a reader the exact contract the rest of the plugin depends on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/valkey/connection_producer.go` file connection_producer.go (third_party/openbao/internal/builtin/database/valkey/connection_producer.go)
- `file:third_party/openbao/internal/builtin/database/valkey/valkey.go` file valkey.go (third_party/openbao/internal/builtin/database/valkey/valkey.go)
- `file:third_party/openbao/internal/builtin/database/valkey/valkey_test.go` file valkey_test.go (third_party/openbao/internal/builtin/database/valkey/valkey_test.go)
- `function:978862d8011b00bac819507253bdc40e` function New (third_party/openbao/internal/builtin/database/valkey/valkey.go)
- `method:427e3712d41179406f6cfb5b02e426f1` method valkeyDBConnectionProducer.Connection (third_party/openbao/internal/builtin/database/valkey/connection_producer.go)
- `method:54ff7525a3213cf993e72f4d308ba565` method valkeyDBConnectionProducer.Close (third_party/openbao/internal/builtin/database/valkey/connection_producer.go)
- `method:9313dd88c5a0f37c2175d40d2f586ee5` method valkeyDBConnectionProducer.Initialize (third_party/openbao/internal/builtin/database/valkey/connection_producer.go)
- `method:9545ac34407bd7a0f454f367d91399b9` method valkeyDBConnectionProducer.Init (third_party/openbao/internal/builtin/database/valkey/connection_producer.go)
- `method:9bc592af64e66b2c877634c8f9f92ba4` method ValkeyDB.NewUser (third_party/openbao/internal/builtin/database/valkey/valkey.go)
- `method:a99adf5df6742a2aa726a4d611e3bafc` method ValkeyDB.UpdateUser (third_party/openbao/internal/builtin/database/valkey/valkey.go)
- `method:b85beda9e21d4debeb77cfd2a037481c` method ValkeyDB.Type (third_party/openbao/internal/builtin/database/valkey/valkey.go)
- `method:d8fab9f0745ca0dd55fc2e648c2cf482` method ValkeyDB.Initialize (third_party/openbao/internal/builtin/database/valkey/valkey.go)
- `method:ecc70248f2a40b03d37b0ebdd50482cb` method ValkeyDB.DeleteUser (third_party/openbao/internal/builtin/database/valkey/valkey.go)
- `struct:398078981736199853095f03d14fc210` struct ValkeyDB (third_party/openbao/internal/builtin/database/valkey/valkey.go)
<!-- SPECD_MANAGED_END -->
