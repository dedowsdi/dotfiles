#!/bin/bash

#init project from ~/.template/project

TEMPLATE_PROJ=~/.template
if ! [[ $TEMPLATE_PROJ ]]; then
    echo $TEMPLATE_PROJ does not exists 
    exit 1
fi

if [ $# -lt 1 ] ; then
    echo "wrong arg number, excepted format is $0 template dest"
    exit 0
else

    # get variables
    template=${TEMPLATE_PROJ}/$1
    dest=$2

    echo '*********************************************************************'
    echo init project $dest 

    echo copy setting from /${template}
    cp -r ${template} $dest
    # configure cmake, replace __PROJECT__ and __UC_PROJECT__
    sed -i "s/__PROJECT__/${dest}/g" ${dest}/CMakeLists.txt
    sed -i "s/__UC_PROJECT__/${dest^^}/g" ${dest}/CMakeLists.txt

	echo '*********************************************************************'

	exit $?
fi

