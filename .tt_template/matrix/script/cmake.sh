#!/bin/bash
build_type=${1:-Debug}
build_dir=build/gcc/$build_type

if [[ -n $CXX || -n $CC ]]; then
    cxx_compiler=${CXX:-c++}
    if [[ $cxx_compiler = *clang* ]]; then
        build_dir=build/clang
    fi
fi

cd "$(realpath "${BASH_SOURCE[0]%/*}")/.."

sourceDir="$(pwd)"

(
cd "$build_dir" && \
       cmake \
         -DCMAKE_CXX_FLAGS:STRING= \
         -DCMAKE_BUILD_TYPE:STRING="$build_type" \
         -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOLEAN=ON \
         "$sourceDir"
)

ln -fs "$build_dir"/compile_commands.json compile_commands.json
