#!/bin/bash

find . -depth  \
    '(' \
    -name "CMakeFiles"  \
    -o -name "compile_commands.json" \
    -o -name 'Makefile' \
    -o -name 'CmakeCache.txt' \
    -o -name 'cmake_install.cmake' \
    ')'  \
    ! -path './build/*' \
    -exec rm -rf "{}" +
