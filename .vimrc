set nocompatible		

filetype off		
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim,~/.vim/mycpp


call vundle#begin()				" alternatively, pass a path as  vundle#begin('~/some/path/here') 

Plugin 'VundleVim/Vundle.vim'			" let Vundle manage Vundle, required
Plugin 'pangloss/vim-javascript'		" javascript support
Plugin 'Valloric/YouCompleteMe'			" auto complete
Plugin 'othree/html5.vim'				" html5
Plugin 'elzr/vim-json'					" json
Plugin 'scrooloose/nerdtree'			" tree resource
Plugin 'scrooloose/syntastic'			" syntatic check
Plugin 'kien/ctrlp.vim'					" file search replace
Plugin 'flazz/vim-colorschemes'			" color scheme
Plugin 'nanotech/jellybeans.vim'		" more color scheme
Plugin 'altercation/vim-colors-solarized'	" more coloR scheme
Plugin 'tpope/vim-fugitive'				" git wrapper
Plugin 'majutsushi/tagbar'				" outline
Plugin 'tpope/vim-surround'				" sourounding
Plugin 'jiangmiao/auto-pairs'			" auto close pair
Plugin 'docunext/closetag.vim'			" auto close tag
Plugin 'scrooloose/nerdcommenter'		" comment helper
Plugin 'SirVer/ultisnips'				" snippet manager based on python
Plugin 'honza/vim-snippets'				" snippets
Plugin 'terryma/vim-multiple-cursors'	" multi curosr
Plugin 'triglav/vim-visual-increment'	" number sequence
Plugin 'tpope/vim-abolish'				" substitute
Plugin 'marijnh/tern_for_vim'			" javascript autocomplete support
Plugin 'klen/python-mode'
Plugin 'digitaltoad/vim-jade'			" jade syntax
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'mileszs/ack.vim'
Plugin 'junegunn/vim-easy-align'

call vundle#end()						" All of your Plugins must be added before this line
filetype plugin indent on				" required. To ignore plugin indent changes, instead use: filetype plugin on
" tagbar---------------------------------------------------------------------------------------
nnoremap <c-j> :TagbarOpenAutoClose<CR>
let g:TagbarOpenAutoClose = 1

"basic setting----------------------------------------------------------------------------------
set autoindent                  " set auto-indenting on for programming
set showmatch                   " autoshow matching brackets. works like it does in bbedit.
set vb                          " turn on "visual bell" - which is much quieter than "audio blink"
set ruler                       " show the cursor position all the time
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set cmdheight=2
set backspace=indent,eol,start  " make that backspace key work the way it should
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set showmode                    " show the current mode
"set t_Co=256					" Explicitly tell Vim that the terminal supports 256 colors
syntax enable                   " turn syntax highlighting on by default
set textwidth=80
set backupdir=~/vimbak			"set backup dir 
set history=50			    	"keep 50 commands
set showcmd						"display incomplete command in low right corner
set incsearch					"toggle increment search
set number						"show line number
set ignorecase
set smartcase					"smart case
set fileencodings=utf-8,gbk,cp936		"add chinese support
"set termencoding=utf-8
set encoding=utf-8
"set softtabstop=4				"set tab width to 4
set tabstop=4
set shiftwidth=4				"set shift width to 4
set sessionoptions+=unix,slash	"use unix /, so the session can be open by both windows and unix
set hidden						"allow hidden without trailing #
"set nowrap						" no line wrap
set path+=**/**					"set up find path, find in all subdirectories
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P
let &backup = !has("vms")		"set auto backup

hi CursorLine   cterm=NONE ctermbg=lightblue ctermfg=white guibg=darkred guifg=white		
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white		
" heighlight current line
nnoremap <Leader>r :set cursorline!<CR>
" heighlight current column
nnoremap <Leader>c :set cursorcolumn!<CR>
" %% as parent directory of current active file
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'				
"toggle hlsearch
noremap <F3> :set hlsearch! hlsearch?<CR>
"search visual selection with * and #
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
	"record @s, restore later
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
	let @s = temp
endfunction
" syntatic--------------------------------------------------------------------------------------
execute pathogen#infect()		
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"it's annoyint to check when write, i preffer manual check, especially for javascript
let g:syntastic_mode_map = {
			\ "mode": "passive",
			\ "active_filetypes": [],
			\ "passive_filetypes": [] }

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump = 1

let g:syntastic_javascript_closurecompiler_path = '/usr/bin/compiler.jar'
autocmd FileType javascript let b:syntastic_checkers = ['closurecompiler','jshint']
"autocmd FileType cpp let b:syntastic_checkers = ['gcc']
nnoremap <F7> :w<CR>:SyntasticCheck<CR>
nnoremap <space>j :lnext<CR>
nnoremap <space>k :lprevious<CR>
" ultisnips-------------------------------------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"ctrlp--------------------------------------------------------------
"change default to match file name in most rescent used files
let g:ctrlp_by_filename = 1
"enable cache
let g:ctrlp_use_caching = 1
"enable symbolic link
let g:ctrlp_follow_symlinks=1
"let g:ctrlp_cmd = 'CtrlPMRU'
"let g:ctrlp_extensions = ['tag']
"------------------------------------------------------------------------------
":%s/\d\+/\=printf("0x%04x", submatch(0))	    "to hex
"ycm option
let g:ycm_confirm_extra_conf = 0
nnoremap <SPACE>i :YcmCompleter GoToInclude<CR>
nnoremap <SPACE>d :YcmCompleter GoToDefinition<CR>
nnoremap <SPACE>c :YcmCompleter GoToDeclaration<CR>
" default ycm cfg file
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
"inoremap <c-m> ();<Left><Left>
abbreviate rq require('');<Left><Left><Left>
"set public|propteced|private to left most
set cinoptions=g0,N-s
"easyalign-------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" " Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)"

"project------------------------------------------------------
command! -nargs=0 Ps :mksession! script/session.vim|:wviminfo! script/pj.viminfo

"deprecated----------------------------------------------------
"quickfix do
"command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
"function! QuickfixFilenames()
	"let buffer_numbers = {}
	"for quickfix_item in getqflist()
		"let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
	"endfor
	"return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
"endfunction
"locationlist do, notneeded, ldo will do
"command! -nargs=0 -bar Largs execute 'args' LocationlistFilenames()
"function! LocationlistFilenames()
	"let buffer_numbers = {}
	""get location list of current window
	"for ll_item in getloclist(0)
		"let buffer_numbers[ll_item['bufnr']] = bufname(ll_item['bufnr'])
	"endfor
	"return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
"endfunction
