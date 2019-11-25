#!/bin/bash

if [[ ! -d libev ]]; then
    git clone https://github.com/enki/libev
fi

if [[ ! -d libptytty ]]; then
    git clone https://github.com/yusiwen/libptytty
fi

./configure \
    --enable-unicode3=off \
    --enable-256-color
