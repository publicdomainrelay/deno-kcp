# Context: third-party-openbao-internal-builtin-database-cassandra

Repository: `deno-kcp`

The context exists to specify the Cassandra database plugin of the embedded OpenBao distribution that deno-kcp vendors: a secrets engine that dynamically provisions, rotates, and revokes Cassandra users on behalf of the platform. It is third-party code carried in-tree rather than written here, so the spec records the contract the vendored copy must satisfy (the dbplugin method set, the gocql session lifecycle, CQL statement splitting and interpolation, and rollback on failed creation) for anyone reading, testing, or modifying it.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  kind: method
  name: Cassandra.DeleteUser
  signature: func (c *Cassandra) DeleteUser(ctx context.Context, req dbplugin.DeleteUserRequest)
    (dbplugin.DeleteUserResponse, error)
- file: third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  kind: method
  name: Cassandra.Initialize
  signature: func (c *Cassandra) Initialize(ctx context.Context, req dbplugin.InitializeRequest)
    (dbplugin.InitializeResponse, error)
- file: third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  kind: method
  name: Cassandra.NewUser
  signature: func (c *Cassandra) NewUser(ctx context.Context, req dbplugin.NewUserRequest)
    (dbplugin.NewUserResponse, error)
- file: third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  kind: method
  name: Cassandra.Type
  signature: func (c *Cassandra) Type() (string, error)
- file: third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  kind: method
  name: Cassandra.UpdateUser
  signature: func (c *Cassandra) UpdateUser(ctx context.Context, req dbplugin.UpdateUserRequest)
    (dbplugin.UpdateUserResponse, error)
- file: third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  kind: function
  name: New
  signature: func New() (any, error)
- file: third_party/openbao/internal/builtin/database/cassandra/connection_producer.go
  kind: method
  name: cassandraConnectionProducer.Close
  signature: func (c *cassandraConnectionProducer) Close() error
- file: third_party/openbao/internal/builtin/database/cassandra/connection_producer.go
  kind: method
  name: cassandraConnectionProducer.Connection
  signature: func (c *cassandraConnectionProducer) Connection(ctx context.Context)
    (any, error)
- file: third_party/openbao/internal/builtin/database/cassandra/connection_producer.go
  kind: method
  name: cassandraConnectionProducer.Initialize
  signature: func (c *cassandraConnectionProducer) Initialize(ctx context.Context,
    req dbplugin.InitializeRequest) error
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  - method:4fde785073b5fce6dddcfdec87633060
  id: r.delete-user
  level: MUST
  text: Cassandra.DeleteUser must delete the named Cassandra user and return the dbplugin.DeleteUserResponse.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  - method:c0cf582b2daa9be4bc18adfe212e0b9b
  id: r.initialize-config
  level: MUST
  text: Cassandra.Initialize must validate and store plugin configuration and initialize
    the embedded connection producer before any user operation.
- codeRefs:
  - method:e7749700dfbe1b3401f7c87b94a47a51
  - struct:cf5ab4cfb46e08ff7c0a3f11416c81d0
  id: r.new-user-default-cql
  level: MUST
  text: Cassandra.NewUser must hold the lock, obtain a session via getConnection,
    generate the username through usernameProducer.Generate, and fall back to defaultUserCreationCQL
    when the request supplies no creation statements.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  - method:e7749700dfbe1b3401f7c87b94a47a51
  id: r.new-user-rollback
  level: MUST
  text: On a failed creation statement Cassandra.NewUser must roll back with the rollback
    statements (defaultUserDeletionCQL when none are given) and return the original
    error joined with any rollback error via multierror.Append.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  - method:e7749700dfbe1b3401f7c87b94a47a51
  id: r.new-user-splits-statements
  level: MUST
  text: Cassandra.NewUser must split each statement on semicolons with strutil.ParseArbitraryStringSlice,
    trim whitespace, skip empty queries, and interpolate username and password via
    dbutil.QueryHelper.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/cassandra.go
  - function:896447b936c176ef082306cc1a83e1b3
  id: r.new-wraps-sanitizer
  level: MUST
  text: New must build a Cassandra via new() and return it wrapped by dbplugin.NewDatabaseErrorSanitizerMiddleware
    with the embedded secretValues so errors are scrubbed of secret values.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/connection_producer.go
  - method:5fdcc8148196b14dda92e86d37277920
  id: r.producer-close
  level: MUST
  text: cassandraConnectionProducer.Close must release the held session and clear
    it so a later Connection creates a fresh one.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/connection_producer.go
  - method:43b0ffaae7ea1b876b5faefb7ddf1d76
  id: r.producer-connection
  level: MUST
  text: cassandraConnectionProducer.Connection must return a usable connection, creating
    and caching a gocql session when none is live, and getConnection must type-assert
    it to *gocql.Session.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/connection_producer.go
  - method:ff25d04d410a9dbfa4ae6623e6f267b7
  id: r.producer-initialize
  level: MUST
  text: cassandraConnectionProducer.Initialize must parse the plugin configuration,
    including TLS settings, and validate it before a session may be created.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/cassandra_test.go
  - file:third_party/openbao/internal/builtin/database/cassandra/connection_producer_test.go
  id: r.tests-cover-producer
  level: SHOULD
  text: Cassandra behavior must stay covered by cassandra_test.go and connection_producer_test.go,
    which exercise user creation through getCassandra and assertNewUser.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/cassandra/tls.go
  id: r.tls-config
  level: SHOULD
  text: TLS settings for Cassandra connections must be built in tls.go and applied
    when the gocql session is created.
- codeRefs:
  - method:e84994d2e2914fd4b017db889f7b23a5
  - struct:cf5ab4cfb46e08ff7c0a3f11416c81d0
  id: r.type-name
  level: MUST
  text: Cassandra.Type must return cassandraTypeName and a nil error.
- codeRefs:
  - method:22f672314f03258d5dcdfbdbeef88afb
  - struct:cf5ab4cfb46e08ff7c0a3f11416c81d0
  id: r.update-user
  level: MUST
  text: Cassandra.UpdateUser must return the dbplugin.UpdateUserResponse and route
    password changes through changeUserPassword.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/cassandra/cassandra.go` file cassandra.go (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
- `file:third_party/openbao/internal/builtin/database/cassandra/cassandra_test.go` file cassandra_test.go (third_party/openbao/internal/builtin/database/cassandra/cassandra_test.go)
- `file:third_party/openbao/internal/builtin/database/cassandra/connection_producer.go` file connection_producer.go (third_party/openbao/internal/builtin/database/cassandra/connection_producer.go)
- `file:third_party/openbao/internal/builtin/database/cassandra/connection_producer_test.go` file connection_producer_test.go (third_party/openbao/internal/builtin/database/cassandra/connection_producer_test.go)
- `file:third_party/openbao/internal/builtin/database/cassandra/tls.go` file tls.go (third_party/openbao/internal/builtin/database/cassandra/tls.go)
- `function:896447b936c176ef082306cc1a83e1b3` function New (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
- `method:22f672314f03258d5dcdfbdbeef88afb` method Cassandra.UpdateUser (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
- `method:43b0ffaae7ea1b876b5faefb7ddf1d76` method cassandraConnectionProducer.Connection (third_party/openbao/internal/builtin/database/cassandra/connection_producer.go)
- `method:4fde785073b5fce6dddcfdec87633060` method Cassandra.DeleteUser (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
- `method:5fdcc8148196b14dda92e86d37277920` method cassandraConnectionProducer.Close (third_party/openbao/internal/builtin/database/cassandra/connection_producer.go)
- `method:c0cf582b2daa9be4bc18adfe212e0b9b` method Cassandra.Initialize (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
- `method:e7749700dfbe1b3401f7c87b94a47a51` method Cassandra.NewUser (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
- `method:e84994d2e2914fd4b017db889f7b23a5` method Cassandra.Type (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
- `method:ff25d04d410a9dbfa4ae6623e6f267b7` method cassandraConnectionProducer.Initialize (third_party/openbao/internal/builtin/database/cassandra/connection_producer.go)
- `struct:cf5ab4cfb46e08ff7c0a3f11416c81d0` struct Cassandra (third_party/openbao/internal/builtin/database/cassandra/cassandra.go)
<!-- SPECD_MANAGED_END -->
