#!/bin/bash

#personal script to init system(cygwin or ubuntu), it assumes you place this
# cfg at /usr/local/source/cfg

IS_CYGWIN=`uname -a|grep -i cygwin`
IS_LINUX=`uname -a|grep -i Linux`

#get abs real script address
if [[ -h ${BASH_SOURCE} ]]; then
    CFG_SCRIPT=`readlink $BASH_SOURCE`
    CFG_SCRIPT=`dirname $CFG_SCRIPT`
else
    CFG_SCRIPT=`dirname $BASH_SOURCE`
fi
CFG_SCRIPT=`cd ${CFG_SCRIPT} && pwd`

CFG=`cd ${CFG_SCRIPT}/../../ && pwd`
CFG_HOME=${CFG}/home
CFG_VIM=${CFG_HOME}/vim
SCRIPT_INSTALL_DIR=/usr/local/bin

echo '************************************************************'
echo preparing

echo include util
source ${CFG_SCRIPT}/zxdUtil.sh

if [[ IS_LINUX ]]; then
    echo found linux
    echo install script
    for item in `ls ${CFG_SCRIPT}/*.sh` ; do
        buildSymbolicLink $item ${SCRIPT_INSTALL_DIR}/`basename $item .sh`
    done
else
    echo found cygwin
    ln -s ${CFG_SCRIPT} ${SCRIPT_INSTALL_DIR}/script
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
    for app in `cat ${CFG_SCRIPT}/app` ; do
        appInstall $app
    done
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
echo init silver light
buildSymbolicLink ${CFG_HOME}/.agignore ~/.agignore
echo init mercurial
buildSymbolicLink ${CFG_HOME}/.hgignore ~/.hgignore
echo init git
buildSymbolicLink ${CFG_HOME}/.gitconfig ~/.gitconfig
echo init personal develop template
buildSymbolicLink ${CFG_HOME}/.template ~/.template

echo init vim
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

echo init apache2
if ! [[ -f /etc/apache2/conf-available/fqdn.conf ]]; then
    echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
    a2enconf fqdn
fi


echo done

exit $?
