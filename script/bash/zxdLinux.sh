#!/bin/bash

if [[ $USER == "root" ]]; then
    echo $0 should not be called as root
    exit 1
fi

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

if [[ -d ~/.config/nvim/autoload ]]; then
    mkdir -p ~/.config/nvim/autoload
    mkdir -p ~/.config/nvim/plugged
    mkdir -p ~/.vimbak
fi

if [[ $# == 0 ]]; then
    #do all by default
    DO_APT=1
    DO_SCRIPT=1
    DO_REPO=1
    DO_CFG=1
    DO_DOWNLOAD=1
    DO_PIP3=1
fi

#add ppa
ls /etc/apt/sources.list.d/neovim* >/dev/null 2>&1
if ! [[ $? -eq 0 ]] ; then
    echo add neovim ppa
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo add-apt-repository -y ppa:graphics-drivers/ppa
    sudo apt update
fi

while getopts ":arcdsp" Option
do
    case $Option in
        s     ) DO_SCRIPT=1  ;;
        a     ) DO_APT=1  ;;
        r     ) DO_REPO=1 ;;
        c     ) DO_CFG=1  ;;
        d     ) DO_DOWNLOAD=1  ;;
        p     ) DO_PIP3=1  ;;
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
    if [[ DO_SCRIPT ]]; then
        echo install script
        for item in `ls ${CFG_SCRIPT}/*.sh` ; do
            exename=`basename $item .sh`
            if ! [[ -h "${SCRIPT_INSTALL_DIR}/$exename" ]]; then
                sudo buildSymbolicLink $item 
                #on a new machine, everything script to be installed before they can be sued, includes buildSymbolicLink
                fileName=$item
                linkName=${SCRIPT_INSTALL_DIR}/$exename

                if [[ -h $linkName && `readlink $linkName` == $fileName ]]; then
                    #do nothing if it already exists
                    echo symbolic link ${linkName}'->'${fileName} exists
                    return 0
                fi

                echo build symbolic link : ${linkName}'->'${fileName}
                sudo ln -s $fileName $linkName
            fi
        done
    fi
else
    echo found cygwin
    ln -s ${CFG_SCRIPT} ${SCRIPT_INSTALL_DIR}/script
fi

echo '************************************************************'
echo init bash


if [[ $IS_CYGWIN ]]; then
    buildSymbolicLink ${CFG_HOME}/.zxdCygwinBashrc ~/.zxdBashrc
    echo create symbolic links to windows
    buildSymbolicLink /cygdrive/f ~/study
    buildSymbolicLink /cygdrive/g/doc ~/doc
    buildSymbolicLink /cygdrive/g/issue ~/issue
fi


if [[ $IS_LINUX && $DO_APT ]]; then
    echo '************************************************************'
    echo "install app"
    for app in `cat ${CFG_SCRIPT}/app` ; do
        sudo appInstall $app
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
        sudo repoClone $cmd $remote $local
    done < ${CFG_SCRIPT}/repoRemoteLocal
fi

# own and grp of downloaded 
if [[ $DO_DOWNLOAD ]]; then
    while read link target ; do
        target=`eval echo $target`
        if  [[ -f $target ]]; then
            echo $target exists, skip
        else
            echo downloading from $link to $target
            curl -fLo $target --create-dirs $link
        fi
    done < ${CFG_SCRIPT}/download
fi

if [[ $DO_CFG ]]; then
    echo '************************************************************'
    echo config

    buildSymbolicLink ${CFG_HOME}/.zxdLinuxBashrc ~/.zxdBashrc

    if ! grep zxdBashrc ~/.bashrc ; then
        echo source ~/.zxdBashrc >> ~/.bashrc
        source ~/.bashrc
    fi

    echo init silver light
    buildSymbolicLink ${CFG_HOME}/.agignore ~/.agignore
    echo init mercurial
    buildSymbolicLink ${CFG_HOME}/.hgignore ~/.hgignore
    echo init git
    #gitconfig will expand ~, it'd better to just copy it
    cp ${CFG_HOME}/.gitconfig ~/.gitconfig
    buildSymbolicLink ${CFG_HOME}/.gitignore ~/.gitignore
    sudo git config --global core.excludesfile ~/.gitignore
    echo init personal develop template
    buildSymbolicLink ${CFG_HOME}/.template ~/.template
    buildSymbolicLink ${CFG_HOME}/.vimrc ~/.vimrc
    buildSymbolicLink ${CFG_HOME}/.config/nvim/init.vim ~/.config/nvim/init.vim
    sudo chmod 777 ~/.vimrc
    sudo chmod 777 ~/.config/nvim/init.vim

    #if ! [[ -d ~/.vim/bundle ]]; then
    #echo init vim plugin manager
    ##echo install pathogen for vim
    #mkdir -p ~/.vim/autoload ~/.vim/bundle
    ##curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    #echo install vundle for vim
    #git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    #fi

    #add localhost servername
    echo init apache2
    if ! [[ -f /etc/apache2/conf-available/fqdn.conf ]]; then
        echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
        sudo a2enconf fqdn
        sudo service apache2 reload
    fi

    #change index.html to apache.html
    if [[ -f ${APACHE_WEB}/index.html ]]; then
        sudo mv ${APACHE_WEB}/index.html ${APACHE_WEB}/apache.html
    fi

    sudo buildSymbolicLink /usr/share/doc/cmake-doc/html /var/www/html/cmake
    sudo buildSymbolicLink /usr/share/doc/libstdc++6-4.7-doc/libstdc++/html /var/www/html/c++
    sudo buildSymbolicLink /usr/share/doc /var/www/html/doc
    sudo buildSymbolicLink /usr/share/doc/python3-doc/html /var/www/html/python3
    sudo buildSymbolicLink /usr/share/doc/libglfw3-doc/html /var/www/html/glfw3
    sudo buildSymbolicLink /usr/share/doc/opengl-4-html-doc /var/www/html/opengl4
fi

if [[ $DO_PIP3 ]]; then
    echo '************************************************************'
    echo pip3
    piplist=`pip3 list`
    for pkg in `cat ${CFG_SCRIPT}/pip3` ; do
        elemIn $pkg $piplist
        if [[ $? == 0 ]]; then
            echo $pkg exists, skip
        else
            pip3 install $pkg
        fi
    done
fi

echo done

exit $?
