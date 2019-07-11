let $GL_FILE_PATH .= ';' . getcwd() . '/data'
call misc#ui#loadProjSetting('c')
call mycpp#setLastTarget('tt')
let g:mycppBuildDir = './build/gcc/Debug'
let g:cdefProjName = 'test'
let g:gutentags_project_root += ['.vim']
