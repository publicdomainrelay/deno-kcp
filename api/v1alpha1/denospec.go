package v1alpha1

import "github.com/publicdomainrelay/kcp-libs/common/denospec"

// The CRD declarations above are the wire contract and stay as written: the
// library's copies are pinned to them by contract test. These conversions are
// the one place the two shapes meet, so a field added to either side fails to
// compile here rather than silently dropping out of a deno argv.

func (p *DenoPermissions) DenoSpec() *denospec.Permissions {
	if p == nil {
		return nil
	}
	return &denospec.Permissions{
		All:          p.All,
		NoPrompt:     p.NoPrompt,
		HRTime:       p.HRTime,
		Read:         p.Read.denoSpec(),
		Write:        p.Write.denoSpec(),
		Net:          p.Net.denoSpec(),
		Env:          p.Env.denoSpec(),
		Run:          p.Run.denoSpec(),
		FFI:          p.FFI.denoSpec(),
		Sys:          p.Sys.denoSpec(),
		Import:       p.Import.denoSpec(),
		IgnoreEnv:    p.IgnoreEnv.denoSpec(),
		AllowScripts: p.AllowScripts,
	}
}

func (p *DenoPermission) denoSpec() *denospec.Permission {
	if p == nil {
		return nil
	}
	return &denospec.Permission{
		Allow:     p.Allow,
		AllowList: p.AllowList,
		Deny:      p.Deny,
		DenyList:  p.DenyList,
	}
}

func (t *DenoPodTemplate) DenoSpec() *denospec.PodTemplate {
	if t == nil {
		return nil
	}
	return &denospec.PodTemplate{
		DenoJSON:       t.DenoJSON,
		DenoLock:       t.DenoLock,
		Script:         t.Script,
		Permissions:    t.Permissions.DenoSpec(),
		ServiceAccount: t.ServiceAccount.DenoSpec(),
		APIServer:      t.APIServer,
		Env:            t.Env,
	}
}

func (s *ServiceAccountRef) DenoSpec() *denospec.ServiceAccountRef {
	if s == nil {
		return nil
	}
	return &denospec.ServiceAccountRef{Name: s.Name, Namespace: s.Namespace}
}

func (p *ExecProbe) DenoSpec() *denospec.ExecProbe {
	if p == nil {
		return nil
	}
	return &denospec.ExecProbe{
		Command:          p.Command,
		PeriodSeconds:    p.PeriodSeconds,
		FailureThreshold: p.FailureThreshold,
		TimeoutSeconds:   p.TimeoutSeconds,
	}
}

func (r DenoRestartPolicy) DenoSpec() denospec.RestartPolicy {
	return denospec.RestartPolicy(r)
}
