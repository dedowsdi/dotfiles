#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "wrong arg number, excepted format is $0 src"
    exit 1
fi

src=$1
cmake -G"Eclipse CDT4 - Unix Makefiles" "$src"
