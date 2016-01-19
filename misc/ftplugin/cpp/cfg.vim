"if exists("g:loaded_cppcfg")
"finish
"endif
"let g:loaded_cppcfg = 1


"cscope-----------------------------------------------------
"if has("cscope")
	"set csprg=/usr/bin/cscope
	""search cscope databases before tag files
	"set csto=0
	""use cstag instead of tag
	"set cst
	""print message when adding a cscope database
	"set nocsverb
	""use quickfix
	"set cscopequickfix=s-,c-,d-,i-,t-,e-
	"" add any database in current directory
	"if filereadable("cscope.out")
		"cs add cscope.out
		"" else add database pointed to by environment
	"elseif $CSCOPE_DB != ""
		"cs add $CSCOPE_DB
	"endif
	"set csverb
"endif

"0 or s: Find this C symbol
"1 or g: Find this definition
"2 or d: Find functions called by this function
"3 or c: Find functions calling this function
"4 or t: Find this text string
"6 or e: Find this egrep pattern
"7 or f: Find this file
"8 or i: Find files #including this file
"nnoremap <Leader><Leader>s :lcs find s <C-R>=expand("<cword>")<CR><CR>
"nnoremap <Leader><Leader>g :lcs find g <C-R>=expand("<cword>")<CR><CR>
"nnoremap <Leader><Leader>c :lcs find c <C-R>=expand("<cword>")<CR><CR>
"nnoremap <Leader><Leader>t :lcs find t <C-R>=expand("<cword>")<CR><CR>
"nnoremap <Leader><Leader>e :lcs find e <C-R>=expand("<cword>")<CR><CR>
"nnoremap <Leader><Leader>f :lcs find f <C-R>=expand("<cfile>")<CR><CR>
"nnoremap <Leader><Leader>i :lcs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nnoremap <Leader><Leader>d :lcs find d <C-R>=expand("<cword>")<CR><CR>
"command! -nargs=0  Cs :cs find s <C-R>=expand("<cword>")<CR><CR>
"command! -nargs=0  Cg :cs find g <C-R>=expand("<cword>")<CR><CR>
"command! -nargs=0  Cc :cs find c <C-R>=expand("<cword>")<CR><CR>
"command! -nargs=0  Ct :cs find t <C-R>=expand("<cword>")<CR><CR>
"command! -nargs=0  Ce :cs find e <C-R>=expand("<cword>")<CR><CR>
"command! -nargs=0  Cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
"command! -nargs=0  Ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"command! -nargs=0  Cd :cs find d <C-R>=expand("<cword>")<CR><CR>

"check ctags --list-kind=c++ for detail 
"Most of the time i need only functin declaration tags, i don't need function
"definition tags.
"command! -nargs=0 Cut :!ctags --c++-kinds=+p-f include/* src/*
