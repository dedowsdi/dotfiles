#!/bin/bash

set -o errexit
set -o nounset

build_type=${1:-Release}
compiler=${2:-gcc}

cd "$(realpath "${BASH_SOURCE[0]%/*}")/.."

source_dir="$(pwd)"
build_dir="build/$compiler/$build_type"

(
cd "$build_dir" && \
       cmake \
         -DCMAKE_CXX_FLAGS:STRING= \
         -DCMAKE_BUILD_TYPE:STRING="$build_type" \
         -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOLEAN=ON \
         "$source_dir"
)

ln -fs "$build_dir"/compile_commands.json compile_commands.json
