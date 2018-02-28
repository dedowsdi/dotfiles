" Remove ALL autocommands for the current group.
"autocmd!

" ------------------------------------------------------------------------------
" basic setting
" ------------------------------------------------------------------------------
if has('nvim')
  let g:python3_host_prog = '/usr/bin/python3'
endif
let &shada="'200,<50,s10,h"

if 'linux' ==# $TERM
  let s:term = 'linux'
else
  if has('unix')
    call system('grep -q "Microsoft" /proc/version')
    if v:shell_error == 0
      let s:term = 'wsl_xterm'
    else
      let s:term = 'unix_xterm'
    endif
  else
    let s:term = "unknown"
  endif
endif

set autoindent                  " set auto-indenting on for programming
set showmatch                   " autoshow matching brackets. works like it does in bbedit.
set visualbell                  " turn on "visual bell" - which is much quieter than "audio blink"
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
set matchtime=3                 "stop at matching of something for 0.3 second
set fileencodings=ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1
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
set path+=/usr/local/include,**     "set up find path, find in all subdirectories
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P
let &backup = !has('vms')       "set auto backup
set cpoptions+=d                "let tags use current dir
set wildignore=*.o,tags,TAGS            "ignore obj files
set wildmode=longest,list       "just like bash
set mps+=<:>                    "add match pair for < and >
set pastetoggle=<F9>
set nrformats=octal,hex,bin
set cinoptions=l1               " case indent
set mouse=a                     " always use mouse
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

if has('nvim')
  let g:terminal_scrollback_buffer_size=5000
endif

" vnoremap GL y:call GrepLiteral(@")<CR>

function! GrepLiteral(str)
  exec printf('grep -F %s', myvim#literalize(a:str, 0))
endfunction

vnoremap <leader>lv y:let @"=myvim#literalize(@", 0)<CR>
vnoremap <leader>lg y:let @"=myvim#literalize(@", 1)<CR>
vnoremap <leader>lf y:let @"=myvim#literalize(@", 2)<CR>

" ------------------------------------------------------------------------------
" map
" ------------------------------------------------------------------------------

nnoremap Y y$

"nvim cfg 
if has('nvim')
  nnoremap __ :edit ~/.config/nvim/init.vim<CR>
else
  nnoremap __ :edit ~/.vimrc<CR>
endif

"vertical block until chop
nmap _j <c-v>_j
nmap _k <c-v>_k
"vertical block with start not at cursor
vnoremap _j :<c-u>call myvim#visualEnd("myvim#verticalSearch", {'direction':'j', 'greedy':1})<cr>
vnoremap _k :<c-u>call myvim#visualEnd("myvim#verticalSearch", {'direction':'k', 'greedy':1})<cr>

" quickfix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]d :call <sid>rm_qf_item()<cr>
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
"tnoremap <C-\><C-n> <C-\><C-n>?\S<CR>
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
tnoremap <C-n> <C-\><C-n>

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
xnoremap <Leader>s :<C-u>%s/\V=escape(myvim#getVisualString(), '/\')/

" highlight
nnoremap <Leader>hr :set cursorline!<CR>
nnoremap <Leader>hc :set cursorcolumn!<CR>
noremap <F3> :set hlsearch! hlsearch?<CR>

nnoremap <Leader>ww :call <SID>smartSplit()<CR>

" google
nnoremap <Leader>G :call <SID>google(expand('<cword>'))<CR>
vnoremap <Leader>G :<c-u>execute 'Google ' . myvim#getVisualString()<CR>

" shift
nnoremap <Leader>[ :call myvim#shiftItem({'direction':'h'})<CR>
nnoremap <Leader>] :call myvim#shiftItem({'direction':'l'})<CR>

" option cycle and toggle
nnoremap <F10> :call <SID>cycleOption('virtualedit', ['', 'all'])<CR>

"text object
vnoremap aa :<C-U>silent! call myvim#selCurArg({})<CR>
vnoremap ia :<C-U>silent! call myvim#selCurArg({'excludeSpace':1})<CR>
onoremap aa :normal vaa<CR>
onoremap ia :normal via<CR>
vnoremap am :<C-U>silent! call myvim#selectSmallWord()<CR>
onoremap am :normal vam<CR>
vnoremap im :<C-U>silent! call myvim#selectSmallWord()<CR>
onoremap im :normal vam<CR>

if $TERM == 'linux'
  vnoremap \y y:call <SID>set_clipboard(@")<CR>
endif

"it should be \tv, but v is not convinent
"noremap <leader>tt :call <SID>tagSplit('', 'v')<CR>
"noremap <leader>th :call <SID>tagSplit('', 'h')<CR>

" split open first exact match
" itemName, 'v'|'h'
function! s:tagSplit(itemName, splitType)
  let items = taglist('^'.a:itemName.'$')
  if len(items) < 1
    echo a:itemName . ' not found'    
    return
  endif
  let splitCmd = a:splitType ==# 'v' ? 'rightbelow vsplit' : 'sp'
  exec splitCmd items[0].filename
  exec items[0].cmd
  normal! zz
endfunction

" ------------------------------------------------------------------------------
" small functions
" ------------------------------------------------------------------------------
function! s:smartSplit()
  let direction = str2float(winwidth(0))/winheight(0) >= 204.0/59 ? 'vsplit':'split'
  exec 'rightbelow ' . direction
endfunction

function! s:VSetSearch()
  "record @s, restore later
  let @/ = '\V' . myvim#literalize(myvim#getVisualString(), 0)
endfunction

" search in chrome
function! s:google(...)
  if len(a:000) == 0|return|endif
  let searchItems = join(a:000, '+')
  let cmd = 'google-chrome https://www.google.com/\#q=' . searchItems . '>/dev/null'
  if has('nvim')
    call jobstart(cmd)
  else
    silent! execute '!' . cmd
  endif
endfunction

function! s:cycleOption(name, list)
    let curValue = '' " for vint only
    exec 'let curValue = &'.a:name
    let [index, numValues] = [match(a:list, curValue), len(a:list)]
    let newValue = a:list[(index + 1)%numValues]
    exec 'let &'.a:name.' = newValue '
    echom a:name . ' : ' . newValue
endfunction

function! s:reverse_qf_list()
  call setqflist(reverse(getqflist()))
endfunction

function! s:rm_qf_item(...)
  let idx = get(a:000, 0, line('.') - 1)
  let l = getqflist()
  if idx >= len(l)
    echoe 'index overflow'
    return
  endif
  call remove(l, idx)
  call setqflist(l)
  call cursor(idx+1, 1)
endfunction

function! s:set_clipboard(str)
  let s = myvim#literalize(a:str, 2)
  call system(printf("echo '%s' | DISPLAY=:0 xsel -i", s))
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
command! -nargs=0 CreverseQuickfixList call <SID>reverse_qf_list()
"view pdf
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk -layout <q-args> -
:command! -complete=file -nargs=1 Rpdffmt :r !pdftotext -nopgbrk -layout <q-args> - |fmt -csw78

autocmd CmdwinEnter * noremap <buffer> <CR> <CR>q:

" ------------------------------------------------------------------------------
" plugin
" ------------------------------------------------------------------------------
set rtp+=~/.fzf
call plug#begin('~/.config/nvim/plugged')
" common
Plug 'scrooloose/syntastic'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'junegunn/seoul256.vim'
Plug 'dracula/vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'             " snippets used in ultisnips
Plug 'terryma/vim-multiple-cursors'
Plug 'triglav/vim-visual-increment'
"Plug 'tpope/vim-abolish'              " never used
"Plug 'kana/vim-operator-user'         " recomanded by vim-clang-format
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe'         " auto complete
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
" my own
Plug 'peanutandchestnut/misc'
Plug 'peanutandchestnut/cdef'
" git
"Plug 'tpope/vim-fugitive'             " git wrapper
"c++ related
"Plug 'lyuts/vim-rtags'
"Plug 'Shougo/deoplete.nvim'
"Plug 'Shougo/neco-syntax'
"Plug 'Shougo/neco-vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'         "clang c/c++ format
"python
Plug 'klen/python-mode'
" javascript related
Plug 'pangloss/vim-javascript'        
Plug 'othree/html5.vim'               
Plug 'elzr/vim-json'                  
"Plug 'mattn/emmet-vim'
"Plug 'marijnh/tern_for_vim'           " javascript autocomplete support
"syntax
"Plug 'digitaltoad/vim-jade'           " jade syntax
Plug 'tikhomirov/vim-glsl'
Plug 'lervag/vimtex'                   " latex
call plug#end()

" ------------------------------------------------------------------------------
" syntatic
" ------------------------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"disable check when write
let g:syntastic_mode_map = {
\ 'mode': 'passive',
\ 'active_filetypes': ['sh'],
\ 'passive_filetypes': [] }

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
"let g:syntastic_auto_jump = 1

"let g:syntastic_javascript_closurecompiler_path = '/usr/bin/compiler.jar'
"autocmd FileType javascript let b:syntastic_checkers = ['closurecompiler','jshint']

let g:syntastic_shl_checkers = ['shellcheck']
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_glsl_checkers = ['glslang']
let g:syntastic_glsl_extensions = {
            \ 'vs.glsl': 'gpu_vp',
            \ 'fs.glsl': 'gpu_fp'
            \ }

nnoremap <F31> :w <bar> call SyntasticCheck()<CR>

" ------------------------------------------------------------------------------
" ultisnips
" ------------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger='<m-k>'
let g:UltiSnipsJumpForwardTrigger='<Down>'
let g:UltiSnipsJumpBackwardTrigger='<Up>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'

" ------------------------------------------------------------------------------
" ycm
" ------------------------------------------------------------------------------
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_of_chars_for_completion = 3
"let g:ycm_auto_trigger = 0
"let g:ycm_semantic_triggers = {'c':[], 'cpp':[]}
let g:ycm_server_python_interpreter = '/usr/bin/python3'
nnoremap <leader>ygi :YcmCompleter GoToInclude<CR>
nnoremap <leader>ygd :YcmCompleter GoToDefinition<CR>
nnoremap <F12> :YcmCompleter GoToDeclaration<CR>
" default ycm cfg file
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax = 1

nnoremap <leader>yd :YcmShowDetailedDiagnostic<CR>
"nnoremap <F31> :YcmDiags<CR>

" ------------------------------------------------------------------------------
" easyalign
" ------------------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ------------------------------------------------------------------------------
" vim-clang-format
" ------------------------------------------------------------------------------
let g:clang_format#style_options = {
      \ 'AccessModifierOffset' : -2,
      \ 'AllowShortFunctionsOnASingleLine' : 'true',
      \ 'AllowShortIfStatementsOnASingleLine' : 'true',
      \ 'AllowShortLoopsOnASingleLine' : 'true',
      \ 'AlwaysBreakTemplateDeclarations' : 'true',
      \ 'AlignAfterOpenBracket' : 'false',
      \ 'ContinuationIndentWidth' : 2,
      \ 'IndentWidth' : 2,
      \ 'TabWidth' : 2,
      \ 'UseTab' : 'Never',
      \ 'Standard' : 'C++11',
      \ 'SortIncludes': 'false',
      \}
noremap <leader>cf :ClangFormat<CR>

" ------------------------------------------------------------------------------
" solarized
" ------------------------------------------------------------------------------
if $TERM != 'linux'
  set t_Co=256
endif

" only use solarized in linux

if s:term ==# 'linux' || s:term ==# 'unix_xterm'
  colorscheme solarized
elseif s:term ==# 'wsl_xterm'
  set termguicolors
  colorscheme solarized8_dark
else
  let g:seoul256_background=236
  colorscheme seoul256
endif

" ------------------------------------------------------------------------------
" airline
" ------------------------------------------------------------------------------
"let g:Powerline_symbols = 'fancy'
if s:term ==# 'unix_xterm' || s:term ==# 'linux'
  let g:airline_theme='solarized'
  let g:airline_powerline_fonts = 1
else
  let g:airline_symbols_ascii = 1
endif
" ------------------------------------------------------------------------------
" pymode
" ------------------------------------------------------------------------------
let pymode = 1
let g:pymode_rope_completion = 0

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
      \ 'ctrl-a': 'argadd',
      \ 'ctrl-o': '!gvfs-open',
      \ 'ctrl-q': '!qapitrace'
      \ }
let g:fzf_layout = {'up':'~40%'}
" project file, exclude hg, git, build
nnoremap <c-p><c-p> :call <SID>fzf('find  . -type f ! -path "*.hg/*" ! -path "*.git/*" ! -path "*/build/*"', ':Files') <CR>
" all project file
nnoremap <c-p><c-e> :call <SID>fzf('find  . -type f ', ':Files') <CR>
" project file, exclude hg, git, build. Follow symbolic.
nnoremap <c-p><c-f> :call <SID>fzf('find -L . -type f ! -path "*.hg/*" ! -path "*.git/*" ! -path "*/build/*"', ':Files') <CR>
" all project file. Follow symbolic.
nnoremap <c-p><c-a> :call <SID>fzf('find -L . -type f', ':Files') <CR>
nnoremap <c-p><c-g> :GitFiles<CR>
"nnoremap <c-p><c-g>? :GitFiles?<CR>
nnoremap <c-p><c-b> :Buffers<CR>
"nnoremap <c-p><c-c> :Colors<CR>
"nnoremap <c-p><c-a> :Ag<CR>
"nnoremap <c-p><c-l> :Lines<CR>
nnoremap <c-p><c-l> :BLines<CR>
nnoremap <c-p><c-t> :Tags<CR>
command! -nargs=* Ctags :call <SID>fzf_cpp_tags(<q-args>)
nnoremap <c-p><c-k> :Ctags<CR>
nnoremap <c-p><c-j> :BTags<CR>
autocmd! FileType cpp,glsl nnoremap <buffer> <c-p><c-j> :call <SID>fzf_cpp_btags()<CR>
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
nnoremap <F36> :call <SID>fzf_search_tag(expand('<cword>'), {'kind':'p'})<CR>

autocmd! VimEnter * command! -nargs=* -complete=file Fag :call s:fzf_ag_raw(<q-args>)
command! -nargs=* -complete=file Fae :call s:fzf_ag_expand(<q-args>)
command! -nargs=+ -complete=file Fal :call s:fzf_ag_literal(<f-args>)
command! -nargs=* -complete=file Ff :call s:fzf_file(<q-args>)
command! -nargs=1 -complete=file Ftp :call s:fzf_search_tag(<f-args>, {'kind':'p'})
vnoremap FL y:call <SID>fzf_ag_literal(@")<CR>

"type, scope, signagure, inheritance
let s:fzf_btags_cmd = 'ctags -f - --excmd=number --sort=no --fields=KsSi --kinds-c++=+pUN --links=yes --language-force=c++'
"ignore filename. Be careful here, -1 is tag file name, must added by fzf somehow.
let s:fzf_btags_options = {'options' : '--no-reverse -m -d "\t" --tiebreak=begin --with-nth 1,4.. -n .. --prompt "Ctags> "'}
"there exists an extra field which i don't know how to control in fzf#vim#tags,
"that's why it use 1,4..-2
let s:fzf_tags_options = {'options' : '--no-reverse -m -d "\t" --tiebreak=begin --with-nth 1,4..-2 -n .. --prompt "Ctags> "'}

function! s:fzf_cpp_btags()
  call fzf#vim#buffer_tags(
        \ '',[s:fzf_btags_cmd . ' ' . expand('%:S')],
        \ extend(copy(g:fzf_layout), s:fzf_btags_options))
endfunction

function! s:fzf_cpp_tags(...)
  let query = get(a:000, 0, '')
  "if query == ''
     "let query = expand('<cword>') 
  "endif
  call fzf#vim#tags(
        \ query, 
        \ extend(copy(g:fzf_layout), s:fzf_tags_options))
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
  let ecmd = matches[1] . system('readlink -f ' . matches[2])[0:-2]
  call s:fzf_ag_raw(ecmd)
endfunction

function! s:fzf_file(cmd)
  let opts = {
  \ 'source':  a:cmd,
  \ 'options': ['--ansi', 
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'hl:68,hl+:110']
  \}
  call fzf#run(fzf#wrap(opts))
endfunction

function! s:fzf_tag_sink(line)
  let items = split(a:line, '\t')
  call myvim#open(items[-2])
  exec items[-1]
endfunction

" name, [{"kind":,}]
function! s:fzf_search_tag(name, ...)

  if a:name =~# '\v^\s*$'
    echom 'tag name should not has only blank'
    return
  endif

  let tagOpts = get(a:000, 0, {})
  let tags = taglist(printf('\v^%s$', a:name))
  if has_key(tagOpts, 'kind')
    call filter(tags, printf('v:val.kind =~# ''\v^%s''', tagOpts.kind))
  endif

  let source = []
  for tag in tags
    let source += [printf("%s\t%s\t%s\t%s\t%s", 
                \ tag.name, tag.kind, get(tag, 'signature', ''), tag.filename, tag.cmd)]
  endfor

  let opts = {
  \ 'source':  source,
  \ 'options': ['--ansi', 
  \             '--color', 'hl:68,hl+:110',
  \             '--with-nth=..-3'],
  \ 'sink' : function("s:fzf_tag_sink")
  \}

  call fzf#run(fzf#wrap(opts))
endfunction

function! s:fzf_ag_literal(str)
  let cmd = printf('-F %s', myvim#literalize(a:str, 1))
  call s:fzf_ag_raw(cmd)
endfunction

" ------------------------------------------------------------------------------
" rtags
" ------------------------------------------------------------------------------
"let g:rtagsLog = '~/tmp/rtaglog'
"let g:neomake_open_list = 2

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

" ------------------------------------------------------------------------------
" cdef
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" tex
" ------------------------------------------------------------------------------
let g:tex_flavor = 'latex'
