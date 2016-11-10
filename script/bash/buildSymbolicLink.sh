#!/bin/bash
#build symbolic if it doesn't exits
if [ $# -lt 2 ] ; then
    echo "wrong arg number, excepted format is buildSymbolicLink file link"
    exit 1
fi

fileName=$1
linkName=$2

if [[ -h $linkName && `readlink $linkName` == $fileName ]]; then
    #do nothing if it already exists
    echo symbolic link ${linkName}'->'${fileName} exists
    exit 0
fi

echo build symbolic link : ${linkName}'->'${fileName}
ln -s $fileName $linkName
exit $?
