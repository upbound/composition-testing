# composition-testing

This repository contains examples for testing Crossplane Compositions.

## Using the Crossplane CLI

Note that in Crossplane 1.17 (late August 2024), `crossplane beta render` will graduate to `crossplane render`.

The following examples use the Crossplane [CLI](https://docs.crossplane.io/latest/cli/):

- [crossplane-cli](crossplane-cli)
  - [render](crossplane-cli/render/render) using `crossplane render` to generate and validate Compositions.
    - [basic](crossplane-cli/render/basic/) basic rendering
    - [observed_data](crossplane-cli/render/observed_data/) simulating existing resources
    - [extra_resources](crossplane-cli/render/extra_resources/) including Extra Resources
  - [validate](crossplane-cli/validate) using `crossplane beta validate` to validate Compositions.
