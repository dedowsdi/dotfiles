set nocompatible		
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim,~/.vim/misc
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
syntax enable                   " turn syntax highlighting on by default
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
set path+=/usr/local/include,**/**			"set up find path, find in all subdirectories
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P
let &backup = !has("vms")		"set auto backup
set cpoptions+=d				"let tags use current dir
set wildignore=*.o,tags,TAGS			"ignore obj files
set mps+=<:>                    "add match pair for < and >

"hi CursorLine   cterm=NONE ctermbg=lightblue ctermfg=white guibg=darkred guifg=white		
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white		
" heighlight current line
nnoremap <Leader>r :set cursorline!<CR>
" heighlight current column
nnoremap <Leader>c :set cursorcolumn!<CR>
" %% as parent directory of current active file
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'				
"toggle hlsearch
noremap <F3> :set hlsearch! hlsearch?<CR>
"toggle paste
nnoremap <Leader>p :set paste! paste?<CR>
"search visual selection with * and #
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
"replace word, WORD, use \v mode
nnoremap <Leader>sw :%s/\v<>/
nnoremap <Leader>sW :%s/\v<>/
"replace selection, us \V mode
xnoremap <Leader>s :<C-u>%s/\V=<SID>getVisual()/

function! s:getVisual()
	"record @s, restore later
	let temp = @s
    norm! gv"sy
	let str = @s
    let @s = temp
    return str
endfunction

function! s:VSetSearch()
	"record @s, restore later
	let @/ = '\V' . substitute(escape(s:getVisual(), '/\'), '\n', '\\n', 'g')
endfunction

autocmd FileType c,cpp,objc,vim setlocal shiftwidth=2 
autocmd FileType c,cpp,objc,vim setlocal tabstop=2
autocmd FileType c,cpp,objc,vim setlocal expandtab 
autocmd FileType c,cpp,objc,vim setlocal textwidth=80
"project------------------------------------------------------
command! -nargs=0 Ps :mksession! script/session.vim|:wviminfo! script/pj.viminfo

"plugins
filetype off		

call vundle#begin()				" alternatively, pass a path as  vundle#begin('~/some/path/here') 
"common
Plugin 'VundleVim/Vundle.vim'			" let Vundle manage Vundle
Plugin 'scrooloose/nerdtree'			" tree resource
Plugin 'scrooloose/syntastic'			" syntatic check
Plugin 'ctrlpvim/ctrlp.vim'					" file search 
Plugin 'altercation/vim-colors-solarized'	" color scheme
Plugin 'majutsushi/tagbar'				" outline
Plugin 'tpope/vim-surround'				" sourounding
Plugin 'jiangmiao/auto-pairs'			" auto close pair
Plugin 'docunext/closetag.vim'			" auto close tag
Plugin 'scrooloose/nerdcommenter'		" comment helper
Plugin 'SirVer/ultisnips'				" snippet manager 
Plugin 'honza/vim-snippets'				" snippets
Plugin 'terryma/vim-multiple-cursors'	" multi curosr
Plugin 'triglav/vim-visual-increment'	" number sequence
Plugin 'tpope/vim-abolish'				" substitute
Plugin 'mileszs/ack.vim'				" regex find
Plugin 'junegunn/vim-easy-align'	    " align
Plugin 'kana/vim-operator-user'			" recomanded by vim-clang-format
"git
Plugin 'tpope/vim-fugitive'				" git wrapper
"c++ related
Plugin 'Valloric/YouCompleteMe'			" auto complete
Plugin 'peanutandchestnut/mycpp'		"c++ implement , reorder, function objects
Plugin 'rhysd/vim-clang-format'			"clang c/c++ format
Plugin 'xolox/vim-easytags'				  "easy ctags
Plugin 'xolox/vim-misc'					  "need for easytags
Plugin 'xolox/vim-shell'				  "needed for asynchronous easytags
"opengl
Plugin 'tikhomirov/vim-glsl'
"python
Plugin 'klen/python-mode'
" javascript related
Plugin 'pangloss/vim-javascript'		" javascript support
Plugin 'othree/html5.vim'				" html5
Plugin 'elzr/vim-json'					" json
Plugin 'marijnh/tern_for_vim'			" javascript autocomplete support
"jade
Plugin 'digitaltoad/vim-jade'			" jade syntax
call vundle#end()						" All of your Plugins must be added before this line

filetype plugin indent on				" required. To ignore plugin indent changes, instead use: filetype plugin on
" tagbar---------------------------------------------------------------------------------------
nnoremap <c-j> :TagbarOpenAutoClose<CR>
let g:TagbarOpenAutoClose = 1

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
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_follow_symlinks=1
"let g:ctrlp_custom_ignore = {
      "\ 'dir':  '\vgcc.*$',
      "\ }
"let g:ctrlp_cmd = 'CtrlPMRU'
"let g:ctrlp_extensions = ['tag']
"------------------------------------------------------------------------------
"ycm option
let g:ycm_confirm_extra_conf = 0
nnoremap <SPACE>i :YcmCompleter GoToInclude<CR>
nnoremap <SPACE>d :YcmCompleter GoToDefinition<CR>
nnoremap <SPACE>c :YcmCompleter GoToDeclaration<CR>
" default ycm cfg file
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
"inoremap <c-m> ();<Left><Left>
"easyalign-------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"easytags--------------------------------------------------------------------
" automatically create a project specific tags file based on the first name in
" the 'tags' option.
let g:easytags_dynamic_files = 2		
let g:easytags_async = 1
"create separate tags files for each file type in the configured directory
"g:easytags_dynamic_files take precedence over this option
let g:easytags_by_filetype = "~/.vim/ctags"

"vim-clang-format-----------------------------------------------------------
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -2,
            \ "AllowShortFunctionsOnASingleLine" : "true",
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AllowShortLoopsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "AlignAfterOpenBracket" : "false",
            \ "ContinuationIndentWidth" : 4,
            \ "IndentWidth" : 2, 
            \ "TabWidth" : 2,
            \ "UseTab" : "Never",
            \ "Standard" : "C++11"
            \}
nnoremap <leader>cf :ClangFormat<CR>

"solarized-------------------------------------------------------------------
"g:solarized_termcolors= 16 | 256 g:solarized_termtrans = 0 | 1
"g:solarized_degrade = 0 | 1 g:solarized_bold = 1 | 0 g:solarized_underline = 1
"| 0 g:solarized_italic = 1 | 0 g:solarized_contrast = “normal”| “high” or “low”
"g:solarized_visibility= “normal”| “high” or “low” ————————————————
set t_Co=16
set background=dark
colorscheme solarized
"nerdtree
"autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeBookmarksFile=$HOME.'/.cache/.NERDTreeBookmarks'
let g:NERDTreeShowBookmarks=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinPos = "left"
noremap <Leader>nt :NERDTreeToggle<CR>
noremap <Leader>nf :NERDTreeFind<CR>
