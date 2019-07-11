#!/bin/bash

# baseNamePre is part of original filename, "stevecube_" in stevecube_FR.jpg
# baseNamePost is also part of original filename, but it will be discarded, it's 2048 in fullMool_x2048.jpg
# prefix is what ever you want, it will be placed after baseNamePre
baseNamePre=
baseNamePost=
prefix=
destDir=renamed

while getopts ":f:l:p:" Option
do
    case $Option in
        f     ) baseNamePre=$OPTARG  ;;
        l     ) baseNamePost=$OPTARG ;;
        p     ) prefix=$OPTARG ;;
        d     ) destDir=$OPTARG ;;
        *     ) echo "Unimplemented option:${Option} " ; exit 1 ;;
    esac
done
shift $((OPTIND-1))

if [ $# -lt 7 ] ; then
    echo wrong arg numbers, it should be ? [-f baseNamePre] [-l baseNamePost] [-p prefix ] ext x nx y ny z nz [x nx y ny z nz]
    exit 1
fi

ext=$1
src=(${@:2:6})


if [[ $# -eq 13 ]]; then
    dest=(${@:8:6})  
else
    dest=(x nx y ny z nz)
fi

mkdir -p ${destDir}

for (( i = 0; i < 6; i++ )); do
    cp "${baseNamePre}${src[$i]}${baseNamePost}.${ext}" "${destDir}/${baseNamePre}${prefix}${dest[$i]}.${ext}"
done
