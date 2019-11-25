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
export VISUAL="vim"
export EDITOR="VISUAL"
export OSG_DIR=/usr/local
export OSGDIR=/usr/local
export OSG_FILE_PATH=/usr/local/source/OpenSceneGraph-Data
# export OSG_LIBRARY_PATH=/usr/local/lib64/osgPlugins-3.4.0
export OSG_LIBRARY_PATH=/usr/local/lib/osgPlugins-3.7.0
export FZF_DEFAULT_COMMAND='find .'
export OSG_NOTIFY_LEVEL=NOTICE
export ESM_DATA="/usr/local/source/openmw/data/Morrowind.esm"
export BSA_DATA="/usr/local/source/openmw/data/Morrowind.bsa"
export MVP_MATRIX_FILE="/home/pntandcnt/black"
if [ -d ~/journey/gl2/data ]; then
    export GL_FILE_PATH="$(realpath ~/journey/gl2/data);$(realpath ~/journey/gl4/data)"
fi
#export PAGER="/bin/bash -c \"unset PAGER; col -b -x | \
    #vim -R --not-a-term -u ~/.less.vimrc -c 'set ft=man nomod nolist'  -\""
export MANPAGER="vim -M +MANPAGER +'file -' --not-a-term -u ~/.less.vimrc  -"
export CVSROOT=/usr/local/source/cvsroot

# awk posix
# POSIXLY_CORRECT=true
# export POSIXLY_CORRECT

if [ "$TERM" = "linux" ]; then
  printf    "
  \e]P0282828
  \e]P1cc241d
  \e]P298971a
  \e]P3d79921
  \e]P4458588
  \e]P5b16286
  \e]P6689d6a
  \e]P7a89984
  \e]P8928374
  \e]P9fb4934
  \e]PAb8bb26
  \e]PBfabd2f
  \e]PC83a598
  \e]PDd3869b
  \e]PE8ec07c
  \e]PFebdbb2
  "
  setfont /usr/share/consolefonts/ter-120n.psf.gz
  # get rid of artifacts
  clear
fi

export PATH="$HOME/.cargo/bin:$PATH"

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi
