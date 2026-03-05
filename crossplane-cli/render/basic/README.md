re# Rendering Compositions with the Crossplane CLI

[`crossplane render`](https://docs.crossplane.io/latest/cli/command-reference/#render)
can be used to preview the output of a Composition.

To use `crossplane render`, we need 3 files:

- [`xr.yaml`](xr.yaml) A Composite resource
- [`composition.yaml`](composition.yaml) the Composition to render
- [`functions.yaml`](functions.yaml) A list of Functions used

To render, run:

```shell
crossplane render --xrd=xrd.yaml xr.yaml composition.yaml functions.yaml
```

You should see:

1. The Composite Resource (XR) `XTenant`
2. 3 `Object`s that represent Kubernetes resources.

```shell
$ crossplane render --xrd=xrd.yaml xr.yaml composition.yaml functions.yaml
---
---
apiVersion: k8s.example.com/v1alpha1
kind: Tenant
metadata:
  name: example
spec:
  teams:
    - team-1
    - team-2
    - team-3
status:
  conditions:
    - lastTransitionTime: "2024-01-01T00:00:00Z"
      message: 'Unready resources: namespace-team-1, namespace-team-2, and namespace-team-3'
      reason: Creating
      status: "False"
      type: Ready
  namespaces:
    team-1: null
    team-2: null
    team-3: null
---
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    crossplane.io/composition-resource-name: namespace-team-1
  labels:
    crossplane.io/composite: example
  name: team-1
  ownerReferences:
    - apiVersion: k8s.example.com/v1alpha1
      blockOwnerDeletion: true
      controller: true
      kind: Tenant
      name: example
      uid: ""
---
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    crossplane.io/composition-resource-name: namespace-team-2
  labels:
    crossplane.io/composite: example
  name: team-2
  ownerReferences:
    - apiVersion: k8s.example.com/v1alpha1
      blockOwnerDeletion: true
      controller: true
      kind: Tenant
      name: example
      uid: ""
---
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    crossplane.io/composition-resource-name: namespace-team-3
  labels:
    crossplane.io/composite: example
  name: team-3
  ownerReferences:
    - apiVersion: k8s.example.com/v1alpha1
      blockOwnerDeletion: true
      controller: true
      kind: Tenant
      name: example
      uid: ""
```

The [`observed_resources`](../observed_resources/) example will show how to simulate live resources with `crossplane render.`
