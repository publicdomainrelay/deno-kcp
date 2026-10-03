GO ?= go
DENO_KCP_REQUIRE_LIVE ?= 1

GO_DIRS := api internal cmd
ifneq ($(wildcard test),)
GO_DIRS += test
endif

GO_FILES := $(shell git ls-files '*.go')

LIVE_PREREQS := kcp kine deno
POLICY_ENGINE_DIR ?= ../policy-engine/lib/policy-engine-server-gha-lite

.PHONY: all build fmt vet tidy check test test-unit test-race test-integration test-live preflight preflight-kubectl preflight-integration clean

all: check test

build:
	$(GO) build ./...

fmt:
	@out=$$(gofmt -l $(GO_FILES)); \
	if [ -n "$$out" ]; then echo "gofmt would rewrite:"; echo "$$out"; exit 1; fi

vet:
	$(GO) vet ./...

tidy:
	$(GO) mod tidy -diff

check: fmt vet tidy

test-unit:
	$(GO) test ./...

test-race:
	$(GO) test -race -count=1 ./...

test-integration: preflight preflight-integration
	DENO_KCP_REQUIRE_LIVE=$(DENO_KCP_REQUIRE_LIVE) $(GO) test -v ./test/integration/

test-live: preflight preflight-kubectl
	DENO_KCP_REQUIRE_LIVE=$(DENO_KCP_REQUIRE_LIVE) $(GO) test -p 1 -count=1 ./...

test: check preflight-integration test-live

preflight:
	@missing=""; \
	for bin in $(LIVE_PREREQS); do \
	  command -v $$bin >/dev/null 2>&1 || missing="$$missing $$bin"; \
	done; \
	if [ ! -d "$(POLICY_ENGINE_DIR)" ]; then missing="$$missing $(POLICY_ENGINE_DIR)"; fi; \
	if [ -n "$$missing" ]; then \
	  echo "live tests need:$$missing"; \
	  echo "install them, or run 'make test-unit' for the tier that needs no cluster"; \
	  exit 1; \
	fi

preflight-kubectl:
	@command -v kubectl >/dev/null 2>&1 || { \
	  echo "'make test-live' needs kubectl: the internal/provider live tests drive the cluster through it."; \
	  echo "'make test-integration' does not - it uses the compiled-in client."; \
	  exit 1; \
	}

preflight-integration:
	@if [ ! -d test/integration ]; then \
	  echo "test/integration/ is missing, so 'make test' would skip the integration tier and still report green"; \
	  echo "run 'make test-live' for the live tests that do exist"; \
	  exit 1; \
	fi

clean:
	$(GO) clean -testcache
	rm -rf runs .kcp-demo
