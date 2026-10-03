package main

import (
	"context"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	"github.com/johnandersen777/deno-kcp/internal/provider"
	"github.com/publicdomainrelay/kcp-libs/abc/runner"
	"github.com/publicdomainrelay/kcp-libs/impl/execrunner"
)

type config struct {
	kubeconfig string

	host string

	runsDir string

	policyEngineDir string

	bundledActionsDir string

	denoBin string

	podTimeout time.Duration

	tokenTTL time.Duration

	metricsListen string

	runTTLSeconds int64

	writeStatus bool

	serviceDomain string

	openBaoAddr string

	openBaoToken string

	openBaoCACert string

	openBaoMount string

	openBaoRole string

	openBaoIntermediateTTL string

	openBaoLeafTTL string
}

func main() {
	// ponytail: kcp's APIExport virtual workspace does not send the bookmark a
	// streaming list needs, so an informer's initial list never completes and the
	// provider sits with no cache and reconciles nothing. The symptom is a
	// provider that looks healthy and a workload that never gets a status, and it
	// bites hardest on an empty workspace where there is no event to end the list
	// for it. client-go's Gates interface is read-only and reads this from the
	// environment on first use, so it is set here, before any client-go call,
	// rather than requiring an operator to know the variable.
	os.Setenv("KUBE_FEATURE_WatchListClient", "false")

	cfg := config{}
	flag.StringVar(&cfg.kubeconfig, "kubeconfig", envOr("KUBECONFIG", ""),
		"path to the kcp admin kubeconfig")
	flag.StringVar(&cfg.host, "host", envOr("KCP_HOST", ""),
		"kcp API server base URL, overriding the kubeconfig's server")
	flag.StringVar(&cfg.runsDir, "runs-dir", envOr("RUNS_DIR", "runs"),
		"directory for run artifacts (workflow.json, console.txt)")
	flag.StringVar(&cfg.policyEngineDir, "policy-engine-dir",
		envOr("POLICY_ENGINE_DIR", "../policy-engine/lib/policy-engine-server-gha-lite"),
		"directory holding the policy engine gha-lite server main.ts")
	flag.StringVar(&cfg.bundledActionsDir, "bundled-actions-dir",
		envOr("BUNDLED_ACTIONS_DIR", ""),
		"directory holding the policy engine's bundled actions")
	flag.StringVar(&cfg.denoBin, "deno-bin", envOr("DENO_BIN", "deno"), "deno binary")
	flag.DurationVar(&cfg.podTimeout, "pod-timeout", 5*time.Minute, "per-deno-process timeout")
	flag.DurationVar(&cfg.tokenTTL, "token-ttl", time.Hour, "service account token lifetime")
	flag.StringVar(&cfg.metricsListen, "metrics-listen", envOr("METRICS_LISTEN", ""),
		"address for the Prometheus metrics endpoint, empty disables it")
	flag.Int64Var(&cfg.runTTLSeconds, "run-ttl-seconds", envOrInt64("RUN_TTL_SECONDS", 3600),
		"default TTL for policy workflow runs in seconds (negative disables)")
	flag.BoolVar(&cfg.writeStatus, "write-status", true, "write status to kcp")
	flag.StringVar(&cfg.serviceDomain, "service-domain", envOr("KCP_SERVICE_DOMAIN", "kcp.local"),
		"cluster domain for the <name>.<namespace>.<workspace>.svc.<domain> names workloads resolve")
	flag.StringVar(&cfg.openBaoAddr, "openbao-addr", envOr("OPENBAO_ADDR", ""),
		"OpenBao server address, e.g. http://127.0.0.1:8200; empty leaves workloads serving plain HTTP")
	flag.StringVar(&cfg.openBaoToken, "openbao-token", envOr("OPENBAO_TOKEN", ""),
		"token the provider operates OpenBao with")
	flag.StringVar(&cfg.openBaoCACert, "openbao-ca-cert", envOr("OPENBAO_CACERT", ""),
		"PEM CA certificate that signs the OpenBao listener's certificate, for an https address")
	flag.StringVar(&cfg.openBaoMount, "openbao-mount", envOr("OPENBAO_MOUNT", "pki"),
		"PKI mount each namespace carries")
	flag.StringVar(&cfg.openBaoRole, "openbao-role", envOr("OPENBAO_ROLE", "denopod"),
		"PKI role leaves are issued through")
	flag.StringVar(&cfg.openBaoIntermediateTTL, "openbao-intermediate-ttl", envOr("OPENBAO_INTERMEDIATE_TTL", "43800h"),
		"lifetime of a namespace's intermediate CA")
	flag.StringVar(&cfg.openBaoLeafTTL, "openbao-leaf-ttl", envOr("OPENBAO_LEAF_TTL", "720h"),
		"lifetime of a workload's serving certificate")
	flag.Parse()

	if cfg.kubeconfig == "" {
		fmt.Fprintln(os.Stderr, "deno-kcp-provider: --kubeconfig or KUBECONFIG is required")
		os.Exit(2)
	}
	if cfg.bundledActionsDir == "" {
		cfg.bundledActionsDir = cfg.policyEngineDir + "/../policies/gha-lite/bundled-actions"
	}

	log := slog.New(slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: slog.LevelInfo}))

	restCfg, err := clientcmd.BuildConfigFromFlags("", cfg.kubeconfig)
	if err != nil {
		log.Error("loading kubeconfig", "err", err)
		os.Exit(1)
	}
	host := restCfg.Host
	if cfg.host != "" {
		host = cfg.host
	}

	registry, err := provider.NewRegistry(provider.RegistryOptions{Host: host, RestConfig: restCfg})
	if err != nil {
		log.Error("building registry", "err", err)
		os.Exit(1)
	}

	run, err := execrunner.NewEngine(execrunner.EngineOptions{
		DenoBin:   cfg.denoBin,
		ServerDir: cfg.policyEngineDir,
		RunsDir:   cfg.runsDir,
	})
	if err != nil {
		log.Error("building engine runner", "err", err)
		os.Exit(1)
	}

	// ponytail: the bundle is a function rather than a value because the OpenBao
	// root CA does not exist until a namespace has asked for a certificate, and
	// the provider that generates it is built from this runner.
	var providerImpl *provider.Provider
	var podRunner runner.PodRunner
	execPod, err := execrunner.NewPod(execrunner.PodOptions{
		DenoBin: cfg.denoBin,
		RunsDir: cfg.runsDir,
		Timeout: cfg.podTimeout,
		TrustBundle: func() []byte {
			if providerImpl == nil {
				return caData(restCfg)
			}
			return providerImpl.TrustBundle()
		},
	})
	if err != nil {
		log.Error("building exec pod runner", "err", err)
		os.Exit(1)
	}
	podRunner = execPod

	providerImpl, err = provider.New(provider.Options{
		Registry:               registry,
		PolicyClient:           provider.NewHTTPPolicyClient(),
		Runtime:                registry,
		RestConfig:             restCfg,
		Minter:                 registry,
		PodRunner:              podRunner,
		EngineRunner:           run,
		Host:                   host,
		TokenTTL:               cfg.tokenTTL,
		BundledActionsDir:      cfg.bundledActionsDir,
		MetricsListen:          cfg.metricsListen,
		DefaultRunTTLSeconds:   defaultRunTTL(cfg.runTTLSeconds),
		WriteStatus:            cfg.writeStatus,
		RunsDir:                cfg.runsDir,
		ServiceDomain:          cfg.serviceDomain,
		OpenBaoAddress:         cfg.openBaoAddr,
		OpenBaoToken:           cfg.openBaoToken,
		OpenBaoCACert:          readIfSet(log, cfg.openBaoCACert),
		OpenBaoMount:           cfg.openBaoMount,
		OpenBaoRole:            cfg.openBaoRole,
		OpenBaoIntermediateTTL: cfg.openBaoIntermediateTTL,
		OpenBaoLeafTTL:         cfg.openBaoLeafTTL,
		Log:                    log,
	})
	if err != nil {
		log.Error("building provider", "err", err)
		os.Exit(1)
	}

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	if err := providerImpl.Run(ctx); err != nil {
		log.Error("provider stopped", "err", err)
		os.Exit(1)
	}
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func envOrInt64(key string, fallback int64) int64 {
	if v := os.Getenv(key); v != "" {
		if n, err := strconv.ParseInt(v, 10, 64); err == nil {
			return n
		}
	}
	return fallback
}

func defaultRunTTL(seconds int64) *int64 {
	if seconds < 0 {
		return nil
	}
	v := seconds
	return &v
}

func caData(cfg *rest.Config) []byte {
	if len(cfg.CAData) > 0 {
		return cfg.CAData
	}
	if cfg.CAFile != "" {
		if body, err := os.ReadFile(cfg.CAFile); err == nil {
			return body
		}
	}
	return nil
}

// readIfSet reads a PEM file a flag named, and answers nil rather than failing
// when it does not: a certificate that cannot be read is one the TLS handshake
// will refuse, which is a clearer report than a provider that will not start.
// The refusal is only clear if it is said out loud, though -- a mistyped path
// otherwise surfaces as every reconcile failing to verify the vault's
// certificate -- so the read failure is logged where the flag is read.
func readIfSet(log *slog.Logger, path string) []byte {
	if path == "" {
		return nil
	}
	body, err := os.ReadFile(path)
	if err != nil {
		log.Warn("openbao: the CA certificate the flag names could not be read, so an https vault will not be trusted", "path", path, "err", err)
		return nil
	}
	return body
}
