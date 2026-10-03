package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// OpenBao binds a Kubernetes namespace to an OpenBao namespace that holds a
// certificate authority for it.
//
// The object is hand-written rather than derived from a workload because the
// authority is a thing an operator has to be able to see and to exist before the
// first workload asks for a certificate: a DenoPod that serves TLS is issued from
// the authority of the namespace it is in, and a namespace with no OpenBao object
// has no authority to be issued from.
type OpenBao struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   OpenBaoSpec   `json:"spec,omitempty"`
	Status OpenBaoStatus `json:"status,omitempty"`
}

type OpenBaoList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`

	Items []OpenBao `json:"items"`
}

type OpenBaoSpec struct {
	// Namespace is the OpenBao namespace this Kubernetes namespace is served by,
	// for example alice.default. It is named rather than derived so that the path
	// a workload is issued from is readable in the object rather than implied by
	// the workspace it sits in, and so that a reorganisation of workspace paths
	// does not silently move every authority.
	Namespace string `json:"namespace"`
}

type OpenBaoStatus struct {
	Namespace string `json:"namespace,omitempty"`

	Serial string `json:"serial,omitempty"`

	// Chain is the PEM chain from this namespace's intermediate up to the root,
	// which is what a peer needs to verify a leaf issued here. The root itself is
	// not a secret and this is how a caller reads it.
	Chain string `json:"chain,omitempty"`

	Ready bool `json:"ready,omitempty"`

	Message string `json:"message,omitempty"`

	Conditions []metav1.Condition `json:"conditions,omitempty"`
}

const (
	FinalizerOpenBao = "openbao.deno.computer/namespace"

	// OpenBaoConditionReady is true when the namespace exists, holds an
	// intermediate signed by the root, and carries the role leaves are issued from.
	OpenBaoConditionReady = "Ready"

	// OpenBaoConditionAmbiguous is true when more than one OpenBao object names the
	// same Kubernetes namespace, which leaves a workload with no way to tell which
	// authority it should be issued from.
	OpenBaoConditionAmbiguous = "Ambiguous"
)
