#!/bin/bash
# used to build cpp dependenpence, it reads libs and includes from project
# setting, create symbolic for them as under ./thirdlib, update .ycm_extrac_conf
# include information(after /usr/local/include), build ctags for third lib, add
# them at pj.vim

#------------------------------------------------------------------------------
#real work flow starts here

if ! [[ $# -eq 1 ]]; then
    echo wrong arg, is should be $0 project_path
    exit 1
fi

PROJECT=`cd $1 && pwd`
PROJECT_SCRIPT=${PROJECT}/script
PROJECT_THIRDLIB=${PROJECT}/thirdlib
PROJECT_YCMCONF="${PROJECT}/.ycm_extra_conf.py"
PROJECT_LIBS=${PROJECT_SCRIPT}/.libs
PROJECT_INCLUDES=${PROJECT_SCRIPT}/.includes

#get util
if [[ -h ${BASH_SOURCE} ]]; then
    CFG_SCRIPT=`readlink $BASH_SOURCE`
    CFG_SCRIPT=`dirname $SCRIPT_SOURCE`
else
    CFG_SCRIPT=`dirname $BASH_SOURCE`
fi
CFG_SCRIPT=`cd ${SCRIPT_SOURCE} && pwd`
source ${CFG_SCRIPT}/zxdUtil.sh

if ! [[ $PROJECT && -f $PROJECT_YCMCONF && -d $PROJECT_SCRIPT   ]]; then
    echo failed to find PROJECT or PROJECT_YCMCONF or PROJECT_SCRIPT
    exit 1
fi

mkdir -p $PROJECT_THIRDLIB 
`cd ${PROJECT_THIRDLIB} && rm -rf *`

echo preparing .ycm_extra_conf.py

#clearn .ycm_extra_conf
incBeg=`getFileLineNumber "'/usr/local/include',\s*$" $PROJECT_YCMCONF `
incBeg=$((incBeg+1))
incEnd=`getFileLineNumber "^\s*\d*\s*]\s*$" $PROJECT_YCMCONF `
incEnd=$((incEnd-1))
if [[ incEnd -ge incBeg ]]; then
    #clean original includes
    echo clean .ycm_extra_conf.py from $incBeg to $incEnd
    sed -i "${incBeg},${incEnd}d" $PROJECT_YCMCONF
fi

if [[ -f ${PROJECT_LIBS} ]]; then
    for lib in `cat ${PROJECT_LIBS}` ; do
        linkname=${PROJECT_THIRDLIB}/${lib}
        echo add lib "$lib", link as "$linkname", include at ycm
        #update include in .ycm_extra+conf
        ln -s $lib $linkname
        sed -i "${incBeg}i '-isystem',\n'${linkname}/include',"  $PROJECT_YCMCONF
    done   
fi

if [[ -f ${PROJECT_INCLUDES} ]]; then
    for lib in `cat ${PROJECT_INCLUDES}` ; do
        echo include $include at ycm
        #update include in .ycm_extra+conf
        sed -i "${incBeg}i '-isystem',\n'$include',"  $PROJECT_YCMCONF
    done   
fi

#build ctags for third lib
buildctags.sh ${PROJECT_THIRDLIB}
exit $?
