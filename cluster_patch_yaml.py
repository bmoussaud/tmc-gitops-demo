#!/usr/bin/env python3

import yaml
import sys

input_yaml = sys.argv[1]
resource_version = sys.argv[2]
output_yaml = sys.argv[3]
print(f"{input_yaml} -> {resource_version} -> {output_yaml}")
with open(input_yaml) as f:
    data = yaml.load(f, Loader=yaml.FullLoader)
    print(data)
    data['meta']['resourceVersion'] = resource_version

with open(output_yaml, 'w') as fout:
    yaml.dump(data, fout)
