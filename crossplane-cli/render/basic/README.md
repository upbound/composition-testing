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
