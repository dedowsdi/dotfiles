let $GL_FILE_PATH .= ';' . getcwd() . '/data'
set tags+=~/journey/gl4/tags
call misc#proj#loadMap('c')
call mycpp#setLastTarget('tt')
let g:mycppBuildDir = './build/gcc/Debug'
let g:cdefProjName = 'test'
let g:gutentags_project_root += ['.vim']
silent args main.cpp data/shader4/*

call setpos("'M", [bufnr('main.cpp'), 57, 1, 0])
call setpos("'V", [bufnr('tt.vs.glsl'), 5, 1, 0])
call setpos("'F", [bufnr('tt.fs.glsl'), 7, 1, 0])
norm! `Mzz
