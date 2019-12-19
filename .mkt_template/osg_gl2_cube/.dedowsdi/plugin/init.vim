set tags+=/usr/local/source/osg3.6_gl2/tags

call misc#proj#load_map('c')
call mycpp#set_last_target('tt')

let g:external_files = [
      \ '/usr/local/source/osg3.6_gl2',
      \ '/usr/local/source/OpenSceneGraph-Data'
      \ ]
