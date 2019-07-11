#!/bin/bash

#copy shader file, chang macro number value

if [ $# -lt 4 ] ; then
    echo "wrong arg number, excepted format is $0 src macro startNum endNum"
    exit 1
fi

src=$1
macro=$2
startNum=$3
endNum=$4

#check if startNum and endNum is valid
if [[ ! $startNum =~ [0-9]+ ]] && [[ ! $endNum =~ [0~9] ]]; then
    echo startNum and endNum should be number
    exit 1
fi

if [[ $startNum -gt $endNum ]]; then
    echo startNum should not greater than endNum
    exit 1
fi

#get line number of macro
lnum=`grep -P -n "${macro}\s*\d+" $src |cut -d':' -f 1`
if [[ -z $lnum ]]; then
    echo $macro not found 
    exit 1
fi

#extrac prefix and suffix
#src can be abc2dfs3.vs.glsl, need to extract abc2dfs and vs.glsl
if [[ $src =~ (.+)[0-9]+(.+)  ]] || [[ $src =~ ([^.]+)(\..+) ]] ; then
    prefix=${BASH_REMATCH[1]}
    suffix=${BASH_REMATCH[2]}
else
    echo illigal src : $src
fi

#make copies, change macro values
for i in `seq $startNum $endNum` ; do
    target=${prefix}${i}${suffix}
    cp $src $target
    sed -ri -e "${lnum}s/[0-9]+\s*$/${i}/" $target
done

exit $?
