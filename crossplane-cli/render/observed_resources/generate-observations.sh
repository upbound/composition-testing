#!/bin/sh

set -eu

# This script can be used to generate observed resources from a crossplane composite, 
# which can be used with the `crossplane render` command.
# 
# It uses the crossplane.io/composite label to match all the Composed resources on 
# the Crossplane cluster for a given Composite or Claim. To generate the observations:
#
# 1. Get the composite:
# 
# kubectl get composite 
#
# 2. Run ./generate-observations.sh <composite>



usage(){
printf "Please provide a composite resource.

kubectl get composite

Then run $0 <composite>
"
}

if [[ $# -ne 1 ]]; then 
  usage
  exit -1 
fi

composite=$1
outdir=observed

composed=$(kubectl get managed  -l crossplane.io/composite=${composite} --no-headers -o name)

mkdir -p ${outdir}

for cr in $composed; do
    echo "Saving ${cr}"
    # remove / from filename 
    file=${cr//\//-}
    kubectl get $cr -o yaml > ${outdir}/$file.yaml
done

