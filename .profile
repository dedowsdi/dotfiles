# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$HOME/.script:$PATH"
PATH=${PATH}:/usr/local/bin/script:/opt/Qt/Qt5.6.0/5.6/gcc_64/bin/
export PYTHONPATH=${PYTHONPATH}:~/study/python/util
# let C-x C-e call nvim
# export EDITOR=nvim
export OSG_DIR=/usr/local
export OSGDIR=/usr/local
export OSG_FILE_PATH="/usr/local/source/OpenSceneGraph-Data;/home/pntandcnt/journey/osg/data"
export OSG_LIBRARY_PATH=/usr/local/lib64/osgPlugins-3.4.0
export FZF_DEFAULT_COMMAND='find .'
export OSG_NOTIFY_LEVEL=NOTICE
export ESM_DATA="/usr/local/source/openmw/data/Morrowind.esm"
export BSA_DATA="/usr/local/source/openmw/data/Morrowind.bsa"
export MVP_MATRIX_FILE="/home/pntandcnt/black"
export GL_FILE_PATH="$(realpath ~/journey/gl2/data);$(realpath ~/journey/gl4/data)"
#export PAGER="/bin/bash -c \"unset PAGER; col -b -x | \
    #vim -R --not-a-term -u ~/.less.vimrc -c 'set ft=man nomod nolist'  -\""
export MANPAGER="vim -M +MANPAGER +'file -' --not-a-term -u ~/.less.vimrc  -"
export CVSROOT=/usr/local/source/cvsroot

# awk posix
# POSIXLY_CORRECT=true
# export POSIXLY_CORRECT

# if [ "$TERM" = "linux" ]; then
#   /bin/echo -e "
#   \e]P0002b36
#   \e]P1dc322f
#   \e]P2859900
#   \e]P3b58900
#   \e]P4268bd2
#   \e]P56c71c4
#   \e]P62aa198
#   \e]P793a1a1
#   \e]P8657b83
#   \e]P9dc322f
#   \e]PA859900
#   \e]PBb58900
#   \e]PC268bd2
#   \e]PD6c71c4
#   \e]PE2aa198
#   \e]PFfdf6e3
#   "
#   # get rid of artifacts
#   clear
# fi

export PATH="$HOME/.cargo/bin:$PATH"
