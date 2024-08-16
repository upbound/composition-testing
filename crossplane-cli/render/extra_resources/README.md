# Mocking Cluster Data

This example shows various ways of Mocking data for the Composition.

Context can come from the built-in alpha Environment Configs.

Extra Resources are a new feature in Crossplane 1.16, allowing
Functions to get access to any cluster-scoped resource Crossplane
already has access to. This allows Composition authors to look up
any other Resource on a Crossplane cluster.

Directories:

- `context`: a JSON file of Context data available to the Function
- `extra-resources`: Includes Extra Resources available to the function
- `observed`: Mock Existing Cluster Resources to use for `status`

To render run the following:

```shell
crossplane beta render \
  --extra-resources extra-resources \
  --observed-resources observed \
  --context-files="apiextensions.crossplane.io/environment"=environment/dev.json \
  --include-full-xr \
  --include-context \
  xr.yaml composition.yaml functions.yaml 
```

## Context

`crossplane render` can display all the Context for the function
via the `--include-context` flag. In our example, the legacy
Environment Configs are stored at the `apiextensions.crossplane.io/environment` key,
while extra resources are stored under `apiextensions.crossplane.io/extra-resources`.

```yaml
---
apiVersion: render.crossplane.io/v1beta1
fields:
  apiextensions.crossplane.io/environment:
    complex:
      a: b
      c:
        d: e
        f: "1"
  apiextensions.crossplane.io/extra-resources:
    XCluster:
    - apiVersion: example.crossplane.io/v1
      kind: XCluster
      metadata:
        labels:
          type: cluster
        name: net-staging-blue
      spec:
        compositionRef:
          name: compositecluster.example.crossplane.io
        compositionSelector:
          matchLabels:
            provider: aws
        compositionUpdatePolicy: Automatic
    - apiVersion: example.crossplane.io/v1
      kind: XCluster
      metadata:
        labels:
          type: cluster
        name: net-staging-green
      spec:
        compositionRef:
          name: compositecluster.example.crossplane.io
        compositionSelector:
          matchLabels:
            provider: aws
        compositionUpdatePolicy: Automatic
    - apiVersion: example.crossplane.io/v1
      kind: XCluster
      metadata:
        labels:
          type: cluster
        name: net-staging-yellow
      spec:
        compositionRef:
          name: compositecluster.example.crossplane.io
        compositionSelector:
          matchLabels:
            provider: aws
        compositionUpdatePolicy: Automatic
    envConfs:
    - apiVersion: apiextensions.crossplane.io/v1alpha1
      data:
        accountId: "12345"
        labels:
          businessUnit: sales
          group: webdev
        role: role/dev-provisioner
      kind: EnvironmentConfig
      metadata:
        labels:
          environment: dev
          group: webdev
        name: webdev-dev
kind: Context
```
