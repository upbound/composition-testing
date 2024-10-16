# Mocking Cluster Data

This example shows various ways of Mocking data for the Composition.

Context can come from the built-in alpha [Environment Configurations](https://docs.crossplane.io/latest/concepts/environment-configs/). Note that as
an alpha feature, the built-in Environment Configurations is likely to be
deprecated in favor of using Composition Functions with Extra Resources.

[Extra Resources](https://github.com/crossplane/crossplane/blob/master/design/design-doc-composition-functions-extra-resources.md) are a new feature in Crossplane 1.16, allowing
Functions to get access to any cluster-scoped resource Crossplane
already has access to. This allows Composition authors to look up
any other Resource on a Crossplane cluster.

Directories:

- `context`: a JSON file of Context data available to the Function
- `extra-resources`: Includes Extra Resources available to the function
- `observed`: Mock Existing Cluster Resources to use for `status`

To render run the following:

```shell
crossplane render \
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

## Using Context with Crossplane Render

Data from the Environment and Extra resources is available under `context`
to the function, with a map key like `apiextensions.crossplane.io/extra-resources`
indicating the source of the data. Extra-resources are populated as an array
of items. Each item can be of a different Kind.

When running `crossplane render`, you can specify the key using the
`--context-files` option. The data must be in JSON format.

```shell
--context-files="apiextensions.crossplane.io/environment"=environment/dev.json
```

Once populated, to access context data in a go-template use the key
`apiextensions.crossplane.io/environment`.

```go
 {{- $env := index .context "apiextensions.crossplane.io/environment" -}}
```

## Using Extra Resources with Crossplane Render

Extra resources can by any Crossplane type, from `EnvironmentConfig`s,
other Composites (like `XCluster`), or Managed Resources. The manifests
can be stored in a directory like [extra-resources](extra-resources),
and made available to `crossplane render` using the `--extra-resources` argument.

Extra resources are available to the function, but not all functions have been
updated to support them. For example, it was recently merged into [function-go-templating](https://github.com/crossplane-contrib/function-go-templating/pull/83).

If a function doesn't support them natively, [function-extra-resources](https://github.com/crossplane-contrib/function-extra-resources/tree/main) can be used to populate the Context under the key `apiextensions.crossplane.io/extra-resources`.
