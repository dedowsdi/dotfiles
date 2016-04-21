#!/bin/bash

#personal script to init system(cygwin or ubuntu), it assumes you place this
# cfg at /usr/local/source/cfg

IS_CYGWIN=`uname -a|grep -i cygwin`
IS_LINUX=`uname -a|grep -i linux`
CFG=/usr/local/source/cfg
CFG_HOME=${CFG}/home
CFG_VIM=${CFG}/vim
CFG_SCRIPT=${CFG}/script/bash
SCRIPT_DIR=/usr/local/bin/script
BASH_DIR=`dirname $BASH_SOURCE`

echo '************************************************************'
echo preparing

echo include util
source ${BASH_DIR}/zxdUtil.sh
buildSymbolicLink ${CFG_SCRIPT} ${SCRIPT_DIR}

if [[ IS_LINUX ]]; then
    echo found linux
else
    echo found cygwin
fi

echo '************************************************************'
echo init bash

if [[ $IS_LINUX ]]; then
    buildSymbolicLink ${CFG_HOME}/.zxdLinuxBashrc ~/.zxdBashrc
fi

if [[ $IS_CYGWIN ]]; then
    buildSymbolicLink ${CFG_HOME}/.zxdCygwinBashrc ~/.zxdBashrc
    echo create symbolic links to windows 
    buildSymbolicLink /cygdrive/f ~/study
    buildSymbolicLink /cygdrive/g/doc ~/doc
    buildSymbolicLink /cygdrive/g/issue ~/issue
fi

if ! grep zxdBashrc ~/.bashrc ; then
    echo source ~/.zxdBashrc >> ~/.bashrc
    source ~/.bashrc
fi

if [[ $IS_LINUX ]]; then
    echo '************************************************************'
    echo "install app"
    apt -y install git
    apt -y install git-gui
    apt -y install cmake
    apt -y install cmake-gui
    apt -y install clang
    apt -y install clang-format
    apt -y install mercurial
    apt -y install blender
    apt -y install the_silver_searcher
fi


echo '************************************************************'
echo get source
if ! [[ -f ${CFG_SCRIPT}/repoRemoteLocal ]]; then
    echo can not found ${CFG_SCRIPT}/repoRemoteLocal
    exit 1
fi

while read cmd remote local ; do
    repoClone $cmd $remote $local
done < ${CFG_SCRIPT}/repoRemoteLocal

echo '************************************************************'
echo init app 
buildSymbolicLink ${CFG_HOME}/.agignore ~/.agignore
buildSymbolicLink ${CFG_HOME}/.hgignore ~/.hgignore
buildSymbolicLink ${CFG_HOME}/.gitconfig ~/.gitconfig
buildSymbolicLink ${CFG_HOME}/.template ~/.template

if ! [[ -d ~/.vim  ]]; then
    echo you need to build vim now
    exit $?
fi

buildSymbolicLink ${CFG_HOME}/.vimrc ~/.vimrc
buildSymbolicLink ${CFG_VIM}/misc ~/.vim/misc

if ! [[ -d ~/.vim/bundle ]]; then
    echo init vim plugin manager
    echo install pathogen for vim
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    echo install vundle for vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
echo done

exit $?
