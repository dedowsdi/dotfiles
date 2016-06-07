#!/bin/bash

#personal script to init system(cygwin or ubuntu), init ubuntu can be slow, so i divide it into 3 secionts, apt install, repo clone, cfg apt, each part can be
#called individually

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
APACHE_WEB=/var/www/html

if [[ $# == 0 ]]; then
    #do all by default
    DO_APT=1
    DO_REPO=1
    DO_CFG=1
fi

#add neovim repository
if  ! find /etc/apt/sources.list.d -name "neovim*">/dev/null ; then
add-apt-repository ppa:neovim-ppa/unstable
apt update
fi

while getopts ":arc" Option
do
    case $Option in
        a     ) DO_APT=1  ;;
        r     ) DO_REPO=1 ;;
        c     ) DO_CFG=1  ;;
        *     ) echo "Unimplemented option:${Option} " ; exit 1 ;;
    esac
done
shift $((OPTIND-1))

echo '************************************************************'
echo preparing

echo include util
source ${CFG_SCRIPT}/zxdUtil.sh

if [[ IS_LINUX ]]; then
    echo found linux
    if ! [[ -h ${SCRIPT_INSTALL_DIR}/zxdLinux ]]; then
        echo install script
        for item in `ls ${CFG_SCRIPT}/*.sh` ; do
            buildSymbolicLink $item ${SCRIPT_INSTALL_DIR}/`basename $item .sh`
        done
        buildSymbolicLink $CFG_HOME/.template/cpp/pj.sh $SCRIPT_INSTALL_DIR/vpj
    fi
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

if [[ $IS_LINUX && $DO_APT ]]; then
    echo '************************************************************'
    echo "install app"
    for app in `cat ${CFG_SCRIPT}/app` ; do
        appInstall $app
    done
fi


if [[ $DO_REPO ]]; then
    echo '************************************************************'
    echo get source
    if ! [[ -f ${CFG_SCRIPT}/repoRemoteLocal ]]; then
        echo can not found ${CFG_SCRIPT}/repoRemoteLocal
        exit 1
    fi

    while read cmd remote local ; do
        repoClone $cmd $remote $local
    done < ${CFG_SCRIPT}/repoRemoteLocal
fi


if [[ $DO_CFG ]]; then
    echo '************************************************************'
    echo cfg app
    echo init silver light
    buildSymbolicLink ${CFG_HOME}/.agignore ~/.agignore
    echo init mercurial
    buildSymbolicLink ${CFG_HOME}/.hgignore ~/.hgignore
    echo init git
    buildSymbolicLink ${CFG_HOME}/.gitconfig ~/.gitconfig
    buildSymbolicLink ${CFG_HOME}/.gitignore ~/.gitignore
    git config --global core.excludesfile ~/.gitignore
    echo init personal develop template
    buildSymbolicLink ${CFG_HOME}/.template ~/.template

    echo init vim
    #mkdir -p ~/.vim/
    mkdir -p ~/.config/nvim

    buildSymbolicLink ${CFG_HOME}/.vimrc ~/.vimrc
    buildSymbolicLink ${CFG_HOME}/.config/nvim/init.vim ~/.config/nvim/init.vim

    if ! [[ -f ~/.config/nvim/autoload/plug.vim ]]; then
        echo init nvim plugin manager
        curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    #if ! [[ -d ~/.vim/bundle ]]; then
        #echo init vim plugin manager
        ##echo install pathogen for vim
        #mkdir -p ~/.vim/autoload ~/.vim/bundle
        ##curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
        #echo install vundle for vim
        #git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    #fi

    echo init apache2
    if ! [[ -f /etc/apache2/conf-available/fqdn.conf ]]; then
        echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
        a2enconf fqdn
        service apache2 reload
    fi

    if [[ -f ${APACHE_WEB}/index.html ]]; then
        mv ${APACHE_WEB}/index.html ${APACHE_WEB}/apache.html
    fi

    buildSymbolicLink /usr/share/doc/cmake-doc/html /var/www/html/cmake
    buildSymbolicLink /usr/share/doc/libstdc++6-4.7-doc/libstdc++/html /var/www/html/c++
    buildSymbolicLink /usr/share/doc /var/www/html/doc
    buildSymbolicLink /usr/share/doc/python3-doc/html /var/www/html/python3
    buildSymbolicLink /usr/share/doc/libglfw3-doc/html /var/www/html/glfw3
    buildSymbolicLink /usr/share/doc/opengl-4-html-doc /var/www/html/opengl4
fi

echo done

exit $?
