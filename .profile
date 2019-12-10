# vim:set foldmethod=marker :

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022

# load .bashrc, follow ubuntu's convention
if [ -n "$BASH_VERSION" ]; then

    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

PATH="$HOME/bin:$HOME/.local/bin:$HOME/.script:$PATH"
PATH=${PATH}:/usr/local/bin/script:$HOME/.cargo/bin:$PATH:/opt/Qt/Qt5.6.0/5.6/gcc_64/bin/

export PYTHONPATH=${PYTHONPATH}:~/study/python/util
export VISUAL="vim"
export EDITOR="$VISUAL"
export OSG_DIR=/usr/local
export OSGDIR=/usr/local
export OSG_FILE_PATH=/usr/local/source/OpenSceneGraph-Data
export OSG_LIBRARY_PATH=/usr/local/lib/osgPlugins-3.7.0
export OSG_NOTIFY_LEVEL=NOTICE
export FZF_DEFAULT_COMMAND='find .'
export ESM_DATA="/usr/local/source/openmw/data/Morrowind.esm"
export BSA_DATA="/usr/local/source/openmw/data/Morrowind.bsa"
export MANPAGER="vim -M +MANPAGER +'file -' --not-a-term -"
export CVSROOT=/usr/local/source/cvsroot
if [ -d ~/journey/gl2/data ]; then
    export GL_FILE_PATH="$(realpath ~/journey/gl2/data);$(realpath ~/journey/gl4/data)"
fi

# awk posix
# POSIXLY_CORRECT=true
# export POSIXLY_CORRECT

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi
