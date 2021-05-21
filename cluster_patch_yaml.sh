#!/usr/bin/env bash
set -x 

echo "
meta:
  resourceVersion: ${2}
" > /tmp/sample.yaml

yq ea '. as $item ireduce ({}; . * $item )' $1  /tmp/sample.yaml > ${3}
