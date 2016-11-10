#!/bin/bash
#clone reposity if it doesn't exists
if [ $# -lt 3 ] ; then
    echo "wrong arg number, excepted format is repoClone vsc remote local"
    exit 1
fi

vcs=$1
remote=$2
local=$3

if [[ $vcs != git && $vcs != hg ]]; then
    echo vcs must be git or hg, found "${vcs}"
    exit 0
fi

if [[ -d $local ]]; then
    echo $local already exists
    exit 1
fi

mkdir -p $local
$vcs clone $remote $local
exit $?
