let $GL_FILE_PATH .= ';' . getcwd() . '/data'
set tags+=~/journey/gl4/tags
set path+=~/journey/gl4/gl43/include
set path+=~/journey/gl4/gl43app/include
set path+=~/journey/gl4/glc/include
call misc#proj#load_map('c')
call mycpp#set_last_target('tt')
let g:mycpp_build_dir = './build/gcc/Debug'
let g:cdef_proj_name = 'test'
let g:gutentags_project_root += ['.vim']
silent args main.cpp data/shader4/*

call setpos("'M", [bufnr('main.cpp'), 70, 1, 0])
norm! `Mzz
