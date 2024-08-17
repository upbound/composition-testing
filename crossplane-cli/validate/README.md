# Validating Compositions

The Crossplane CLI [`beta validate`](https://docs.crossplane.io/latest/cli/command-reference/#beta-validate) can be used to validate
resource schemas.

One nice feature of this command is that it can download CRDs
from Configuration and Provider packages automatically into a
local cache.

## Validating a Composition

We'll validate the Upbound [configuration-aws-network](https://github.com/upbound/configuration-aws-network/tree/main/apis) Composition.
This Composition contains a number of EC2 network resources, with
sample observed state in the [observed](observed) directory so
that `crossplane render` can utilize status.

## Validating against Schemas

The [schemas](schemas) directory contains a `configuration.yaml` file.
`crossplane beta validate` will download CRDs from each of the
Configuration's dependencies.

## Using Crossplane Beta Render with Validate

Now we can validate the output of `crossplane render` using our Schema
and Observed resources:

```shell
crossplane beta render \
  --observed-resources observed \
  --include-full-xr \
  xr.yaml composition.yaml functions.yaml  | crossplane beta validate schemas -
```

The first time you run the command, it will download CRDs from the
schemas directory:

```shell
$ crossplane beta render \
  --observed-resources observed \
  --include-full-xr \
  xr.yaml composition.yaml functions.yaml  | crossplane beta validate schemas -
package schemas does not exist, downloading:  xpkg.upbound.io/upbound/configuration-aws-network:v0.15.0
package schemas does not exist, downloading:  xpkg.upbound.io/upbound/provider-aws-ec2:v1.4.0
package schemas does not exist, downloading:  xpkg.upbound.io/crossplane-contrib/function-auto-ready:v0.2.1
package schemas does not exist, downloading:  xpkg.upbound.io/crossplane-contrib/function-go-templating:v0.5.0
[x] schema validation error aws.platform.upbound.io/v1alpha1, Kind=XNetwork, configuration-aws-network : spec.parameters.deletionPolicy: Required value
[x] schema validation error aws.platform.upbound.io/v1alpha1, Kind=XNetwork, configuration-aws-network : spec.parameters.providerConfigName: Required value
[✓] ec2.aws.upbound.io/v1beta1, Kind=InternetGateway, configuration-aws-network-w7nb4 validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=MainRouteTableAssociation, configuration-aws-network-pg888 validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=Route, configuration-aws-network-9n2x8 validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=RouteTable, configuration-aws-network-vbcgd validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-stjtq validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-gfb42 validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-jdqj2 validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-pnvdg validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=SecurityGroup, configuration-aws-network-9m99r validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=SecurityGroupRule, configuration-aws-network-s4pzf validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=SecurityGroupRule, configuration-aws-network-kq5th validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-52h6d validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-phfgs validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-mxxs4 validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-gzzrb validated successfully
[✓] ec2.aws.upbound.io/v1beta1, Kind=VPC, configuration-aws-network-6jtl4 validated successfully
Total 17 resources: 0 missing schemas, 16 success cases, 1 failure cases
crossplane: error: cannot validate resources: could not validate all resources
```

You'll notice two errors. `validate` will compare the Composite
Resource (XR) to the XRD schema. We can either add these values
to the [`xr.yaml`](xr.yaml) file or update our upstream Configuration
to remove the `required` field and use default values instead.

```shell
[x] schema validation error aws.platform.upbound.io/v1alpha1, Kind=XNetwork, configuration-aws-network : spec.parameters.deletionPolicy: Required value
[x] schema validation error aws.platform.upbound.io/v1alpha1, Kind=XNetwork,
```
