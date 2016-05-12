"python3
let g:python3_host_prog = "/usr/bin/python3"
"set the runtime path to include Vundle and initialize
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
set backupdir=~/.vimbak             "set backup dir
set history=500                         "keep 500 commands
set showcmd                     "display incomplete command in low right corner
set incsearch                   "toggle increment search
set number                      "show line number
set ignorecase
set smartcase                   "smart case
set matchtime=3      "stop at matching of something for 0.25 second
set fileencodings=utf-8,gbk,cp936       "add chinese support
set textwidth=80
"set termencoding=utf-8
"set encoding=utf-8
"set softtabstop=4              "set tab width to 4
set tabstop=4
set shiftwidth=4                "set shift width to 4
set expandtab           "always expand tab, tab is evil
set sessionoptions+=unix,slash  "use unix /, so the session can be open by both windows and unix
set hidden                      "allow hidden without trailing #
"set nowrap                     " no line wrap
set path+=/usr/local/include,**/**          "set up find path, find in all subdirectories
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P
let &backup = !has("vms")       "set auto backup
set cpoptions+=d                "let tags use current dir
set wildignore=*.o,tags,TAGS            "ignore obj files
set mps+=<:>                    "add match pair for < and >
let g:terminal_scrollback_buffer_size=5000
iab s8 --------------------------------------------------------------------------------

"terminal
:tnoremap <A-h> <C-\><C-n><C-w>h
:tnoremap <A-j> <C-\><C-n><C-w>j
:tnoremap <A-k> <C-\><C-n><C-w>k
:tnoremap <A-l> <C-\><C-n><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

"hi CursorLine   cterm=NONE ctermbg=lightblue ctermfg=white guibg=darkred guifg=white
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" heighlight current line
nnoremap <Leader>r :set cursorline!<CR>
" heighlight current column
nnoremap <Leader>c :set cursorcolumn!<CR>
" %% as parent directory of current active file
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> %t getcmdtype() == ':' ? expand('%:t').'/' : '%t'
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

autocmd FileType c,cpp,objc,vim setlocal shiftwidth=2 tabstop=2 expandtab textwidth=80
autocmd FileType sh setlocal textwidth=160
autocmd FileType cmake setlocal textwidth=160

"commands, all starts with J
"remov trailing white space
command! -nargs=0 JrmTrailingSpace :%s/\v\s*$//g
"save project information
command! -nargs=0 JsaveProject :mksession! script/session.vim

"plugins

set rtp+=~/.fzf
call plug#begin('~/.config/nvim/plugged')
"common
"Plug 'scrooloose/nerdtree'              "tree resource
"Plug 'scrooloose/syntastic'             "syntatic check
"Plug 'neomake/neomake'
"Plug 'Shougo/unite.vim'                "not quick enough, replaced by fzf
"Plug 'Shougo/neomru.vim'
"Plug 'Shougo/vimfiler.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  "awesommmmmmmmmmmmmmmme
Plug 'junegunn/fzf.vim'
Plug 'altercation/vim-colors-solarized'   "color scheme
"Plug 'majutsushi/tagbar'              "  replaced by fzf
Plug 'tpope/vim-surround'             " sourounding
Plug 'jiangmiao/auto-pairs'           " auto close pair
Plug 'docunext/closetag.vim'          " auto close tag
Plug 'scrooloose/nerdcommenter'       " comment helper
Plug 'SirVer/ultisnips'               " snippet manager
Plug 'honza/vim-snippets'             " snippets
Plug 'terryma/vim-multiple-cursors'   " multi curosr
Plug 'triglav/vim-visual-increment'   " number sequence
"Plug 'tpope/vim-abolish'              " never used
Plug 'rking/ag.vim'                   " grep
Plug 'junegunn/vim-easy-align'        " align
Plug 'kana/vim-operator-user'         " recomanded by vim-clang-format
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'peanutandchestnut/misc'
"git
Plug 'tpope/vim-fugitive'             " git wrapper
"c++ related
Plug 'Valloric/YouCompleteMe'         " auto complete
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'lyuts/vim-rtags'
"Plug 'Shougo/deoplete.nvim'
"Plug 'Shougo/neco-syntax'
"Plug 'Shougo/neco-vim'
Plug 'peanutandchestnut/mycpp'        "c++ implement , reorder, function objects
Plug 'rhysd/vim-clang-format'         "clang c/c++ format
"Plug 'xolox/vim-easytags'              "looks like abandomed, buggy
"Plug 'xolox/vim-misc'                  "needed for easytags
"Plug 'xolox/vim-shell'                 "needed for easytags asynchronous easytags
"opengl
Plug 'tikhomirov/vim-glsl'
"python
Plug 'klen/python-mode'
" javascript related
"Plug 'pangloss/vim-javascript'        " javascript support
"Plug 'othree/html5.vim'               " html5
Plug 'elzr/vim-json'                  " json
"Plug 'marijnh/tern_for_vim'           " javascript autocomplete support
"jade
Plug 'digitaltoad/vim-jade'           " jade syntax
call plug#end()

filetype plugin indent on               " required. To ignore plugin indent changes, instead use: filetype plugin on
" tagbar---------------------------------------------------------------------------------------
"nnoremap <c-j> :TagbarOpenAutoClose<CR>
"let g:TagbarOpenAutoClose = 1

" syntatic--------------------------------------------------------------------------------------
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"it's annoyint to check when write, i preffer manual check, especially for javascript
"let g:syntastic_mode_map = {
"\ "mode": "passive",
"\ "active_filetypes": [],
"\ "passive_filetypes": [] }

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_auto_jump = 1

"let g:syntastic_javascript_closurecompiler_path = '/usr/bin/compiler.jar'
"autocmd FileType javascript let b:syntastic_checkers = ['closurecompiler','jshint']
""autocmd FileType cpp let b:syntastic_checkers = ['gcc']
"nnoremap <F7> :w<CR>:SyntasticCheck<CR>
"nnoremap <space>j :lnext<CR>
"nnoremap <space>k :lprevious<CR>
" ultisnips-------------------------------------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"ctrlp--------------------------------------------------------------
"change default to match file name in most rescent used files
"let g:ctrlp_by_filename = 1
"let g:ctrlp_use_caching = 1
"let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
"let g:ctrlp_follow_symlinks=1
""let g:ctrlp_custom_ignore = {
""\ 'dir':  '\vgcc.*$',
""\ }
"let g:ctrlp_cmd = 'CtrlPMRU'
"let g:ctrlp_extensions = ['tag']
"------------------------------------------------------------------------------
"ycm option
let g:ycm_confirm_extra_conf = 0
"let g:ycm_server_python_interpreter = "/usr/bin/python3.5"
nnoremap <SPACE>i :YcmCompleter GoToInclude<CR>
nnoremap <SPACE>d :YcmCompleter GoToDefinition<CR>
nnoremap <SPACE>c :YcmCompleter GoToDeclaration<CR>
" default ycm cfg file
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax = 1
"easyalign-------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"easytags--------------------------------------------------------------------
"set tags=./tags;
"let g:easytags_dynamic_files = 1
"let g:easytags_async = 1
""create separate tags files for each file type in the configured directory
""g:easytags_dynamic_files take precedence over this option
"let g:easytags_by_filetype = "~/.config/nvim/ctags"
"let g:easytags_auto_highlight=0

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
noremap <leader>cf :ClangFormat<CR>

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
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"let g:NERDTreeBookmarksFile=$HOME.'/.cache/.NERDTreeBookmarks'
"let g:NERDTreeShowBookmarks=1
"let g:NERDTreeShowHidden=1
"let g:NERDTreeWinPos = "left"
"let NERDTreeIgnore=['\.swp$', '\~$', '\.pyproj$']

"noremap <Leader>nt :NERDTreeToggle<CR>
"noremap <Leader>nf :NERDTreeFind<CR>
"airline----------------------------------------------------------------------
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
"let g:Powerline_symbols = 'fancy'
"pymode-----------------------------------------------------------------------
let pymode = 1
let g:pymode_rope_completion = 0

"netrw
"Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
    let expl_win_num = bufwinnr(t:expl_buf_num)
    if expl_win_num != -1
      let cur_win_nr = winnr()
      exec expl_win_num . 'wincmd w'
      close
      exec cur_win_nr . 'wincmd w'
      unlet t:expl_buf_num
    else
      unlet t:expl_buf_num
    endif
  else
    exec '1wincmd w'
    Vexplore
    let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <leader>n :call ToggleVExplorer()<CR>

"deoplete----------------------------------------------------
"let g:deoplete#enable_at_startup = 1
"let g:deoplete#enable_smart_case = 1
"let g:deoplete#sources = {}
"let g:deoplete#sources._ = ['buffer']
"clang-complete----------------------------------------------

"unite-------------------------------------------------------
"nnoremap <m-u> :<c-u>Unite -start-insert file file_rec/neovim buffer file_mru<CR>
"let g:unite_source_rec_max_cache_files = 50000
"let g:unite_source_rec_async_command =
"\ ['ag', '--follow', '--nocolor', '--nogroup',
"\  '--hidden', '-g', '']

"fzf
nnoremap <c-p><c-p> :Files<CR>
nnoremap <c-p><c-f> :call <SID>fzf('find -L . -type f ! -path "*.hg/*" ! -path "*.git/*"', ':Files') <CR>
nnoremap <c-p><c-a> :call <SID>fzf('find -L . -type f', ':Files') <CR>
nnoremap <c-p><c-g> :GitFiles<CR>
"nnoremap <c-p><c-g>? :GitFiles?<CR>
nnoremap <c-p><c-b> :Buffers<CR>
"nnoremap <c-p><c-c> :Colors<CR>
"nnoremap <c-p><c-a> :Ag<CR>
nnoremap <c-p><c-l> :Lines<CR>
"nnoremap <c-p><c-b>l :BLines<CR>
nnoremap <c-p><c-t> :Tags<CR>
nnoremap <c-p><c-j> :BTags<CR>
"nnoremap <c-p><c-m> :Marks<CR>
nnoremap <c-p><c-w> :Windows<CR>
"nnoremap <c-p><c-l> :Locate<CR>
nnoremap <c-p><c-h> :History<CR>
nnoremap <c-p><c-:> :History:<CR>
nnoremap <c-p><c-<>c-/> :History/<CR>
nnoremap <c-p><c-s> :Snippets<CR>
"nnoremap <c-p><c-c> :Commits<CR>
"nnoremap <c-p><c-b>c :BCommits<CR>
nnoremap <c-p><c-c> :Commands<CR>
nnoremap <c-p><c-m> :Maps<CR>
"nnoremap <c-p>h :Helptags<CR>
"nnoremap <c-p>f :Filetypes<CR>

function! s:fzf(fzf_default_cmd, cmd)
  let oldcmds = $FZF_DEFAULT_COMMAND | try
  let $FZF_DEFAULT_COMMAND = a:fzf_default_cmd
  execute a:cmd
  finally | let $FZF_DEFAULT_COMMAND = oldcmds | endtry
endfunction
