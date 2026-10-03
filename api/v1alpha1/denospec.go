package v1alpha1

import "github.com/publicdomainrelay/kcp-libs/common/denospec"

// The CRD declarations above are the wire contract and stay as written: the
// library's copies are pinned to them by contract test. These conversions are
// where the two shapes meet for the fields the provider actually hands to the
// library, so a renamed or dropped field fails to compile here rather than
// silently changing a deno argv. A conversion is added when a caller needs one;
// the CRD's other declarations are read directly.

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

func (s *ServiceAccountRef) DenoSpec() *denospec.ServiceAccountRef {
	if s == nil {
		return nil
	}
	return &denospec.ServiceAccountRef{Name: s.Name, Namespace: s.Namespace}
}
