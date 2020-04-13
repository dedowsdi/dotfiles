#!/usr/bin/env bash

export CPP_BUILD_TYPE=${CPP_BUILD_TYPE:-Debug}
export CPP_BUILD_DIR=build/$(mycpp -b)/$CPP_BUILD_TYPE
export OSG_FILE_PATH="$OSG_FILE_PATH:$(pwd)/data"

export OSG_THREADING=DrawThreadPerContext
# export OSG_THREADING=SingleThreaded

vim +/main +'norm! zz' src/main.cpp
