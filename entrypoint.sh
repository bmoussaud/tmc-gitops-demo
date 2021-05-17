#!/bin/sh -l

echo "Hello $1"
time=$(date)

echo "============ IN  /github/workspace"
find /github/workspace
echo "============ OUT /github/workspace"
echo "::set-output name=time::$time"