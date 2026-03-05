# Validating Compositions

The Crossplane CLI [`beta validate`](https://docs.crossplane.io/latest/cli/command-reference/#beta-validate)
can be used to validate resource schemas.

One nice feature of this command is that it can download CRDs
from Configuration and Provider packages automatically into a
local cache.

The basic syntax of the command is `crossplane beta validate schemas resources`.

## Validating a Composition

We'll validate the Upbound [configuration-aws-network](https://github.com/upbound/configuration-aws-network/tree/main/apis) Composition.
This Composition contains a number of EC2 network resources, with
sample observed state in the [observed](observed) directory so
that `crossplane render` can utilize status.

## Validating against Schemas

The [schemas](schemas) directory contains a `provider.yaml` file.
`crossplane beta validate` will download CRDs from the provider
and store the CRDs under a local cache directory,
by default `.crossplane/cache`

The schemas directory can contain CRD YAML files or Crossplane configuration
packages.

## Using Crossplane render with Validate

Now we can validate the output of `crossplane render` using our Schema
and Observed resources:

```shell
crossplane render \
  --observed-resources observed \
  --include-full-xr \
  --xrd=definition.yaml \
  xr.yaml composition.yaml functions.yaml  | crossplane beta validate schemas -
```

The first time you run the command, it will download CRDs from the
schemas directory:

```shell
$ crossplane render \
  --observed-resources observed \
  --include-full-xr \
  xr.yaml composition.yaml functions.yaml  | crossplane beta validate schemas -
package schemas does not exist, downloading:  xpkg.upbound.io/upbound/provider-aws-ec2:v2.4.0
 crossplane render \
  --observed-resources observed \
  --include-full-xr \
  --xrd=definition.yaml \
  xr.yaml composition.yaml functions.yaml  | crossplane beta validate schemas -
[!] could not find CRD/XRD for: aws.platform.upbound.io/v1alpha1, Kind=Network
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=InternetGateway, configuration-aws-network-e1f7ae1d4d09 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=MainRouteTableAssociation, configuration-aws-network-d93f43bac41b validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=Route, configuration-aws-network-215548ce6f59 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=RouteTable, configuration-aws-network-72f17771f1d6 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-766287f8af7b validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-9b710048ae71 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-2e89937b5bd6 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=RouteTableAssociation, configuration-aws-network-90fbf3497761 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=SecurityGroup, configuration-aws-network-f40a19845fe6 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=SecurityGroupRule, configuration-aws-network-0a3a003d28fd validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=SecurityGroupRule, configuration-aws-network-746fa12e6d72 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-151aa2b76753 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-2ef28615ffd0 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-f48c7994f60e validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=Subnet, configuration-aws-network-346503482372 validated successfully
[✓] ec2.aws.m.upbound.io/v1beta1, Kind=VPC, configuration-aws-network-efaa264d4a75 validated successfully
Total 17 resources: 1 missing schemas, 16 success cases, 0 failure cases
```
