crossplane render \
  --extra-resources extra-resources \
  --observed-resources observed \
  --context-files="apiextensions.crossplane.io/environment"=environment/dev.json \
  --include-full-xr \
  --include-context \
  --xrd=xrd.yaml \
  xr.yaml composition.yaml functions.yaml

