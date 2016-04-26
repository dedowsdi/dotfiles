#/bin/bash

#build ctags for every child dir in src

if [ ! $# = 1 ] ; then
    echo "wrong arg number, excepted format is $0 src"
    exit 1
else
    #get variables
    src=$1

    echo '*********************************************************************'
    echo Source directory: $src

    cd $src
    for dir in `ls`; do
        pushd && cd $dir
        echo build ctags for ${src}/$dir
        ctags -R --sort=foldcase --links=no
        popd
    done

    echo '*********************************************************************'
fi
