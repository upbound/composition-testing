# Rendering Compositions with the Crossplane CLI

[`crossplane beta render`](https://docs.crossplane.io/latest/cli/command-reference/#beta-render)
can be used to preview the output of a Composition.

To use `crossplane beta render`, we need 3 files:

- [`xr.yaml`](xr.yaml) A Composite resource
- [`composition.yaml`](composition.yaml) the Composition to render
- [`functions.yaml`](functions.yaml) A list of Functions used

To render, run:

```shell
crossplane beta render xr.yaml composition.yaml functions.yaml
```

You should see:

1. The Composite Resource (XR) `XTenant`
2. 3 `Object`s that represent Kubernetes resources.

```shell
$ crossplane beta render xr.yaml composition.yaml functions.yaml
---
apiVersion: k8s.example.com/v1alpha1
kind: XTenant
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
apiVersion: kubernetes.crossplane.io/v1alpha2
kind: Object
metadata:
  annotations:
    crossplane.io/composition-resource-name: namespace-team-1
  generateName: example-
  labels:
    crossplane.io/composite: example
  ownerReferences:
    - apiVersion: k8s.example.com/v1alpha1
      blockOwnerDeletion: true
      controller: true
      kind: XTenant
      name: example
      uid: ""
spec:
  forProvider:
    manifest:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: team-1
---
apiVersion: kubernetes.crossplane.io/v1alpha2
kind: Object
metadata:
  annotations:
    crossplane.io/composition-resource-name: namespace-team-2
  generateName: example-
  labels:
    crossplane.io/composite: example
  ownerReferences:
    - apiVersion: k8s.example.com/v1alpha1
      blockOwnerDeletion: true
      controller: true
      kind: XTenant
      name: example
      uid: ""
spec:
  forProvider:
    manifest:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: team-2
---
apiVersion: kubernetes.crossplane.io/v1alpha2
kind: Object
metadata:
  annotations:
    crossplane.io/composition-resource-name: namespace-team-3
  generateName: example-
  labels:
    crossplane.io/composite: example
  ownerReferences:
    - apiVersion: k8s.example.com/v1alpha1
      blockOwnerDeletion: true
      controller: true
      kind: XTenant
      name: example
      uid: ""
spec:
  forProvider:
    manifest:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: team-3

```

Open the [`xr.yaml`](xr.yaml) file, and change the list in `spec.teams`.
What happens when you run `crossplane render` again?

```yaml
apiVersion: k8s.example.com/v1alpha1
kind: XTenant
metadata:
  name: example
spec:
  teams:
    - team-1
    - team-2
    - team-3
```

## Missing Status

One issue is the `status` of the `XTenant` Composite is not populated with 
any data. How can we be sure our Composition's status updates are working correctly?

```yaml
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
```

The [`observed_resources`](../observed_resources/) example will show how to simulate live resources with `crossplane render.`
