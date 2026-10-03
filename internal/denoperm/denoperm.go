package denoperm

import (
	"errors"
	"fmt"
	"strings"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

var capabilityFlags = []struct {
	name string

	permission func(*v1alpha1.DenoPermissions) *v1alpha1.DenoPermission
}{
	{"read", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.Read }},
	{"write", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.Write }},
	{"net", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.Net }},
	{"env", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.Env }},
	{"run", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.Run }},
	{"ffi", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.FFI }},
	{"sys", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.Sys }},
	{"import", func(p *v1alpha1.DenoPermissions) *v1alpha1.DenoPermission { return p.Import }},
}

func Validate(p *v1alpha1.DenoPermissions) error {
	if p == nil {
		return nil
	}
	for _, c := range capabilityFlags {
		if err := validatePermission(c.name, c.permission(p)); err != nil {
			return err
		}
	}
	if p.IgnoreEnv != nil {
		if p.IgnoreEnv.Allow || p.IgnoreEnv.Deny {
			return errors.New("denoperm: ignoreEnv takes only an allowList, not allow or deny")
		}
		if err := validateValues("ignoreEnv", p.IgnoreEnv.AllowList); err != nil {
			return err
		}
	}
	if err := validateValues("allowScripts", p.AllowScripts); err != nil {
		return err
	}
	return nil
}

func validatePermission(capability string, p *v1alpha1.DenoPermission) error {
	if p == nil {
		return nil
	}
	if err := validateValues(capability+" allowList", p.AllowList); err != nil {
		return err
	}
	return validateValues(capability+" denyList", p.DenyList)
}

func validateValues(what string, values []string) error {
	for _, v := range values {
		if v == "" {
			return fmt.Errorf("denoperm: %s holds an empty value", what)
		}
		if strings.Contains(v, ",") {
			return fmt.Errorf("denoperm: %s value %q holds a comma; Deno separates values with commas", what, v)
		}
	}
	return nil
}

func Args(p *v1alpha1.DenoPermissions) ([]string, error) {
	if err := Validate(p); err != nil {
		return nil, err
	}
	if p == nil {
		return nil, nil
	}
	if p.All {
		return []string{"-A"}, nil
	}
	var args []string
	if p.HRTime {
		args = append(args, "--allow-hrtime")
	}
	for _, c := range capabilityFlags {
		args = append(args, permissionArgs("--allow-"+c.name, c.permission(p), false)...)
		args = append(args, permissionArgs("--deny-"+c.name, c.permission(p), true)...)
	}
	if p.IgnoreEnv != nil && len(p.IgnoreEnv.AllowList) > 0 {
		args = append(args, "--ignore-env="+strings.Join(p.IgnoreEnv.AllowList, ","))
	}
	if len(p.AllowScripts) > 0 {
		args = append(args, "--allow-scripts="+strings.Join(p.AllowScripts, ","))
	}
	if p.NoPrompt {
		args = append(args, "--no-prompt")
	}
	return args, nil
}

func permissionArgs(flag string, perm *v1alpha1.DenoPermission, deny bool) []string {
	if perm == nil {
		return nil
	}
	if deny {
		if perm.Deny {
			return []string{flag}
		}
		if len(perm.DenyList) > 0 {
			return []string{flag + "=" + strings.Join(perm.DenyList, ",")}
		}
		return nil
	}
	if perm.Allow {
		return []string{flag}
	}
	if len(perm.AllowList) > 0 {
		return []string{flag + "=" + strings.Join(perm.AllowList, ",")}
	}
	return nil
}
