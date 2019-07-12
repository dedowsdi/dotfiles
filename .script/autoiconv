#!/bin/bash

# auto get file encoding, convert it to desired encoding

if [ $# -lt 1 ] ; then
	echo "wrong arg number, excepted format is $0 file toCharset"
	exit 1	
fi

oldFile="$1"
toCharset=$2
fromCharset=$(file -bi "$oldFile" | awk '{print $NF}' | cut -d= -f2)
newFile="${oldFile}.${toCharset}"

echo convert from "$fromCharset" to "$toCharset", stored at "$newFile" 
iconv -f "$fromCharset" -t "$toCharset" "${oldFile}" > "${newFile}" 

exit $?
