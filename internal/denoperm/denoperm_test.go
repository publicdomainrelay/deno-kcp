package denoperm

import (
	"reflect"
	"testing"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func TestArgsModelsEveryFlagForm(t *testing.T) {
	p := &v1alpha1.DenoPermissions{
		Read:     &v1alpha1.DenoPermission{Allow: true},
		Write:    &v1alpha1.DenoPermission{AllowList: []string{"./", "./tmp"}},
		Net:      &v1alpha1.DenoPermission{AllowList: []string{"example.com:443"}, DenyList: []string{"evil.com"}},
		Env:      &v1alpha1.DenoPermission{Allow: true, DenyList: []string{"AWS_SECRET_ACCESS_KEY"}},
		Run:      &v1alpha1.DenoPermission{AllowList: []string{"curl", "whoami"}},
		FFI:      &v1alpha1.DenoPermission{Deny: true},
		Sys:      &v1alpha1.DenoPermission{AllowList: []string{"systemMemoryInfo", "osRelease"}},
		Import:   &v1alpha1.DenoPermission{DenyList: []string{"esm.sh"}},
		NoPrompt: true,
		HRTime:   true,
	}
	got, err := Args(p)
	if err != nil {
		t.Fatal(err)
	}
	want := []string{
		"--allow-hrtime",
		"--allow-read",
		"--allow-write=./,./tmp",
		"--allow-net=example.com:443",
		"--deny-net=evil.com",
		"--allow-env",
		"--deny-env=AWS_SECRET_ACCESS_KEY",
		"--allow-run=curl,whoami",
		"--deny-ffi",
		"--allow-sys=systemMemoryInfo,osRelease",
		"--deny-import=esm.sh",
		"--no-prompt",
	}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("args =\n%v\nwant\n%v", got, want)
	}
}

func TestAllowAllShortCircuits(t *testing.T) {
	got, err := Args(&v1alpha1.DenoPermissions{All: true, Read: &v1alpha1.DenoPermission{Allow: true}})
	if err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(got, []string{"-A"}) {
		t.Fatalf("args = %v, want [-A]", got)
	}
}

func TestDenyWithoutAListIsBare(t *testing.T) {
	got, err := Args(&v1alpha1.DenoPermissions{Read: &v1alpha1.DenoPermission{Deny: true}})
	if err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(got, []string{"--deny-read"}) {
		t.Fatalf("args = %v, want [--deny-read]", got)
	}
}

func TestIgnoreEnvAndAllowScripts(t *testing.T) {
	got, err := Args(&v1alpha1.DenoPermissions{
		IgnoreEnv:    &v1alpha1.DenoPermission{AllowList: []string{"PORT", "HOME"}},
		AllowScripts: []string{"esbuild"},
	})
	if err != nil {
		t.Fatal(err)
	}
	want := []string{"--ignore-env=PORT,HOME", "--allow-scripts=esbuild"}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("args = %v, want %v", got, want)
	}
}

func TestCommaValueIsRejected(t *testing.T) {
	if _, err := Args(&v1alpha1.DenoPermissions{Read: &v1alpha1.DenoPermission{AllowList: []string{"a,b"}}}); err == nil {
		t.Fatal("a comma in a permission value should be rejected")
	}
}

func TestNilIsNoFlags(t *testing.T) {
	got, err := Args(nil)
	if err != nil {
		t.Fatal(err)
	}
	if len(got) != 0 {
		t.Fatalf("args = %v, want none", got)
	}
}
