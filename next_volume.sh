#!/bin/bash

prefix=${1}
temp_directory=${2}
n="0000"
while [[ -e "${temp_directory}/${prefix}.tar.${n}" ]]; do
  n=$(printf %04d $((10#${n}+1)))
done
mv "${prefix}.tar" "${temp_directory}/${prefix}.tar.${n}"

