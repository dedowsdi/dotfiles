#!/bin/bash

set -eu -o pipefail
shopt -s failglob

if [[ ! -d libev ]]; then
    git clone --depth 1 https://github.com/enki/libev
fi

if [[ ! -d libptytty ]]; then
    git clone --depth 1 https://github.com/yusiwen/libptytty
fi

./configure \
    --enable-unicode3=off \
    --enable-256-color
