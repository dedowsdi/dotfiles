set tags+=/usr/local/source/osg/tags

set path^=/usr/local/source/osg/**
set path^=/usr/local/source/bullet3/**

call misc#proj#load_map('c')
call mycpp#set_last_target('tt')

let g:cdef_get_set_style = 'camel'
let g:external_files = [
      \'/usr/local/source/osg',
      \'/usr/local/source/OpenSceneGraph-Data',
      \]
