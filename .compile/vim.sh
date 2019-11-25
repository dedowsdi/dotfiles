#!/bin/bash

sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
  libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
  libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
  python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git

# to update python version to 3.6:
#   sudo add-apt-repository ppa:jonathonf/python-3.6
#   sudo apt update
#   sudo apt install python3.6 python3.6-dev libpython3.6
#
#   sudo update-alternative install /usr/bin/python3 python3 /usr/bin/python3.5 1
#   sudo update-alternative install /usr/bin/python3 python3 /usr/bin/python3.6 2
#   sudo update-alternative --config python3 (choose python3.6, you can change it back to python3.5 later)
#
#   change configure option : --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
#
#   It's said --enable-python3interp=dynamic is recommended, but failed to make it work
#
#  --with-x \ # cause always has('gui')
#

./configure \
  --with-features=huge \
  --with-compiledby="dedowsdi <peanutandchestnut@gmail.com>" \
  --enable-gui=auto \
  --enable-multibyte \
  --enable-rubyinterp=no \
  --enable-python3interp=yes \
  --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
  --enable-perlinterp=no \
  --enable-luainterp=no \
  --enable-cscope \
  --prefix=/usr/local \
  |& tee configure.log

  # --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu

make -j 3 VIMRUNTIMEDIR=/usr/local/share/vim/vim81 |& tee make.log

sudo make -j 3 install |& tee -a make.log

sudo update-alternatives --install /usr/bin/editor   editor   /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/vi       vi       /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/vim      vim      /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/vimdiff  vimdiff  /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/rvim     rvim     /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/rview    rview    /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/view     view     /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/ex       ex       /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/editor   editor   /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/gvim     gvim     /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/gview    gview    /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/rgview   rgview   /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/rgvim    rgvim    /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/evim     evim     /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/eview    eview    /usr/local/bin/vim 100
sudo update-alternatives --install /usr/bin/gvimdiff gvimdiff /usr/local/bin/vim 100
