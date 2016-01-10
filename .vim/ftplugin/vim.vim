
"load guard
if exists("g:loaded_myvim")
	finish
endif
let g:loaded_myvim = 1

command! -nargs=0 Vcf :call VcmtFunc()
command! -nargs=0 V :source %
command! -nargs=0 Vb :breakadd here  
command! -nargs=0 Vbf :call VbreakAtFuncLine()

"search regex------------------------------------------------
let s:reFunc = '^s*fu'

"extract regex------------------------------------------
let s:rexFuncName = '\v\S+\ze\s*\(.*\)'
let temprex = s:rexFuncName

 ""
 " call break add line func 
 " @cursor range : function definition 
 ""
function! VbreakAtFuncLine()
	let startLine = line('.')
	let startCol = col('.')

	if VgotoFunction()
		let funcName = matchstr(getline('.'), s:rexFuncName)
		let breakLine = startLine - line('.')	
		execute 'breakadd func ' . breakLine . ' ' . funcName
	else
		echoe 'function not found'
	endif
	
	call cursor(startLine, startCol)
endfunction

 ""
 " goto 1st function name line before this line 
 " @cursor range : anywhere in function definition 
 " @return : 0 or 1
 ""
function! VgotoFunction()
	let startLine = line('.')
	let startCol = col('.')

	if search(s:reFunc, 'bW')	
		return 1
	endif

	call cursor(startLine, startCol)
	return 0
endfunction

" vim function comment
function! VcmtFunc()
    let str = getline(".")
    let reName = '\vfunction\s*\zs<\w+>'
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

    
    for i in range(0, numArgs-1)
	let aArgs[i] = blank . '"' . ' @param ' . aArgs[i] . ' : '
	"echo aArgs[i]
    endfor

	let startLine = line('.')
    call append(line(".")-1, blank . '""')
    call append(line(".")-1, blank . '" ')
    call append(line(".")-1, blank . '" @cursor range : ')
    call append(line(".")-1, aArgs)
    call append(line(".")-1, blank . '" @return : ')
    call append(line(".")-1, blank . '""')
	call cursor(startLine + 1, 0)
	normal A
    
endfunction
