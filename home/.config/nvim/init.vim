"a Remove ALL autocommands for the current group.
autocmd!

" languageClient is still quite rough, ycm is much mutter.
let g:use_cquery = 0

" ------------------------------------------------------------------------------
" basic setting
" ------------------------------------------------------------------------------
if has('nvim')
  let g:python3_host_prog = '/usr/bin/python3'
endif
let &shada="'200,<50,s10,h"
let s:emulator = ''

if 'linux' ==# $TERM
  let s:term = 'linux'
else
  if has('unix')
    call system('grep -q "Microsoft" /proc/version')
    let s:term = v:shell_error == 0 ?'wsl_xterm' :'unix_xterm'
    let desktopFile = system('printenv GIO_LAUNCHED_DESKTOP_FILE')
    if desktopFile =~# 'hyper'
      let s:emulator = 'hyper'
    endif
  else
    let s:term = 'unknown'
  endif
endif

set autoindent                  " set auto-indenting on for programming
set showmatch                   " autoshow matching brackets.
set matchtime=3                 " stop at matching of something for 0.3 second
set visualbell                  " turn on "visual bell" - which is much quieter than "audio blink"
set ruler                       " show the cursor position all the time
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set cmdheight=2
set backspace=indent,eol,start  " make that backspace key work the way it should
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set showmode                    " show the current mode
syntax enable                   " turn syntax highlighting on by default
set backupdir=~/.vimbak         " set backup dir
"set history=500                " keep 500 commands
set showcmd                     " display incomplete command in low right corner
set incsearch                   " toggle increment search
set number                      " show line number
set ignorecase
set smartcase
set fileencodings=ucs-bom,utf-8,gbk,cp936,utf-16,big5,gb18030,latin1
set textwidth=80
set tabstop=4
set shiftwidth=4                " set shift width to 4
set expandtab                   " always expand tab, tab is evil
set sessionoptions+=unix,slash  " use unix /, so the session can be open by both windows and unix
set hidden                      " allow hidden without trailing #
"set nowrap                     " no line wrap
set path+=/usr/local/include,** " set up find path
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P
let &backup = !has('vms')       " set auto backup
set cpoptions+=d                " let tags use current dir
set wildignore=*.o,tags,TAGS    " ignore obj files
set wildmode=longest,list       " just like bash
set mps+=<:>                    " add match pair for < and >
set nrformats=octal,hex,bin
" case indent, no accessor indent
set cinoptions&
set mouse=a                     " always use mouse
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

"text object
vnoremap aa :<C-U>silent! call myvim#selCurArg({})<cr>
vnoremap ia :<C-U>silent! call myvim#selCurArg({'excludeSpace':1})<cr>
onoremap aa :normal vaa<cr>
onoremap ia :normal via<cr>
vnoremap am :<C-U>silent! call myvim#selectSmallWord()<cr>
onoremap am :normal vam<cr>
vnoremap im :<C-U>silent! call myvim#selectSmallWord()<cr>
onoremap im :normal vam<cr>

" ------------------------------------------------------------------------------
" command
" ------------------------------------------------------------------------------
"save project information
command! -nargs=0 JsaveProject :mksession! script/session.vim
command! -nargs=+ Google :call <SID>google(<f-args>)
"super write
command! -nargs=0 SW :w !sudo tee % > /dev/null
command! -nargs=0 ReverseQuickfixList call <SID>reverse_qf_list()
"view pdf
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk -layout <q-args> -
:command! -complete=file -nargs=1 Rpdffmt :r !pdftotext -nopgbrk -layout <q-args> - |fmt -csw78

autocmd DirChanged * call <SID>on_dir_change()
" ------------------------------------------------------------------------------
" plugin
" ------------------------------------------------------------------------------
set rtp+=~/.fzf
call plug#begin('~/.config/nvim/plugged')
" common
"Plug 'scrooloose/syntastic'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/goyo.vim'
Plug 'Yggdroot/indentLine'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
Plug 'scrooloose/nerdcommenter'
" Plug 'tpope/vim-commentary'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'             " snippets used in ultisnips
Plug 'terryma/vim-multiple-cursors'
Plug 'triglav/vim-visual-increment'
Plug 'tpope/vim-unimpaired'
"Plug 'tpope/vim-abolish'              " never used
"Plug 'kana/vim-operator-user'         " recomanded by vim-clang-format
Plug 'itchyny/lightline.vim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
if g:use_cquery
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
else
  Plug 'Valloric/YouCompleteMe'         " auto complete
endif
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'Shougo/neosnippet.vim'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
" my own
Plug 'dedowsdi/misc'
Plug 'dedowsdi/cdef'
" git
Plug 'tpope/vim-fugitive'             " git wrapper
"c++ related
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
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

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

" ------------------------------------------------------------------------------
" ale
" ------------------------------------------------------------------------------
"
" Only run linters named in ale_linters settings.
let g:ale_vim_vint_show_style_issues = 0
let g:ale_linters_explicit = 1

" you can not disable lint while enable language server, so i turn off auto
" lint.
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_lint_on_filetype_changed = 0

let g:ale_linters = {
\   'vim': ['vint'],
\   'sh': ['shellcheck'],
\   'glsl' : ['glslang'],
\   'cpp'  : ['cquery']
\}




" ------------------------------------------------------------------------------
" ultisnips
" ------------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger='<c-s>'
let g:UltiSnipsJumpForwardTrigger='<c-n>'
let g:UltiSnipsJumpBackwardTrigger='<c-p>'

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
" default ycm cfg file
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax = 1

" ------------------------------------------------------------------------------
" languageClient-neovim
" ------------------------------------------------------------------------------
let g:LanguageClient_autoStart = 1
"let g:LanguageClient_loggingLevel = 'DEBUG'
"let g:LanguageClient_loggingFile = '/tmp/lc_client.log'
"set completefunc=LanguageClient#complete
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings 
let g:LanguageClient_settingsPath = $HOME.'/.config/nvim/settings.json'
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['cquery', ],
    \ }
let g:LanguageClient_fzfOptions = ['--ansi', 
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'hl:68,hl+:110']

" ------------------------------------------------------------------------------
" deoplete
" ------------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1

" ------------------------------------------------------------------------------
" neocomplete
" ------------------------------------------------------------------------------
"imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"smap <C-k>     <Plug>(neosnippet_expand_or_jump)
"xmap <C-k>     <Plug>(neosnippet_expand_target)

" ------------------------------------------------------------------------------
" easyalign
" ------------------------------------------------------------------------------

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

" ------------------------------------------------------------------------------
" solarized
" ------------------------------------------------------------------------------
if $TERM !=# 'linux'
  set t_Co=256
endif

" only use solarized in linux

if s:emulator ==# 'hyper'
  "let g:solarized_termcolors=256
  "set termguicolors
  colorscheme solarized
  "colorscheme solarized8_dark
  "let base16colorspace=256
  "colorscheme base16-solarized-dark
  "set t_Co=256
else
  if s:term ==# 'linux' || s:term ==# 'unix_xterm'
    colorscheme solarized
  elseif s:term ==# 'wsl_xterm'
    set termguicolors
    colorscheme solarized8_dark
  else
    let g:seoul256_background=236
    colorscheme seoul256
  endif
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
" lightline
" ------------------------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" ------------------------------------------------------------------------------
" pymode
" ------------------------------------------------------------------------------
"let pymode = 1
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
"nnoremap <m-u> :<c-u>Unite -start-insert file file_rec/neovim buffer file_mru<cr>
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
" all project file
"nnoremap <c-p><c-e> :call <SID>fzf('find  . -type f ', ':Files') <cr>
" project file, exclude hg, git, build. Follow symbolic.
"nnoremap <c-p><c-f> :call <SID>fzf('find -L . -type f ! -path "*.hg/*" ! -path "*.git/*" ! -path "*/build/*"', ':Files') <cr>
" all project file. Follow symbolic.
"nnoremap <c-p><c-a> :call <SID>fzf('find -L . -type f', ':Files') <cr>
"nnoremap <C-p><C-w> :call fzf#vim#files('.', {'options':'--query '.expand('<cword>')})<cr>

"nnoremap <c-p><c-g> :GitFiles<cr>
"nnoremap <c-p><c-g>? :GitFiles?<cr>
"nnoremap <c-p><c-c> :Colors<cr>
"nnoremap <c-p><c-a> :Ag<cr>
"nnoremap <c-p><c-l> :Lines<cr>
"nnoremap <c-p><c-l> :BLines<cr>
"nnoremap <c-p><c-t> :Tags<cr>
command! -nargs=* Ctags :call <SID>fzf_cpp_tags(<q-args>)
"nnoremap <c-p><c-k> :Ctags<cr>
" autocmd! FileType cpp,glsl nnoremap <buffer> <c-j> :call <SID>fzf_cpp_btags()<cr>
"nnoremap <c-p><c-m> :Marks<cr>
"nnoremap <c-p><c-w> :Windows<cr>
"nnoremap <c-p><c-;> :History:<cr>
"nnoremap <c-p><c-/> :History/<cr>
"nnoremap <c-p><c-s> :Snippets<cr>
"nnoremap <c-p><c-c> :Commits<cr>
"nnoremap <c-p><c-b>c :BCommits<cr>
"nnoremap <c-p><c-c> :Commands<cr>
"nnoremap <c-p><c-m> :Maps<cr>
"nnoremap <c-p>h :Helptags<cr>
"nnoremap <c-p>f :Filetypes<cr>

augroup zxd
autocmd! VimEnter * command! -nargs=* -complete=file Fag :call s:fzf_ag_raw(<q-args>)
augroup end
command! -nargs=* -complete=file Fae :call s:fzf_ag_expand(<q-args>)
command! -nargs=+ -complete=file Fal :call s:fzf_ag_literal(<f-args>)
command! -nargs=+ -complete=file Ff :call s:fzf_file(<q-args>)
command! -nargs=+ Ft :call <SID>fzf_search_tag_kinds(<f-args>)
vnoremap FL y:call <SID>fzf_ag_literal(@")<cr>

"type, scope, signagure, inheritance
let s:fzf_btags_cmd = 'ctags -f - --excmd=number --sort=no --fields=KsSi --kinds-c++=+pUN --links=yes --language-force=c++'
"ignore filename. Be careful here, -1 is tag file name, must added by fzf somehow.
let s:fzf_btags_options = {'options' : '--no-reverse -m -d "\t" --tiebreak=begin --with-nth 1,4.. -n .. --prompt "Ctags> "'}
"there exists an extra field which i don't know how to control in fzf#vim#tags,
"that's why it use 1,4..-2
let s:fzf_tags_options = {'options' : '--no-reverse -m -d "\t" --tiebreak=begin --with-nth 1,4..-2 -n .. --prompt "Ctags> "'}

function! G_fzf_cpp_btags()
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

function! G_fzf(fzf_default_cmd, cmd)
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

function! s:fzf_search_tag_kinds(name, ...)
   call G_fzf_search_tag(a:name, {'kinds':a:000}) 
endfunction

" name, [{"kinds":[],}]
function! G_fzf_search_tag(name, ...)

  if a:name =~# '\v^\s*$'
    echom 'tag name should not has only blank'
    return
  endif

  let tagOpts = get(a:000, 0, {})
  let tags = taglist(printf('\v^%s$', a:name))
  if has_key(tagOpts, 'kinds')
    let kinds = join(tagOpts.kinds, '')
    call filter(tags, printf('v:val.kind =~# ''\v^[%s]''', kinds))
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
  \             '--with-nth=..-2'],
  \ 'sink' : function('s:fzf_tag_sink')
  \}

  call fzf#run(fzf#wrap(opts))
endfunction

function! s:fzf_ag_literal(str)
  let cmd = printf('-F %s', myvim#literalize(a:str, 1))
  call s:fzf_ag_raw(cmd)
endfunction

" close everything except normal buffer
function! G_focus()
  call misc#term#hideall()
  pclose
  cclose
  lclose
endfunction

" ------------------------------------------------------------------------------
" goyo
" ------------------------------------------------------------------------------

let g:goyo_width = 120 
let g:goyo_height = '100%'

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

" finish mark
let g:init_finished = 1

" ------------------------------------------------------------------------------
" small functions
" ------------------------------------------------------------------------------

"it should be \tv, but v is not convinent
"noremap <leader>tt :call <SID>tagSplit('', 'v')<cr>
"noremap <leader>th :call <SID>tagSplit('', 'h')<cr>

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

function! G_smartSplit()
  let direction = str2float(winwidth(0))/winheight(0) >= 204.0/59 ? 'vsplit':'split'
  exec 'rightbelow ' . direction
endfunction

function! G_visualSearch()
  "record @s, restore later
  let @/ = '\V' . myvim#literalize(myvim#getVisualString(), 0)
endfunction

" search in chrome
function! G_google(...)
  if len(a:000) == 0|return|endif
  let searchItems = shellescape(join(a:000, '+'))
  let cmd = 'google-chrome https://www.google.com/\#q=' . searchItems . '>/dev/null'
  if has('nvim')
    call jobstart(cmd)
  else
    silent! execute '!' . cmd
  endif
endfunction

function! G_cycleOption(name, list)
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

function! G_rm_qf_item(...)
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

function! s:on_dir_change()
  if filereadable('.vim/init.vim')
    source .vim/init.vim
  endif
endfunction

let s:fzf_file_project = 'find  . -type f ! -path "*.hg/*" ! -path "*.git/*" ! -path "*/build/*" ! -path "*.vscode/*"'

let s:maps = [
   \ ['<f1>',        'n',  1, [],           ''],
   \ ['<f2>',        'n',  0, ['c'],        '<Plug>CdefRename'],
   \ ['<f3>',        'n',  1, [],           ':set hlsearch!<cr>'],
   \ ['<f4>',        'n',  1, [],           ':ALEHover<cr>'],
   \ ['<f5>',        'n',  1, [],           ':Cmr<cr>'],
   \ ['<f6>',        'n',  1, [],           ':call myvim#updateTags()<cr>'],
   \ ['<f7>',        'n',  1, [],           ':Cm<cr>'],
   \ ['<F31>',       'n',  1, [],           ':ALELint<cr>'],
   \ ['<F31>',       'n',  1, ['c'],        ':YcmDiags<cr>'],
   \ ['<f8>',        'n',  0, ['c'],        '<Plug>CdefSwitchBetProtoAndFunc'],
   \ ['<f9>',        'n',  1, ['c'],        ':call mycpp#toggleBreakpoint()<cr>'],
   \ ['<F33>',       'n',  1, ['c'],        ':call mycpp#singleLineBreak()<cr>'],
   \ ['<f10>',       'n',  1, [],           ':call G_cycleOption("virtualedit", ["", "all"])<cr>'],
   \ ['<f11>',       'n',  1, [],           ''],
   \ ['<f12>',       'n',  1, [],           ':YcmCompleter GoToDefinition<cr>'],
   \ ['<f36>',       'n',  1, [],           ':YcmCompleter GoToDeclaration<cr>'],
   \ ['<F24>',       'n',  1, [],           ':ALEFindReferences<cr>'],
   \
   \ ['Y',           'n',  1, [],           'y$'],
   \ ['<a-o>',       'n',  0, ['c'],        '<Plug>CdefSwitchFile'],
   \ ['<a-o>',       'n',  1, ['glsl'],     ':call myglsl#alternate()<cr>'],
   \ ['<a-d>',       'n',  0, ['c'],        '<Plug>CdefDefineTag'],
   \ ['<a-d>',       'v',  0, ['c'],        '<Plug>CdefDefineRange'],
   \ ['g6',          'n',  1, [],           ':b#<cr>'],
   \ ['<c-p>',       'n',  1, [],           printf(':call G_fzf(''%s'', ":Files") <cr>', s:fzf_file_project)],
   \ ['<c-j>',       'n',  1, [],           ':BTags<cr>'],
   \ ['<c-j>',       'n',  1, ['c','glsl'], ':call G_fzf_cpp_btags()<cr>'],
   \ ['<c-h>',       'n',  1, [],           ':History<cr>'],
   \ ['<c-b>',       'n',  1, [],           ':Buffers<cr>'],
   \ ['<c-k>',       'n',  1, [],           ':call G_focus()<cr>'],
   \ ['<a-h>',       'n',  1, [],           '<c-w>h'],
   \ ['<a-j>',       'n',  1, [],           '<c-w>j'],
   \ ['<a-k>',       'n',  1, [],           '<c-w>k'],
   \ ['<a-l>',       'n',  1, [],           '<c-w>l'],
   \ ['<a-h>',       't',  1, [],           '<c-\><c-n><c-w>h'],
   \ ['<a-j>',       't',  1, [],           '<c-\><c-n><c-w>j'],
   \ ['<a-k>',       't',  1, [],           '<c-\><c-n><c-w>k'],
   \ ['<a-l>',       't',  1, [],           '<c-\><c-n><c-w>l'],
   \ ['<expr> %%',   'c',  1, [],           'getcmdtype() == ":" ? expand("%:h")."/" : "%%"'],
   \ ['<expr> %t',          'c',  1, [],           'getcmdtype() == ":" ? expand("%:t") : "%t"'],
   \ ['*',           'x',  1, [],           ':<C-u>call G_visualSearch()<cr>/<C-R>=@/<cr><cr>'],
   \ ['#',           'x',  1, [],           ':<C-u>call G_visualSearch()<cr>?<C-R>=@/<cr><cr>'],
   \
   \ ['<c-l>l',      'n',  1, [],           ':call G_focus()<cr>'],
   \ ['<c-l>l',      't',  1, [],           '<c-\><c-n>:call G_focus()<cr>'],
   \ ['<c-l>r',      'n',  1, [],           ':redraw<cr>'],
   \ ['<c-l>m',      'n',  1, [],           ':call misc#term#toggleGterm()<cr>'],
   \ ['<c-l>m',      't',  1, [],           '<c-\><c-n>:call misc#term#toggleGterm()<cr>'],
   \ ['<c-l>j',      'n',  1, [],           ':call misc#term#hideall()<cr>'],
   \ ['<c-l>j',      't',  1, [],           '<c-\><c-n>:call misc#term#hideall()<cr>'],
   \ ['<c-l>s',      'n',  1, [],           ':call G_smartSplit()<cr>'],
   \ ['<c-l>g',      'n',  1, [],           ':Goyo<cr>'],
   \
   \ ['<c-f>p',      'n',  1, [],           ':call G_fzf("find -L . -type f", ":Files") <cr>'],
   \ ['<c-f>i',      'n',  1, ['c'],        ':call mycpp#findIncludes()<cr>'],
   \ ['<c-f>d',      'n',  1, ['c'],        ':call mycpp#searchDerived()<cr>'],
   \ ['<c-f>l',      'n',  1, [],           ':Locate '],
   \ ['<c-f>tt',     'n',  1, [],           ':Ctags <cr>'],
   \ ['<c-f>td',     'n',  1, [],           ':call G_fzf_search_tag(expand("<cword>"), {"kinds":["c", "s", "p"]})<cr>'],
   \
   \ ['<leader>dd',  'n',  1, ['c'],        ':silent call mycpp#makeDebug("")<cr>'],
   \ ['<leader>db',  'n',  1, ['c'],        ':call mycpp#singleLineBreak()<cr>'],
   \ ['<leader>dq',  'n',  1, ['qf'],       ':call mycpp#makeQuickfix()<cr>'],
   \ ['<leader>ds',  'n',  1, [],        ':call mycpp#openDebugScript()<cr>'],
   \ ['<leader>dp',  'n',  1, [],        ':call mycpp#openProjectFile()<cr>'],
   \
   \ ['<leader>aa',  'n',  1, ['c'],        ':call mycpp#doTarget("apitrace trace", "", ''<bar>& tee trace.log && qapitrace `grep -oP "(?<=tracing to ).*$" trace.log`'')<cr>'],
   \ ['<leader>al',  'n',  1, ['c'],        ':call mycpp#openLastApitrace()<cr>'],
   \ ['<leader>ar',  'n',  1, ['c'],        ':Crenderdoc<cr>'],
   \ ['<leader>an',  'n',  1, ['c'],        ':CnvidiaGfxDebugger<cr>'],
   \ ['<leader>ag',  'n',  1, [],           ':call G_google(expand("<cword>"))<cr>'],
   \ ['<leader>ag',  'v',  1, [],           ':call G_google(myvim#getVisualString())<cr>'],
   \ ['<leader>am',  'n',  1, [],           ':Cmake<cr>'],
   \
   \ ['<c-s>s',      'v',  1, [],           ':<c-u>call G_visualSearch()<cr>:%s/<C-R>=@/<cr>/'],
   \ ['<c-s>w',      'n',  1, [],           ':%s/\v<<C-R><C-W>>/'],
   \ ['<c-s>W',      'n',  1, [],           ':%s/<C-R>=myvim#literalize(expand("<cWORD>"),0)<cr>/'],
   \ ['<c-s>lv',     'n',  1, [],           ':let @"=myvim#literalize(@", 0)<cr>'],
   \ ['<c-s>lg',     'n',  1, [],           ':let @"=myvim#literalize(@", 1)<cr>'],
   \ ['<c-s>lf',     'n',  1, [],           ':let @"=myvim#literalize(@", 2)<cr>'],
   \ ['<c-s>j',      'n',  0, [],           '<c-v><c-s>j'],
   \ ['<c-s>k',      'n',  0, [],           '<c-v><c-s>k'],
   \ ['<c-s>j',      'v',  1, [],           ':<c-u>call myvim#visualEnd("myvim#verticalSearch", {"direction":"j", "greedy":1})<cr>'],
   \ ['<c-s>k',      'v',  1, [],           ':<c-u>call myvim#visualEnd("myvim#verticalSearch", {"direction":"k", "greedy":1})<cr>'],
   \ 
   \ ['dd',          'n',  1, ['quickfix'], ':call G_rm_qf_item()<cr>'],
   \
   \ ['<c-e>e',      'i',  1, [],           '<c-v><space><esc>x'],
   \ ['<c-e>o',      'n',  1, ['c'],        ':call mycpp#autoInclude()<cr>'],
   \ ['<c-e>i',      'n',  1, ['c'],        ':call mycpp#manualInclude()<cr>'],
   \ ['<c-e>g',      'n',  1, ['c'],        ':call cdef#addHeadGuard()<cr>'],
   \ ['<c-e>de',     'n',  0, ['c'],        '<Plug>CdefDefineTag'],
   \ ['<c-e>de',     'v',  0, ['c'],        '<Plug>CdefDefineRange'],
   \ ['<c-e>df',     'n',  0, ['c'],        '<Plug>CdefDefineFile'],
   \ ['<c-e>du',     'n',  0, ['c'],        '<Plug>CdefUpdatePrototype'],
   \ ['<c-e>f',      'v',  1, ['c', 'glsl'],':ClangFormat<cr>'],
   \ ['<c-e>]',      'n',  1, [],           ':call myvim#shiftItem({"direction":"l"})<cr>'],
   \ ['<c-e>[',      'n',  1, [],           ':call myvim#shiftItem({"direction":"h"})<cr>'],
   \ ['<c-e>j',      'n',  1, ['vim'], 'A <bar><esc>J'],
   \ ['<c-e>s',      'n',  1, ['vim'], ':call myvim#sourceBlock(line("''<"),line("''>"))<CR>'],
   \
   \ ['<leader>yd',  'n',  1, [],           ':YcmShowDetailedDiagnostic<cr>'],
   \ ['<leader>ygd', 'n',  1, [],           ':YcmCompleter GoToDeclaration<cr>'],
   \ ['<leader>ygi', 'n',  1, [],           ':YcmCompleter GoToInclude<cr>'],
   \ ['<leader>yf',  'n',  1, [],           ':YcmCompleter FixIt<cr>'],
   \
   \ ['ga',          'nv', 0, [],           '<Plug>(EasyAlign)'],
   \ ['<leader>sh',  'n',  1, [],           ':ALEHover<cr>'],
   \ ['<leader>sr',  'n',  1, [],           ':ALEFindReferences<cr>'],
   \ ]

if has('nvim')
  nnoremap __ :edit ~/.config/nvim/init.vim<cr>
else
  nnoremap __ :edit ~/.vimrc<cr>
endif

if $TERM ==# 'linux'
  vnoremap \y y:call <SID>set_clipboard(@")<cr>
endif

for item in s:maps
  call myvim#bindKey(item[0], item[1], item[2], item[3], item[4])
endfor

call myvim#loadAutoMap('quickfix')
