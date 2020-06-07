#!/bin/bash

set -eu -o pipefail
shopt -s failglob

./configure \
    --enable-unicode3=off \
    --enable-256-color
