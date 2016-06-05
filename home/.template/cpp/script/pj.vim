"debugger, lldb or gdb
let g:mycppDebugger = "lldb"
"build dir, such as ./build/Debug, ./build/RelWithDebInfo
let g:mycppBuildDir = "./build"
"executable make target and path, value of 'default' will be used as the default
"make target
let g:mycppMakes = {}
"class name prefix
"let g:mycppClassPrefix='_PacExport'
"files included into newly created head file
"let g:mycppPreRequisite=['pacConsolePreRequisite.h']
"files included into newly created src file
"let g:mycppStable=['pacStable.h']
"
call mycpp#addDependencies('dependencies')
