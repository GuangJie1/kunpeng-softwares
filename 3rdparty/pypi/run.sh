#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
software_list=$current_dir/software-list
result_path="/var/run/pypi/"

packages=""
if [[ -f "$software_list" ]]; then
    packages=$(grep -v '^#' "$software_list" | tr '\n' ' ')
    echo -e "Using software-list: ${args}"
else
    echo -e "Warning: software-list not found in $script_dir"
fi

# the result is saved in `result_path`
docker run -d -e RESULT_PATH=${result_path} -v ${result_path}:${result_path} openeuler/pypi:latest $packages
