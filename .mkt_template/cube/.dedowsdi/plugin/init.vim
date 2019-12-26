set tags+=/usr/local/source/osg3.6_gl2/tags

set path^=/usr/local/source/osg3.6_gl2/**
set path^=/usr/local/source/bullet3/**

call misc#proj#load_map('c')
call mycpp#set_last_target('tt')

let g:external_files = [
      \ $HOME . '/journey/gl4',
      \]
