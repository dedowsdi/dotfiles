#!/bin/bash

set -o errexit
set -o nounset

sudo apt build-dep vim-gnome

exec &> >(tee make.log)

# remove stock vim
# sudo apt remove vim vim-tiny vim-runtime vim-common gvim vim-gui-common

PREFIX=${PREFIX:-/usr/local}
./configure \
  --with-features=huge \
  --with-compiledby="dedowsdi <dedowsdi@outlook.com>" \
  --enable-gui=auto \
  --enable-multibyte \
  --enable-rubyinterp=no \
  --enable-python3interp=yes \
  --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
  --enable-perlinterp=no \
  --enable-luainterp=no \
  --enable-cscope \
  --prefix="$PREFIX" \
  |& tee configure.log

# clear build
# make distclean

make -j 3 VIMRUNTIMEDIR=/usr/local/share/vim/vim82 |& tee make.log
sudo make -j 3 install |& tee -a make.log

if [[ -f ~/.vim/debian.vim && ! -e "$PREFIX/share/vim/vimrc" ]]; then
    sudo ln -vfs ~/.vim/debian.vim "$PREFIX/share/vim/vimrc"
fi

# update alternatives
sudo update-alternatives --install /usr/bin/editor   editor   "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/vi       vi       "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/vim      vim      "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/vimdiff  vimdiff  "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/rvim     rvim     "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/rview    rview    "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/view     view     "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/ex       ex       "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/editor   editor   "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/gvim     gvim     "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/gview    gview    "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/rgview   rgview   "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/rgvim    rgvim    "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/evim     evim     "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/eview    eview    "$PREFIX/bin/vim" 100
sudo update-alternatives --install /usr/bin/gvimdiff gvimdiff "$PREFIX/bin/vim" 100
