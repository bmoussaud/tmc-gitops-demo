#!/bin/sh -l

export TMC_API_TOKEN=$1
echo "TMC Login with TMC_API_TOKEN '${TMC_API_TOKEN}'"
tmc login --no-configure --name gitops

echo "Move to /github/workspace"
cd /github/workspace

echo "============ Apply.sh"
/usr/src/app/apply.sh 
echo "============ /Apply.sh"
