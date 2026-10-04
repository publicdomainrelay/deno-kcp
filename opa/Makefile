OPA ?= opa
SPEC_ROOT ?= $(abspath $(CURDIR)/..)
CODE_ROOT ?= $(abspath $(CURDIR)/../../deno-kcp)
REF ?= origin/open-architecture/deno-kcp--spec-bidder-and-bob-pds
BASE_REF ?= origin/open-architecture/deno-kcp
CHANGE ?= deploy-examples-atproto-market-s2c-834078074eaa
DIFF_BASE ?= origin/main
DIFF_HEAD ?= origin/spec/bidder-and-bob-pds

.PHONY: help fmt fmt-check check test integration base change run lint all

help:
	@echo "make fmt         rewrite every policy in place"
	@echo "make fmt-check   fail if any policy is not formatted"
	@echo "make check       opa check --strict over the whole bundle"
	@echo "make test        opa test over the whole bundle"
	@echo "make base        evaluate every policy over the checked out spec tree"
	@echo "make change      evaluate every policy over the spec change and its code diff"
	@echo "make integration assert the findings the real change is known to carry"
	@echo "make all         fmt-check, check, test, integration"

fmt:
	$(OPA) fmt -w .

fmt-check:
	@out=$$($(OPA) fmt -l .); if [ -n "$$out" ]; then echo "not formatted:"; echo "$$out"; exit 1; fi

check:
	$(OPA) check --strict .

test:
	$(OPA) test -b . -v

integration:
	python3 test/integration.py

base:
	./run.sh --spec-root $(SPEC_ROOT) --code-root $(CODE_ROOT) --scope own

change:
	./run.sh --spec-root $(SPEC_ROOT) --code-root $(CODE_ROOT) \
	  --ref $(REF) --base-ref $(BASE_REF) --change $(CHANGE) \
	  --diff-base $(DIFF_BASE) --diff-head $(DIFF_HEAD) --scope own

lint:
	@command -v regal >/dev/null 2>&1 && regal lint --format pretty . \
	  || echo "regal is not installed; skipping"

all: fmt-check check test integration
