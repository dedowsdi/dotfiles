nnoremap <F12> :call JsFuncComment()<CR>
nnoremap <c-F12> :call JsOnComment()<CR>

" javascript function comment
command! -nargs=0 Jsfc call JsFuncComment() 
function! JsFuncComment()
    let str = getline(".")
    let reName = '\vfunction\s*\zs<\w+>|\zs\S+\ze\s\='
    let reArg = '\v\(\zs.*\w+.*\ze\)'
    let reBlank = '\v^\s+\ze\S'
    let name = matchstr(str, reName)
    let args = matchstr(str, reArg)
    let blank = matchstr(str, reBlank)
    "echo name
    "echo args
    "echo 'b' . blank . 'b'
    let aArgs = split(args, ',\s*', 0)
    let numArgs = len(aArgs)
    "echo aArgs
    "echo numArgs

    if stridx(name, '.') >= 0
	let name = '@method ' . name
    else
	let name = '@function ' . name
    endif
    
    for i in range(0, numArgs-1)
	let aArgs[i] = blank . ' *' . ' @param ' . aArgs[i] . ' : '
	"echo aArgs[i]
    endfor

    call append(line(".")-1, blank . '/**')
    call append(line(".")-1, blank . ' * ')
    call append(line(".")-1, blank . ' * ' . name)
    call append(line(".")-1, aArgs)
    call append(line(".")-1, blank . ' * @return : ')
    call append(line(".")-1, blank . ' */')
    exec 'normal 5k'
    
endfunction

function! JsOnComment()
    let str = getline(".")
    let reMsg = '\von.*[''"]\zs\w+\ze'
    let reArg = '\vfunction\s*\(\zs.*\w+.*\ze\)'
    let reBlank = '\v^\s+\ze\S'

    let msg = matchstr(str, reMsg)
    let args = matchstr(str, reArg)
    let blank = matchstr(str, reBlank)

    let aArgs = split(args, ',\s*', 0)
    let numArgs = len(aArgs)

    for i in range(0, numArgs-1)
	let aArgs[i] = blank . ' *' . ' @param ' . aArgs[i] . ' : '
    endfor
    
    call append(line(".")-1, blank . '/**')
    call append(line(".")-1, blank . ' * ')
    call append(line(".")-1, blank . ' * msg: ' . msg)
    call append(line(".")-1, aArgs)
    call append(line(".")-1, blank . ' */')
    exec 'normal 4k'


endfunction


" goto definition
nnoremap <F3> :TernDef

" rename
nnoremap <F2> :TernRename

"todo
"nmap <SPACE>t O@TODO:<ESC>\c<SPACE>A


"cc file ChildClassName SupreClassName
"mainly for javascript
"javascript create class for createjs class
function! Jscc(file, className, superName)
    exec ':new'
    exec ':saveas ' . a:file
    exec ':0r ~/html5/template/CreatejsClass.js'
    exec ':%s/ChildClass/' . a:className . '/g'
    exec ':%s/SuperClass/' . a:superName . '/g'
endfunction

command! -nargs=+ Jscc :call Jscc(<f-args>)

function! JsCenterSpriteRegXY()
    exec 'normal gg/\vwidth\D*<\zs\d+>yt,/\vregX\D*<\zs\d+>ct,=0/(2+0.0)gg/\vheight\D*<\zs\d+>yt,/\vregY\D*<\zs\d+>C=0/(2+0.0)'
endfunction
