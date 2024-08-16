# Observed Data

Often times a Composition author needs data from resources, like the
VPC Id, or the OIDC endpoint of a Kubernetes cluster. Since Composition
functions can have access to observed data, we'd like to test things like
one resource referencing the `atProvider` status of another resource.

With `crossplane render`, we can use the `--observed-resources` flag to
simulate existing resources.

To create observed resources for `render`, you can create them
manually or use `kubectl` to extract resources from a Crossplane cluster:

```shell
kubectl get <resource> -o yaml > observed/resource.yaml
```

It's important to note that each observed resource should an
`crossplane.io/composition-resource-name` annotation that matches
a resource in the Composition:

```yaml
metadata:
  annotations:
    crossplane.io/composition-resource-name: namespace-team-1
```

To render use `--observed-resources` flag pointing to a directory
containing Observed resources:

```shell
crossplane beta render \
  --observed-resources observed \
  --include-full-xr \
  xr.yaml composition.yaml functions.yaml 
```
