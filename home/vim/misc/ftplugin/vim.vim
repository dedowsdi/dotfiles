
"load guard
"if exists("g:loaded_myvim")
	"finish
"endif
"let g:loaded_myvim = 1

command! -nargs=0 Vcf :call VcmtFunc()
command! -nargs=0 V :source %
command! -nargs=0 Vb :breakadd here  
command! -nargs=* Vbf :call VbreakAtFuncLine(<f-args>)
command! -nargs=* Vsf :call VcallScriptFunc(<f-args>)
command! -nargs=? Vgf :call VgotoFunction(<f-args>)
nnoremap <leader>J Js<bar><esc>

"search regex------------------------------------------------
let s:reFuncStart = '^s*fu'
let s:reFuncEnd = '^s*endfu'

"extract regex------------------------------------------
let s:rexFuncName = '\v\zs[^ \t]+\ze\s*\(.*\)'

 ""
 " Call break add line func . This also works for script scope function. Add
 " break point at current function line by default. You can also specify
 " function name and break piont line. 
 " @param1 funcName : Function name 
 " @param2 line : break point line. Set this to 0 if you dont't need it.
 " @param3 plugFileName: plugin file name, you need this if you want to break
 " 						 at script scope function
 " @cursor range : function definition 
 ""
function! VbreakAtFuncLine(...)
	let startLine = line('.')
	let startCol = col('.')
	
	let funcName = a:0 >= 1 && len(a:1) > 0 ? a:1 : ''
	let breakLine = a:0 >= 2 && len(a:2) > 0 && a:2 != '0' ? a:2 : ''
	let plugFileName = a:0 >= 3 && len(a:3) > 0 ? a:3 : ''

	if len(funcName) == 0
		"break at current line
		if VgotoFunction()
			let funcName = matchstr(getline('.'), s:rexFuncName)
			let breakLine = startLine - line('.')	
			if VisScopeScript()
				"add <SNR>SID_ prefix	
				let plugFileName = expand('%')
				let funcName = '<SNR>'.mycpp#util#getSid(plugFileName).'_'.funcName[2:]
			endif
		else
			echoe 'function not found'
		endif
	elseif len(plugFileName) > 0
		"break at script function specified by funcName and plugFileName
		"add <SNR>SID_ prefix	
		let funcName = '<SNR>'.mycpp#util#getSid(plugFileName).'_'.funcName
	endif

	execute 'breakadd func ' . breakLine . ' ' . funcName
	
	call cursor(startLine, startCol)
endfunction

""
" Call script scope function 
" @param plugFileName : plugin file name
" @param funcName : function name 
" @return : 
""
function! VcallScriptFunc(plugFileName, funcName,...)
	let fullname = '<SNR>'.mycpp#util#getSid(a:plugFileName).'_'.a:funcName
	return call(fullname,a:000)
endfunction


""
" Check if it's script scope  
" @cursor range : func name line or variable name line 
" @return : 0 or 1 
""
function! VisScopeScript()
	return stridx(getline('.'), 's:') >= 0
endfunction



 ""
 " Goto current function name line or specific line 
 " @param1 line : line number
 " @cursor range : anywhere in function definition 
 " @return : 0 or 1
 ""
function! VgotoFunction(...)
	let startLine = line('.')
	let startCol = col('.')

	normal! $
	if search(s:reFuncStart, 'bW')	
		if a:0 == 0	
			return 1
		else
			execute 'normal! '.a:1.'j'
			return 1
		endif
	endif

	call cursor(startLine, startCol)
	return 0
endfunction

""
" Get current function range 
" @cursor range : 
" @return : [startline,endline]
""
function! VgetFuncRange()
		
	let [startLine, startCol] = [line('.'), col('.')]|try
	if VgotoFunction()
		let funcStartLine = line('.')	
		if search(s:reFuncEnd, 'W')
			return [funcStartLine, line('.')]	
		else
			throw 'function end not found!'
		endif
	endif
	return [0,0]
	finally|call cursor(startLine, startCol)|endtry

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
