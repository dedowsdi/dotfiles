# this file will be sourced at project/script/buildThirdlibs.sh

# used to build cpp dependenpence, it reads libs and includes from project
# setting, create symbolic for them as under ./thirdlib, update .ycm_extrac_conf
# include information(after /usr/local/include), build ctags for third lib, add
# them at pj.vim

#------------------------------------------------------------------------------
#this block is project specific

#ogrehome=/usr/local/source/ogre/ogre2.1
#myguihome=/usr/local/source/mygui/mygui_ogre2.1

##lib address, symbolic link name ...
#libs=(\
    #${ogrehome}/OgreMain Ogremain\
    #${ogrehome}/Components/Hlms Hlms\
    #${ogrehome}/Plugins/ParticleFX ParticleFX\
    #${myguihome}/MyGUIEngine MyGUI\
    #)

##special local includes need to be added to .ycm_extra_conf
#localIncludes=(\
     #test/include\
    #ogre/include\
    #ogre/test/include\
    #ogre/demo/mygui/include\
#)

#------------------------------------------------------------------------------
source zxdUtil.sh
#real work flow starts here

PROJECT_PATH=`dirname ${BASH_SOURCE[1]}`/../
THIRDLIB_PATH=${PROJECT_PATH}/thirdlib
YCMCONF_PATH="${PROJECT_PATH}/.ycm_extra_conf.py"

if ! [[ $PROJECT_PATH && YCMCONF_PATH ]]; then
    echo failed to setup PROJECT_PATH or YCMCONF_PATH
    exit 1
fi

mkdir -p $THIRDLIB_PATH 
`cd ${THIRDLIB_PATH} && rm -rf *`

echo preparing .ycm_extra_conf.py

#clearn .ycm_extra_conf
incBeg=`getFileLineNumber "'/usr/local/include',\s*$" $YCMCONF_PATH `
incBeg=$((incBeg+1))
incEnd=`getFileLineNumber "^\s*\d*\s*]\s*$" $YCMCONF_PATH `
incEnd=$((incEnd-1))
if [[ incEnd -ge incBeg ]]; then
    #clean original includes
    echo clean .ycm_extra_conf.py from $incBeg to $incEnd
    sed -i "${incBeg},${incEnd}d" $YCMCONF_PATH
fi

if [[ -v libs ]]; then
    for (( i = 0; i < ${#libs[*]}; i++ )); do
        if [[ 0 -eq $((i%2)) ]]; then
            #build symbolic link in thirdlib
            lib=${libs[i]}
            linkname=${THIRDLIB_PATH}/${libs[$[i+1]]}
            echo add lib "$lib", link as "$linkname", include at ycm
            #update include in .ycm_extra+conf
            ln -s $lib $linkname
            sed -i "${incBeg}i '-isystem',\n'${linkname}/include',"  $YCMCONF_PATH
        fi
    done
fi

if [[ -v localIncludes ]]; then
    for (( i = 0; i < ${#localIncludes[*]}; i++ )); do
        #add local includes in ycm
        include=${localIncludes[i]}
        echo include $include at ycm
        #update include in .ycm_extra+conf
        sed -i "${incBeg}i '-isystem',\n'$include',"  $YCMCONF_PATH
    done
fi

#build ctags for third lib
buildctags.sh ${THIRDLIB_PATH}
exit $?
