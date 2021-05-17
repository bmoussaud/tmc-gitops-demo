#!/bin/sh -l

echo "Hello Benoit $1"
time=$(date)

#echo "TMC Login"
#tmc login --no-configure --name gitops

echo "============ IN  /github/workspace"
find /github/workspace
echo "============ OUT /github/workspace"

cd /github/workspace
echo "============ Apply.sh"
/usr/src/app/apply.sh 

echo "::set-output name=time::$time"