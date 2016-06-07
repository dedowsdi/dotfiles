#!/bin/bash

#init project from ~/.template/project

TEMPLATE_PROJ=~/.template
if ! [[ $TEMPLATE_PROJ ]]; then
    echo $TEMPLATE_PROJ does not exists
    exit 1
fi

while getopts ":c" Option
do
    case $Option in
        c     ) DO_CFG=1  ;;
        *     ) echo "Unimplemented option:${Option} " ; exit 1 ;;
    esac
done
shift $((OPTIND-1))

if [ $# -lt 2 ] ; then
    echo "wrong arg number, excepted format is $0 [-c] template dest"
    exit 0
else
    template=${TEMPLATE_PROJ}/$1
    dest=$2

    echo '*********************************************************************'

    if [[ $DO_CFG ]]; then
        echo configure vimproject to $dest
        cp -r ${template}/vimScript $dest
        cp ${template}/pj.sh $dest
    else
        echo init project $dest
        echo copy setting from /${template}
        cp -r ${template} $dest
        # configure cmake, replace __PROJECT__ and __UC_PROJECT__
        sed -i "s/__PROJECT__/${dest}/g" ${dest}/CMakeLists.txt
        sed -i "s/__UC_PROJECT__/${dest^^}/g" ${dest}/CMakeLists.txt
    fi
    echo '*********************************************************************'

    exit $?
fi
