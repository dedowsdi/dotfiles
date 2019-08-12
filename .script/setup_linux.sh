#!/bin/bash

# manually setup dotfiles
# cd ~
# sudo git clone https://github.com/dedowsdi/dotfiles.git .dotfiles
# git --git-dir=.dotfiles --work-dir=. checkout
#
# # prepare ppa and misc stuff
# setup_linux.sh -p
#
# setup_linux.sh -[awrdi]


if [[ $USER == "root" ]]; then
    echo "$0 should not be called as root"
    exit 1
fi

APACHE_WEB=/var/www/html
RC=$HOME/.linuxrc
GIT_SOURCE=/usr/local/source

if [[ $# == 0 ]]; then
    exit "call $0 -p first, then call $0 -[awrdi]"
fi

while getopts ":arwdip" Option ; do
    case $Option in
        p     ) DO_PREPARE=''  ;;
        a     ) DO_APT=''  ;;
        t     ) DO_THIRD=''  ;;
        w     ) DO_WEB=''  ;;
        r     ) DO_REPO='' ;;
        d     ) DO_DOWNLOAD=''  ;;
        i     ) DO_PIP3=''  ;;
        *     ) echo "Unimplemented option:$Option" ; exit 1 ;;
    esac
done
shift $((OPTIND-1))

elem_in()
{
    if [[ $# -lt 2 ]]; then
        echo "wrong arg, is should be $0 item list"
        exit 1
    fi

    local elem=$1
    local list=("${@:2}")
    for item in "${list[@]}"; do [[ "$item" == "$elem" ]] && exit 0; done
    exit 1
}

if [[ -v DO_PREPARE ]]; then
    while IFS= read -r address ; do
        sudo apt-add-repository -y "$address"
    done<"${RC}/ppa"
    sudo apt update

    mkdir -p ~/.config/nvim/autoload
    mkdir -p ~/.config/nvim/plugged
    mkdir -p ~/.vimbak

    if ! grep zxdBashrc ~/.bashrc ; then
        echo source ~/.zxdBashrc >>~/.bashrc
        source ~/.bashrc
    fi

    sudo apt install tmux
fi

if [[ -v DO_APT ]]; then
    while read app ; do
        if  dpkg -l "$app" | tail -1 | grep -E '^ii' ; then
            echo "$app" already installed
        else
            echo installing "$app"
            sudo apt -y install "$app"
        fi
    done < "${RC}"/app
fi

if [[ -v DO_THIRD ]]; then
    # oh-my-zsh
    cd ~/Downloads
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
fi

if [[ -v DO_PIP3 ]]; then
    piplist=$(pip3 list)
    while read pkg ; do
        if elem_in "$pkg" "$piplist"; then
            echo "$pkg" exists
        else
            pip3 install "$pkg"
        fi
    done<"${RC}/"pip3
fi

if [[ -v DO_REPO ]]; then
    cd "$GIT_SOURCE"
    while read cmd remote ; do
        sudo "$cmd" clone "$remote"
    done < "${RC}"/repo
fi

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
    done < "${RC}"/download
fi

if [[ -v DO_WEB ]]; then

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
        sudo ln -vfs "$filename" "$link"
    done<"${RC}"/apache
fi

exit 0
