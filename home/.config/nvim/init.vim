" Remove ALL autocommands for the current group.
"autocmd!
let g:python3_host_prog = "/usr/bin/python3"

" ------------------------------------------------------------------------------
" basic setting
" ------------------------------------------------------------------------------
if has("Win32")
   let &shada = "!,'200,<50,s10,h,rA:,rB:"
else
   let &shada="!,'200,<50,s10,h"
endif
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
set wildmode=longest,list       "just like bash
set mps+=<:>                    "add match pair for < and >
set pastetoggle=<F9>
set nrformats=octal,hex,bin
let g:terminal_scrollback_buffer_size=5000
iab s8 --------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" map
" <leader>f start map will be saved for project specific map
" ------------------------------------------------------------------------------

"nvim cfg 
nnoremap __ :edit ~/.config/nvim/init.vim<CR>

"vertical block until chop
nmap _j <c-v>_j
nmap _k <c-v>_k
"vertical block with start not at cursor
vnoremap _j :<c-u>call misc#visualEnd("misc#verticalSearch", {"direction":"j", "greedy":1})<cr>
vnoremap _k :<c-u>call misc#visualEnd("misc#verticalSearch", {"direction":"k", "greedy":1})<cr>

" quickfix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" args
nnoremap ]a :next<cr>
nnoremap [a :prev<cr>

" tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

"terminal
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
tnoremap <C-\><C-n> <C-\><C-n>?\S<CR>
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <m-cr> :call misc#term#terminal({"layout":"L", "size":0.5})<CR>
tnoremap <m-cr> <c-\><c-n>:call misc#term#terminal()<CR>

" %% as parent directory of current active file
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> %t getcmdtype() == ':' ? expand('%:t').'/' : '%t'

" visual search
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
" replace word, WORD, use \v regex mode
" TODO escape \
nnoremap <Leader>sw :%s/\v<>/
nnoremap <Leader>sW :%s/\v<>/
" replace selection, us \V regex mode
xnoremap <Leader>s :<C-u>%s/\V=escape(<SID>getVisual(), '/\')/

" highlight
nnoremap <Leader>hr :set cursorline!<CR>
nnoremap <Leader>hc :set cursorcolumn!<CR>
noremap <F3> :set hlsearch! hlsearch?<CR>

nnoremap <Leader>ww :call <SID>smartSplit()<CR>

" google
nnoremap <Leader>G :call <SID>google(expand('<cword>'))<CR>
vnoremap <Leader>G :<c-u>execute 'Google ' . <SID>getVisual('s')<CR>

" shift
nnoremap <Leader>[ :call misc#shiftItem({"direction":"h"})<CR>
nnoremap <Leader>] :call misc#shiftItem({"direction":"l"})<CR>

" option cycle and toggle
nnoremap <F10> :call <SID>cycleOption("virtualedit", ['', 'all'])<CR>

"text object
vnoremap aa :<C-U>silent! call misc#selCurArg({})<CR>
vnoremap ia :<C-U>silent! call misc#selCurArg({"excludeSpace":1})<CR>
onoremap aa :normal vaa<CR>
onoremap ia :normal via<CR>
vnoremap am :<C-U>silent! call misc#selectSmallWord()<CR>
onoremap am :normal vam<CR>
vnoremap im :<C-U>silent! call misc#selectSmallWord()<CR>
onoremap im :normal vam<CR>

"some cpp head file has no extension
:nnoremap <leader>t :set filetype=cpp<CR>

" ------------------------------------------------------------------------------
" small functions
" ------------------------------------------------------------------------------
function! s:smartSplit()
  let direction = str2float(winwidth(0))/winheight(0) >= 204.0/59 ? 'vsplit':'split'
  exec 'rightbelow ' . direction
endfunction

"[type:s]
function! s:getVisual(...)
  let type = get(a:000, 0, ' ')
  let temp = @s|norm! gv"sy
  if type == 's'
    let temp = substitute(temp, '\n', ' ', 'g')
  endif
  let [str,@s] = [@s,temp] | return str
endfunction

function! s:VSetSearch()
  "record @s, restore later
  let @/ = '\V' . escape(s:getVisual(), '/\')
endfunction

" search in chrome
function! s:google(...)
  if len(a:000) == 0|return|endif
  let searchItems = join(a:000, "+")
  silent! execute '!google-chrome https://www.google.com/\#q=' . searchItems . '>/dev/null'
endfunction

function! s:cycleOption(name, list)
    exec 'let curValue = &'.a:name
    let [index, numValues] = [match(a:list, curValue), len(a:list)]
    let newValue = a:list[(index + 1)%numValues]
    exec 'let &'.a:name.' = newValue '
    echom a:name . ' : ' . newValue
endfunction

" ------------------------------------------------------------------------------
" command
" ------------------------------------------------------------------------------
command! -nargs=0 JrmTrailingSpace :%s/\v\s*$//g
command! -nargs=0 JrmConsecutiveBlankLines :%s/\v%(^\s*\n){1,}/\r/ge
command! -nargs=0 JrmGarbages :JrmTrailingSpace | JrmConsecutiveBlankLines
command! -nargs=0 JrmBlankLines :%s/\v^\s*$\n//ge
"save project information
command! -nargs=0 JsaveProject :mksession! script/session.vim
command! -nargs=+ Google :call <SID>google(<f-args>)
"super write
command! -nargs=0 SW :w !sudo tee % > /dev/null

"TODO this setting was overwrited by some plugin, figure out which one.  This
"job is current done in misc#misc
autocmd FileType c,cpp,objc,vim,glsl setlocal shiftwidth=2 tabstop=2 expandtab textwidth=80
autocmd FileType json setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType sh setlocal textwidth=160
autocmd FileType cmake setlocal textwidth=160


" ------------------------------------------------------------------------------
" plugin
" ------------------------------------------------------------------------------
set rtp+=~/.fzf,./vimScript
call plug#begin('~/.config/nvim/plugged')
"common
"Plug 'scrooloose/nerdtree'             "tree resource
"Plug 'scrooloose/syntastic'            "syntatic check
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  "awesommmmmmmmmmmmmmmme
Plug 'junegunn/fzf.vim'
Plug 'altercation/vim-colors-solarized'   "color scheme
Plug 'tpope/vim-surround'             " sourounding
"Plug 'jiangmiao/auto-pairs'           " auto close pair
"Plug 'docunext/closetag.vim'          " auto close tag
Plug 'scrooloose/nerdcommenter'       " comment helper
Plug 'SirVer/ultisnips'               " snippet
Plug 'honza/vim-snippets'             " snippets
Plug 'terryma/vim-multiple-cursors'   " multi curosr
Plug 'triglav/vim-visual-increment'   " number sequence
"Plug 'tpope/vim-abolish'              " never used
Plug 'junegunn/vim-easy-align'         " align
"Plug 'kana/vim-operator-user'         " recomanded by vim-clang-format
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'peanutandchestnut/misc'
"git
"Plug 'tpope/vim-fugitive'             " git wrapper
"c++ related
Plug 'Valloric/YouCompleteMe'         " auto complete
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
"Plug 'lyuts/vim-rtags'
"Plug 'Shougo/deoplete.nvim'
"Plug 'Shougo/neco-syntax'
"Plug 'Shougo/neco-vim'
Plug 'peanutandchestnut/mycpp'        "c++ implement , reorder, function objects
Plug 'peanutandchestnut/ogre2script'
Plug 'rhysd/vim-clang-format'         "clang c/c++ format
"python
Plug 'klen/python-mode'
" javascript related
Plug 'pangloss/vim-javascript'        " javascript support
Plug 'othree/html5.vim'               " html5
Plug 'elzr/vim-json'                  " json
"Plug 'marijnh/tern_for_vim'           " javascript autocomplete support
"syntax
"Plug 'digitaltoad/vim-jade'           " jade syntax
Plug 'tikhomirov/vim-glsl'
call plug#end()

"filetype plugin indent on               " required. To ignore plugin indent changes, instead use: filetype plugin on

" ------------------------------------------------------------------------------
" syntatic
" ------------------------------------------------------------------------------
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

" ------------------------------------------------------------------------------
" ultisnips
" ------------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<m-k>"
let g:UltiSnipsJumpForwardTrigger="<Down>"
let g:UltiSnipsJumpBackwardTrigger="<Up>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" ------------------------------------------------------------------------------
" ycm
" ------------------------------------------------------------------------------
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_of_chars_for_completion = 3
"let g:ycm_auto_trigger = 0
"let g:ycm_semantic_triggers = {'c':[], 'cpp':[]}
let g:ycm_server_python_interpreter = "/usr/bin/python3.5"
nnoremap <SPACE>i :YcmCompleter GoToInclude<CR>
nnoremap <SPACE>d :YcmCompleter GoToDefinition<CR>
nnoremap <SPACE>c :YcmCompleter GoToDeclaration<CR>
" default ycm cfg file
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax = 1

nnoremap <leader>yd :YcmDiags<CR>
"C-F7 
nnoremap <F31> :YcmDiags<CR>

" ------------------------------------------------------------------------------
" easyalign
" ------------------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ------------------------------------------------------------------------------
" vim-clang-format
" ------------------------------------------------------------------------------
let g:clang_format#style_options = {
      \ "AccessModifierOffset" : -2,
      \ "AllowShortFunctionsOnASingleLine" : "true",
      \ "AllowShortIfStatementsOnASingleLine" : "true",
      \ "AllowShortLoopsOnASingleLine" : "true",
      \ "AlwaysBreakTemplateDeclarations" : "true",
      \ "AlignAfterOpenBracket" : "false",
      \ "ContinuationIndentWidth" : 2,
      \ "IndentWidth" : 2,
      \ "TabWidth" : 2,
      \ "UseTab" : "Never",
      \ "Standard" : "C++11",
      \ "SortIncludes": "false",
      \}
noremap <leader>cf :ClangFormat<CR>

" ------------------------------------------------------------------------------
" solarized
" ------------------------------------------------------------------------------
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
" ------------------------------------------------------------------------------
" pymode
" ------------------------------------------------------------------------------
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

" ------------------------------------------------------------------------------
" deoplete
" ------------------------------------------------------------------------------
"let g:deoplete#enable_at_startup = 1
"let g:deoplete#enable_smart_case = 1
"let g:deoplete#sources = {}
"let g:deoplete#sources._ = ['buffer']
"clang-complete----------------------------------------------

" ------------------------------------------------------------------------------
" unite
" ------------------------------------------------------------------------------
"nnoremap <m-u> :<c-u>Unite -start-insert file file_rec/neovim buffer file_mru<CR>
"let g:unite_source_rec_max_cache_files = 50000
"let g:unite_source_rec_async_command =
"\ ['ag', '--follow', '--nocolor', '--nogroup',
"\  '--hidden', '-g', '']

" ------------------------------------------------------------------------------
" fzf
" ------------------------------------------------------------------------------
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vertical rightbelow split',
      \ 'ctrl-a': 'argedit',
      \ 'ctrl-o': '!gvfs-open',
      \ 'ctrl-q': '!qapitrace'
      \ }
let g:fzf_layout = {"up":'~40%'}
nnoremap <c-p><c-p> :Files<CR>
nnoremap <c-p><c-f> :call <SID>fzf('find -L . -type f ! -path "*.hg/*" ! -path "*.git/*"', ':Files') <CR>
nnoremap <c-p><c-a> :call <SID>fzf('find -L . -type f', ':Files') <CR>
nnoremap <c-p><c-g> :GitFiles<CR>
"nnoremap <c-p><c-g>? :GitFiles?<CR>
nnoremap <c-p><c-b> :Buffers<CR>
"nnoremap <c-p><c-c> :Colors<CR>
"nnoremap <c-p><c-a> :Ag<CR>
"nnoremap <c-p><c-l> :Lines<CR>
nnoremap <c-p><c-l> :BLines<CR>
nnoremap <c-p><c-t> :Tags<CR>
nnoremap <c-p><c-j> :BTags<CR>
autocmd! FileType cpp  nnoremap <buffer> <c-p><c-j> : call <SID>fzf_cpp_tags()<CR>
"nnoremap <c-p><c-j> :BTags<CR>
"nnoremap <c-p><c-m> :Marks<CR>
nnoremap <c-p><c-w> :Windows<CR>
"nnoremap <c-p><c-l> :Locate<CR>
nnoremap <c-p><c-h> :History<CR>
"nnoremap <c-p><c-;> :History:<CR>
"nnoremap <c-p><c-/> :History/<CR>
nnoremap <c-p><c-s> :Snippets<CR>
"nnoremap <c-p><c-c> :Commits<CR>
"nnoremap <c-p><c-b>c :BCommits<CR>
nnoremap <c-p><c-c> :Commands<CR>
nnoremap <c-p><c-m> :Maps<CR>
"nnoremap <c-p>h :Helptags<CR>
"nnoremap <c-p>f :Filetypes<CR>

autocmd! VimEnter * command! -nargs=* -complete=file Ag :call s:fzf_ag_raw(<q-args>)
command! -nargs=* -complete=file Ae :call s:fzf_ag_expand(<q-args>)
"TODO add map to search visual content

"add function prototype to c++. language-force is needed when c++ head has no
"extension
let s:fzf_btags_cmd = 'ctags -f - --sort=no --excmd=number --c++-kinds=+p  --language-force='
let s:fzf_btags_options = {'options' : '--reverse -m -d "\t" --with-nth 1,4.. -n 1,-1 --prompt "BTags> "'}
function! s:fzf_cpp_tags()
  let ft = &filetype 
  if ft == 'cpp' | let ft = 'c++'  | endif
  call fzf#vim#buffer_tags(
        \ "",[s:fzf_btags_cmd . ft . ' ' . expand('%:S')],
        \ extend(copy(g:fzf_layout), s:fzf_btags_options))
endfunction

function! s:fzf(fzf_default_cmd, cmd)
  let oldcmds = $FZF_DEFAULT_COMMAND | try
    let $FZF_DEFAULT_COMMAND = a:fzf_default_cmd
    execute a:cmd
  finally | let $FZF_DEFAULT_COMMAND = oldcmds | endtry
endfunction

function! s:fzf_ag_raw(cmd)
  "--noheading is needed to display filename for Ag something %
  "--noheading will add blanklines if you didn't search in a specific file, you
  "need no break to stop it.
  call fzf#vim#ag_raw(' --noheading '. a:cmd)
endfunction

" some path is ignored by git or hg, i need to use absolute path to avoid that.
function! s:fzf_ag_expand(cmd)
  let matches = matchlist(a:cmd, '\v(.{-})(\S*)\s*$')
  " readlink, remove trailing linebreak
  let ecmd = matches[1] . system("readlink -f " . matches[2])[0:-2]
  call s:fzf_ag_raw(ecmd)
endfunction

" ------------------------------------------------------------------------------
" rtags
" ------------------------------------------------------------------------------
let g:rtagsLog = '~/tmp/rtaglog'
let g:neomake_open_list = 2

" ------------------------------------------------------------------------------
" neomake
" ------------------------------------------------------------------------------
let g:neomake_make_maker = {
    \ 'exe': 'make',
    \ 'args': ['--build'],
    \ 'errorformat': '%f:%l:%c: %m',
    \ }
"let g:neomake_cpp_enable_makers = ['clang']
"let g:neomake_cpp_clang_maker = {
            "\ 'exe' : 'clang'
            "\ }
