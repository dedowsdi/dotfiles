#!/bin/bash
#install app if it's not nod found
if [ $# -lt 1 ] ; then
    echo wrong arg numbers, it should be appInstall appName
    exit 1
fi
appName=$1
dse=$(dpkg -l "$appName" | tail -1 | cut -d ' ' -f 1)
if  [[ $dse == ii ]] ; then
    echo "$appName" already installed
    exit 0
else
    echo installing "$appName"
    apt -y install "$appName"
fi
exit 0;
