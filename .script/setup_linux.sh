#!/bin/bash

if [[ $USER == "root" ]]; then
    echo "$0 should not be called as root"
    exit 1
fi

# set -o errexit
set -o nounset

PROG_NAME=$0
APACHE_WEB=/var/www/html
RC=$HOME/.linuxrc
GIT_SOURCE=/usr/local/source
DOWNLOAD="$HOME/.setup_download"
LOG="$HOME/setup_log"
ESSENTIAL_LOG="$LOG/essential.log"
APT_LOG="$LOG/apt.log"
PIP_LOG="$LOG/pip.log"
DOWNLOAD_LOG="$LOG/download.log"
REPO_LOG="$LOG/repo.log"

mkdir -p "$LOG" "$DOWNLOAD"

show_usage()
{
    echo "Prerequisite:"
    echo ""
    echo "    git clone --bare https://github.com/dedowsdi/dotfiles .dotfiles"
    echo ""
    echo "    # checkout .script only, some installment suchas oh-my-zsh"
    echo "    # won't work if you checkout everything, you should do it after"
    echo "    # essenctial finished"
    echo "    git --git-dir=.dotfiles --word-tree=. checkout .script"
    echo ""
    echo "    cd ~/.script"
    echo ""
    echo "    Written for ubuntu18.04.3"
    echo ""
    echo "Usage:"
    echo ""
    echo "    $PROG_NAME -{heoapdr}"
    echo ""
    echo "    -h show this help"
    echo ""
    echo "    -e install essential, fast setup, log to $ESSENTIAL_LOG"
    echo ""
    echo "    -o install everything except essential"
    echo ""
    echo "    -a install apt, log to $APT_LOG"
    echo ""
    echo "    -p install pip apt, log to $PIP_LOG"
    echo ""
    echo "    -d download, log to $DOWNLOAD_LOG"
    echo ""
    echo "    -r clone repo, log to $REPO_LOG"
    echo ""
    echo "Issue:"
    echo ""
    echo "    you must manually clear nvm stuff at the end of .bashrc, it's already included in .profile and .zxdBashrc"
}

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

clone_git_repo()
{
    address=${1}
    dir=${2}

    if [[ -z "$address" || -z "$dir" ]]; then
        echo "empty address or dir"
        return 1
    fi

    {
        cd $GIT_SOURCE || return 1
        if [[ -d $dir ]]; then
            echo "$dir already exists, skipped"
            return 0
        fi
        sudo git clone "$address" "$dir"
    }
}

download()
{
    local OPTIND
    while getopts "hi" opt
    do
      case $opt in

        h )
            echo "usage"
            echo ""
            echo "      download -[i] url [output]"
            echo ""
            echo "      -i install"
            echo ""
            echo "      if output is relative, it's relative to $DOWNLOAD, not current dir"

            ;;

        i )
            local install=  ;;

        * )
            echo -e "\n  Option does not exist : $OPTARG\n"
            usage; return 1   ;;

      esac    # --- end of case ---
    done

    shift $((OPTIND-1))

    url=${1}
    if [[ -z "$url" ]]; then
        echo "empty url "
        return 1
    fi

    fname=${2}
    if [[ -z "$fname" ]]; then
        fname=${url##*/}
    fi

    cd "$DOWNLOAD" || return 1
    suffix=${fname##*.}
    if [[ ! -f "$fname" ]]; then
        curl -fsSL --create-dir "$url" -o "$fname" || return 1
    fi

    if [[ ! -v install ]]; then
        return 0
    fi

    chmod a+x "$fname"
    if [[ "$suffix" == deb ]]; then
        sudo dpkg -i "./$fname"
    fi

    if [[ "$suffix" == sh ]]; then
        chmod a+x "$fname"
        "./$fname"
    fi
}

install_ppa()
{
    while IFS= read -r address ; do
        grep -qF "${address:4}" -r /etc/apt/sources.list.d && continue

        sudo apt-add-repository -y "$address"
        new_ppa=
    done<"${RC}/ppa"

    if [[ -v new_ppa ]]; then
        sudo apt update
    fi
}

install_essential()
{
    # Failed to login after reboot, log says no permission for /dev/fb0, had to add self to video group, but not working.
    sudo usermod -a -G video "$USER"

    # It's said it's caused by rootless X (https://wiki.archlinux.org/index.php/xorg#Rootless_Xorg), we disable it here. No longer needed after install nvidia
    # driver?
    #
    # if grep -q needs_root_rights /etc/X11/Xwrapper.config ; then
    #     >>/etc/X11/Xwrapper.config echo 'needs_root_rights=yes'
    # fi

    sudo apt -y install build-essential git mercurial curl

    # chinese input method
    # Open "Language support", add simplified chinese
    # Open "settings/Region & Language", add this to input source
    # You can change keyboard shortcut in keyboard
    sudo apt -y install ibus-sunpinyin

    install_ppa

    # urxvt
    if [[ $(type -t urxvt) != file ]]; then
        sudo apt -y install rxvt-unicode-256color xfonts-terminus
        sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/urxvtc 100
        download https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font ~/.urxvt/ext/resize-font
        clone_git_repo https://aur.archlinux.org/urxvt-fullscreen.git urxvt-fullscreen
        cp $GIT_SOURCE/urxvt-fullscreen/fullscreen ~/.urxvt/ext/
    fi

    # apt tmux is old, you might want to purge this and build from source
    if [[ $(type -t tmux) != file ]]; then
        sudo apt -y install tmux figlet
    fi

    # apt vim is pretty old, you should purge this and build from source
    if [[ $(type -t vim) != file ]]; then
        sudo apt -y install vim clipit xclip
        mkdir -p ~/.vimbak ~/.vimundo ~/.vimswap
        mkdir -p ~/.config/nvim/autoload
        mkdir -p ~/.config/nvim/plugged
    fi

    # zsh
    if [[ $(type -t zsh) != file ]]; then
        sudo apt -y install zsh zsh-doc
        download -i https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh oh-my-zsh.sh
    fi

    # bash
    if ! grep -q zxdBashrc ~/.bashrc ; then
        echo source ~/.zxdBashrc >>~/.bashrc
        source ~/.bashrc
    fi

    # manage window in commandline. (wmctrl is needed by urxvt-fullscreen)
    sudo apt -y install xdotool wmctrl

    # c++ related
    sudo apt -y install clang-8 clang-8-tools
    sudo ln -fs  /usr/bin/clangd-8 /usr/bin/clangd
    sudo apt -y install libglfw3 libglfw3-dev
    sudo apt -y install cmake cmake-qt-gui

    # python
    sudo apt -y install python3-pip

    # node
    sudo apt -y install nodejs npm
    if [[ ! -f ~/.nvm/Makefile ]]; then
        download -i https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh nvm0.34.0.sh
    fi

    # browser
    if [[ $(type -t google-chrome) != file ]]; then
        download -i https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb chrome-stable.deb
    fi

    # webserver
    sudo apt -y install ant apache2
    if ! [[ -f /etc/apache2/conf-available/fqdn.conf ]]; then
        echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
        sudo a2enconf fqdn
        sudo service apache2 reload
    fi

    #change index.html to apache.html
    if [[ -f ${APACHE_WEB}/index.html ]]; then
        sudo mv ${APACHE_WEB}/index.html ${APACHE_WEB}/apache.html
    fi

    # https://github.com/Mayccoll/Gogh , change terminal color
    sudo apt -y install dconf-cli uuid-runtime
    curl -fsSL https://git.io/vQgMr -o "$DOWNLOAD/terminal_color_gogh.sh"
    cd "$DOWNLOAD" && chmod a+x ./terminal_color_gogh

    # essential repo
    clone_git_repo hppts://github.com/dedowsdi/.vim .vim
    ln -s $GIT_SOURCE/.vim ~/.vim

    clone_git_repo hppts://github.com/dedowsdi/journey journey
    ln -s $GIT_SOURCE/.journey ~/.journey

    clone_git_repo https://github.com/vim/vim.git vim
    clone_git_repo https://github.com/universal-ctags/ctags ctags
    clone_git_repo https://github.com/tmux/tmux tmux
    clone_git_repo https://github.com/dedowsdi/OpenSceneGraph osg
    clone_git_repo https://github.com/openscenegraph/OpenSceneGraph-Data osg-data
}

install_optional()
{
    sudo echo authorize
    >"$APT_LOG" 2>&1 install_apt &
    >"$PIP_LOG" 2>&1 install_pip &
    >"$REPO_LOG" 2>&1 install_repo &
    >"$LOG_WEB" 2>&1 install_web &
}

install_apt()
{
    pattern=$'^[ \t]*(#|$)'
    while read -r app ; do
        if [[ "$app" =~ $pattern ]]; then
            continue
        fi
        if  dpkg -l "$app" | tail -1 | grep -E '^ii' ; then
            echo "$app" already installed
        else
            echo installing "$app"
            sudo apt -y install "$app"
        fi
    done < "${RC}"/app
}

install_pip()
{
    piplist=$(pip3 list)
    while read -r pkg ; do
        if elem_in "$pkg" "$piplist"; then
            echo "$pkg" exists
        else
            pip3 install "$pkg"
        fi
    done<"${RC}/"pip3
}

install_repo()
{
    cd "$GIT_SOURCE" || return 1
    while read -r cmd remote ; do
        sudo "$cmd" clone "$remote"
    done < "${RC}"/repo
}

install_download()
{
    set -x
    cd ~/Downloads || return 1
    while read -r link target ; do
        download "$link" "$target"
    done < "${RC}/download"
}

install_web()
{
    while read -r filename link; do
        sudo ln -vfs "$filename" "$link"
    done<"${RC}"/apache
}

if [[ $# == 0 ]]; then
    show_usage
    exit 0
fi

while getopts "heoapdr" opt; do
    case $opt in
        h)
            show_usage
            exit 0
            ;;

        e)
            install_essential |& tee "$ESSENTIAL_LOG"
            exit $?
            ;;

        o)
            install_optional
            exit $?
            ;;

        a)
            install_apt |& tee "$APT_LOG"
            exit $?
            ;;

        p)
            install_pip |& tee "$PIP_LOG"
            exit $?
            ;;

        d)
            install_download |& tee "$DOWNLOAD_LOG"
            exit $?
            ;;

        r)
            install_repo |& tee "$REPO_LOG"
            exit $?
            ;;

        *)
            echo -e "\n  Option does not exist : $OPTARG\n"
            usage; exit 1
            ;;
    esac
done
shift $((OPTIND-1))

exit 0
