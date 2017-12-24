#!/bin/bash
#build symbolic if it doesn't exits
if [ $# -lt 2 ] ; then
    echo "wrong arg number, excepted format is buildSymbolicLink file link"
    exit 1
fi

fileName=$1
linkName=$2

echo build symbolic link : "${linkName}"'->'"${fileName}"
ln -fs "$fileName" "$linkName"
exit $?
