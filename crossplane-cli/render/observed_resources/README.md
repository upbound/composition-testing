# Observed Resources

A Composition author often needs data from resources, like the
VPC ID, or the OIDC endpoint of a Kubernetes cluster. Since Composition
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
$ crossplane beta render \
  --observed-resources observed \
  --include-full-xr \
  xr.yaml composition.yaml functions.yaml 
```

The `XTenant` output from render should now have `status` populated:

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
status:
  conditions:
  - lastTransitionTime: "2024-01-01T00:00:00Z"
    reason: Available
    status: "True"
    type: Ready
  namespaces:
    team-1:
      name: example-2z46p
      uid: cb84432f-2ece-4b7d-b698-066ac01ae2c4
    team-2:
      name: example-4bdb9
      uid: a1b9dbf4-91aa-49d9-90d1-4d77c2f8d5fd
    team-3:
      name: example-59mdb
      uid: 5720f9d9-1e66-4a1c-80a6-1a0717f0813b
```

## Optional: Generating Observations from a Crossplane Composite

The [`generate-observations.sh`](generate-observations.sh) script can
extract YAML manifests for all of the Composed resources in a Composite.

Every resource in a Composite shares the `crossplane.io/composite=` Kubernetes
label. This example utilizes provider-kubernetes to create some resources on the
cluster, which we will then use for observed data.

To install provider Kubernetes, apply the following manifests. Note
`providers.yaml` creates a binding to the `cluster-admin` role. Review
`providers.yaml` to ensure the service account is in the right namespace,
`crossplane-system` for Crossplane and `upbound-system` for Upbound UXP.

1. `kubectl apply -f providers.yaml -f functions.yaml`
2. `kubectl apply -f providerconfig.yaml`

Now we can apply the Composition and create resources.

```shell
$ kubectl apply -f xr.yaml
xtenant.k8s.example.com/example created
```

And trace the resources created in the composition. If there are errors,
`kubectl describe` the resource:

```shell
$ crossplane beta trace xtenant.k8s.example.com/example  
NAME                      SYNCED   READY   STATUS
XTenant/example           True     True    Available
├─ Object/example-8zp58   True     True    Available
├─ Object/example-dq5vl   True     True    Available
└─ Object/example-tlxm9   True     True    Available
```

Since we created the Composite directly instead of using a Claim, we use
the composite name `example` with the script:

```shell
$ ./generate-observations.sh example
Saving object.kubernetes.crossplane.io/example-2z46p
Saving object.kubernetes.crossplane.io/example-4bdb9
Saving object.kubernetes.crossplane.io/example-59mdb
```
