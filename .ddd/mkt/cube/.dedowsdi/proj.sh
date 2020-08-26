#!/usr/bin/env bash

export CPP_BUILD_TYPE=${CPP_BUILD_TYPE:-Debug}
export CPP_BUILD_DIR=build/$(mycpp -b)/$CPP_BUILD_TYPE
export OSG_FILE_PATH="$(pwd)/data:$OSG_FILE_PATH"
export OSG_NOTIFY_LEVEL=INFO

vim --cmd 'set exrc' +/main +'norm! zz' main.cpp
