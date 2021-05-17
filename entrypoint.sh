#!/bin/sh -l

echo "Hello Benoit $1"
time=$(date)

#echo "TMC Login"
#tmc login --no-configure --name gitops
cd /github/workspace

echo "============ IN  /github/workspace"
find . -ls
echo "============ OUT /github/workspace"

echo "============ Apply.sh"
/usr/src/app/apply.sh 
echo "============ /Apply.sh"

echo "::set-output name=time::$time"