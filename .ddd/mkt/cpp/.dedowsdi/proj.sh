#!/usr/bin/env bash

export CPP_BUILD_DIR=build
export GL_FILE_PATH="$GL_FILE_PATH;$(pwd)/data"

vim --cmd 'set exrc' +/main +'norm! zz' a.cpp
