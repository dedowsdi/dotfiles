#!/bin/bash

if [[ $USER == "root" ]]; then
    echo "$0 should not be called as root"
    exit 1
fi

#get abs real script address
if [[ -h ${BASH_SOURCE} ]]; then
    CFG_SCRIPT=$(readlink "$BASH_SOURCE")
    CFG_SCRIPT=$(dirname "$CFG_SCRIPT")
else
    CFG_SCRIPT=$(dirname "$BASH_SOURCE")
fi
CFG_SCRIPT=$(cd "${CFG_SCRIPT}" && pwd)

CFG=$(cd "${CFG_SCRIPT}/../../" && pwd)
CFG_HOME=${CFG}/home
USER_HOME=~
#CFG_VIM=${CFG_HOME}/vim
SCRIPT_INSTALL_DIR=/usr/local/bin
APACHE_WEB=/var/www/html

if [[ $# == 0 ]]; then
    #do all by default
    DO_APT=
    DO_SCRIPT=
    #DO_DOWNLOAD=
    #DO_REPO=
    DO_CFG=
    DO_PIP3=
fi

while getopts ":arcdsp" Option ; do
    case $Option in
        s     ) DO_SCRIPT=''  ;;
        a     ) DO_APT=''  ;;
        r     ) DO_REPO='' ;;
        c     ) DO_CFG=''  ;;
        d     ) DO_DOWNLOAD=''  ;;
        p     ) DO_PIP3=''  ;;
        *     ) echo "Unimplemented option:$Option" ; exit 1 ;;
    esac
done
shift $((OPTIND-1))

echo '************************************************************'
echo preparing

mkdir -p ~/.config/nvim/autoload
mkdir -p ~/.config/nvim/plugged
mkdir -p ~/.vimbak

#add ppa
while read ppaAddress ppaPattern ; do
    if [[ -z "$(find /etc/apt/sources.list.d/ -maxdepth 1 -name "$ppaPattern" -print -quit)"  ]] ; then
        sudo add-apt-repository -y "$ppaAddress"
        needUpdate=
    fi
    if [[ -v needUpdate ]] ; then
        sudo apt update
    fi
done<"${CFG_SCRIPT}/ppa"

echo include util
source "${CFG_SCRIPT}/zxdUtil.sh"

if [[ -v DO_SCRIPT ]]; then
    if [[ ! -e ~/.bash_aliases ]]; then
        echo create ~/.bash_aliases
        touch ~/.bash_aliases
    fi
    if ! grep glvalgrind ~/.bash_aliases ; then
        echo "alias glvalgrind='valgrind --gen-suppressions=all --leak-check=full --num-callers=40 --log-file=valgrind.txt
        --suppressions=$USER_HOME/.config/opengl.supp  --suppressions=$USER_HOME/.config/osg.supp  --error-limit=no -v'">>~/.bash_aliases
    fi
    echo install script
    for item in  "${CFG_SCRIPT}"/*.sh ; do
        fileName=$item
        linkName=${SCRIPT_INSTALL_DIR}/$(basename "$item" .sh)
        sudo ln -vfs "$fileName" "$linkName"
    done
fi

echo '************************************************************'
echo init bash

if [[ -v DO_APT ]]; then
    echo '************************************************************'
    echo "install app"
    while read app ; do
        dse=$(dpkg -l "$app" | tail -1 | cut -d ' ' -f 1)
        if  [[ $dse == ii ]] ; then
            echo "$app" already installed
        else
            echo installing "$app"
            sudo apt -y install "$app"
        fi
    done < "${CFG_SCRIPT}"/app
fi

if [[ -v DO_REPO ]]; then
    echo '************************************************************'
    echo get source
    if ! [[ -f ${CFG_SCRIPT}/repoRemoteLocal ]]; then
        echo can not found "${CFG_SCRIPT}"/repoRemoteLocal
        exit 1
    fi

    while read cmd remote local ; do
        if [[ -d $local ]]; then
            echo "$local" exists
        else
            sudo "$cmd" clone "$remote" "$local"
        fi
    done < "${CFG_SCRIPT}"/repoRemoteLocal
fi

# own and grp of downloaded 
if [[ -v DO_DOWNLOAD ]]; then
    while read link target ; do
        # --create-dirs doesn't work if target starts with ~, i have to expan it
        target=$(eval echo "$target")
        if  [[ -e $target ]]; then
            echo "$target exists"
        else
            echo "downloading from $link to $target"
            curl -fLo "$target" --create-dirs "$link"
        fi
    done < "${CFG_SCRIPT}"/download
fi

if [[ -v DO_CFG ]]; then
    echo '************************************************************'
    echo config

    for item in $(shopt -s dotglob && echo "${CFG_HOME}"/*) ; do
        filename="${item##*/}"
        if [[ -f $item && $filename != ".gitconfig" ]]; then
            ln -vfs "$item" ~/"$filename"
        fi
    done

    if ! grep zxdBashrc ~/.bashrc ; then
        echo source ~/.zxdBashrc>>~/.bashrc
        source ~/.bashrc
    fi

    echo init git
    #gitconfig will  expand ~, it'd better to just copy it
    cp "${CFG_HOME}"/.gitconfig ~/.gitconfig
    git config --global core.excludesfile ~/.gitignore
    if [[  -e ~/.config/nvim/autoload/plug.vim ]]; then
        echo plug.vim exists
    else
        curl -fLo  ~/.config/nvim/autoload/plug.vim \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    ln -vfs "${CFG_HOME}"/.config/nvim/init.vim ~/.config/nvim/init.vim
    sudo chmod 777 ~/.vimrc
    sudo chmod 777 ~/.config/nvim/init.vim

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

    while read filename link; do
        #statements
        sudo ln -vfs "$filename" "$link"
    done<"${CFG_SCRIPT}"/apache

fi

if [[ -v DO_PIP3 ]]; then
    echo '************************************************************'
    echo pip3
    piplist=$(pip3 list)
    while read pkg ; do
        elemIn "$pkg" "$piplist"
        if [[ $? == 0 ]]; then
            echo "$pkg" exists
        else
            pip3 install "$pkg"
        fi
    done<"${CFG_SCRIPT}/"pip3
fi

echo "done"

exit $?
