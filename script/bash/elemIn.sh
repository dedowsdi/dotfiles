#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo wrong arg, is should be $0 item list
    exit 1
fi

elem=$1
list="${@:2}"

for item in $list; do [[ "$item" == "$elem" ]] && exit 0; done
exit 1
