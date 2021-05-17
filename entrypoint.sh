#!/bin/sh -l

echo "Hello Benoit $1"
time=$(date)

export TMC_API_TOKEN=$2
echo "TMC Login with TMC_API_TOKEN ${TMC_API_TOKEN}"
tmc login --no-configure --name gitops

echo "Move to /github/workspace"
cd /github/workspace

echo "============ IN  /github/workspace"
find . -ls
echo "============ OUT /github/workspace"

echo "============ Apply.sh"
/usr/src/app/apply.sh 
echo "============ /Apply.sh"

echo "::set-output name=time::$time"