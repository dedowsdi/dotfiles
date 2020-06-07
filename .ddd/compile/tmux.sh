#!/usr/bin/env bash

set -o errexit
set -o nounset

sudo apt install libevent-dev libncurses5-dev byacc
./configure
sudo make -j2 install
