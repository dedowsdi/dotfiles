autocmd!
" ------------------------------------------------------------------------------
" basic setting
" ------------------------------------------------------------------------------
set ttimeout ttimeoutlen=5 timeoutlen=1000
set nocompatible number ruler novisualbell showmode showcmd hidden mouse=a background=dark
set incsearch  ignorecase smartcase
set list listchars=trail:┄,tab:†·,extends:>,precedes:<,nbsp:+ concealcursor=vn conceallevel=0
set autoindent smartindent shiftwidth=4 tabstop=4 softtabstop=4 expandtab smarttab
set showmatch matchtime=3
set laststatus=2 cmdheight=2 scrolloff=1
set spell spelllang=en_us dictionary+=spell
set nrformats=octal,hex,bin
set path+=/usr/local/include,**
set backspace=indent,eol,start
let &backup = !has('vms')
set wildmenu history=200
set backupdir=$HOME/.vimbak directory=$HOME/.vimswap//
set sessionoptions+=unix,slash                     " use unix /
set cpoptions+=d                                   " let tags use current dir? why did i do this?
set wildmode=longest,list " set wildmode to unix glob
set wildignore=*.o,*.a,*.so,tags,TAGS,.git/*
set matchpairs+=<:>                                " add match pair for < and >
set fileencodings=ucs-bom,utf-8,gbk,cp936,big5,gb18030,latin1,utf-16
let &grepprg = 'grep -n $* /dev/null --exclude-dir={.git,.hg} -I'
" set grepprg=ag\ --vimgrep\ $* grepformat=%f:%l:%c:%m

filetype plugin indent on
syntax enable
packadd cfilter

if has('nvim')
  let g:python3_host_prog = '/usr/bin/python3'
  let &shada="'200,<50,s10,h"
  tnoremap <expr> <m-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  " map to <c-f#> and <s-f#>
  for i in range(1,12)
    exec printf('map <f%d> <s-f%d>', i+12, i)
    exec printf('map <f%d> <c-f%d>', i+24, i)
  endfor
else
  command! -nargs=0 SuperWrite :w !sudo tee % > /dev/null
  set viminfo='500,<50,s10,h
  set fo+=j
  " viminfo= doesn't expand environment variable, check n of viminfo for detail
  let &viminfo .= ',r'.$VIMRUNTIME.'/doc'
  packadd termdebug

  if has('gui_running')
    set lines=100 columns=999
    set guioptions=aegim " remove menu, scroll bars
  else
    set t_Co=16
    if &term =~# 'xterm'
      for letter in split('befhjklou', '\zs')
        exec printf('set <a-%s>=%s', letter, letter)
      endfor
    endif
  endif
endif
if has('win32')
  set shellslash
endif

" ------------------------------------------------------------------------------
" auto commands
" ------------------------------------------------------------------------------
function! s:on_dir_change()
  if filereadable('.vim/init.vim') | source .vim/init.vim | endif
endfunction

augroup zxd_misc
  au!
  autocmd DirChanged * cal s:on_dir_change()
  autocmd BufWritePost *.l if &filetype ==# 'lpfg' | call myl#runLpfg() | endif
  autocmd InsertEnter,InsertLeave * set cursorline!
augroup end

" ------------------------------------------------------------------------------
" plugin
" ------------------------------------------------------------------------------

" ale
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

let g:ale_glsl_glslang_executable = '/usr/local/bin/glslangValidator'

" ultisnips
let g:UltiSnipsSnippetsDir=$HOME.'/.config/nvim/plugged/misc/UltiSnips'
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'

" ycm
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_of_chars_for_completion = 2
" let g:ycm_auto_trigger = 0
" following semantic triggers will break ultisnips suggestion
let g:ycm_semantic_triggers = {'c':['re!\w{4}'], 'cpp':['re!\w{4}']}
let g:ycm_server_python_interpreter = '/usr/bin/python3'
" default ycm cfg file
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<Down>']
" let g:clang_user_options = ' -DCLANG_COMPLETE_ONLY' " not working
" compile_command.json exists?

" easyalign

" vim-clang-format
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

" lightline
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \ },
      \ 'component':
      \ {
      \     'test':'hello tabline'
      \ },
      \ }

" pymode
let g:pymode_rope_completion = 0

" fzf
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vertical rightbelow split',
      \ 'ctrl-a': 'argadd',
      \ 'ctrl-o': '!gvfs-open',
      \ 'ctrl-q': '!qapitrace'
      \ }
let g:fzf_layout = {'up':'~40%'}

command! -nargs=* Ctags :call <SID>fzf_cpp_tags(<q-args>)

command! -nargs=+ -complete=file Ff :call s:fzf_file(<q-args>)
command! -nargs=+ Ft :call <SID>fzf_search_tag_kinds(<f-args>)

"type, scope, signature, inheritance
let s:fzf_btags_cmd = 'ctags -D "META_Object(library,name)=" -f - --excmd=number --sort=no
      \ --fields-c++=+{properties}{template} --fields=KsSi --kinds-c++=+pUN --links=yes --language-force=c++'
"ignore filename. Be careful here, -1 is tag file name, must added by fzf somehow.
let s:fzf_btags_options = {'options' : '--no-reverse -m -d "\t" --tiebreak=begin --with-nth 1,4.. -n .. --prompt "Ctags> "'}

function! G_fzf_cpp_btags()
  call fzf#vim#buffer_tags(
        \ '',[s:fzf_btags_cmd . ' ' . expand('%:S')],
        \ extend(copy(g:fzf_layout), s:fzf_btags_options))
endfunction

function! s:fzf_cpp_tags(...)
  let query = get(a:000, 0, '')
  " there exists an extra field which i don't know how to control in fzf#vim#tags,
  " that's why it use 1,4..-2
  let tags_options = { 'options' :
        \ '--no-reverse -m -d "\t" --tiebreak=begin --with-nth 1,4..-2 -n .. --prompt "Ctags> "'}
  call fzf#vim#tags(
        \ query,
        \ extend(copy(g:fzf_layout), tags_options))
endfunction

" change FZF_DEFAULT_COMMAND, execute cmd, restore FZF_DEFALUT_COMMAND
function! G_fzf(fzf_default_cmd, cmd)
  let oldcmds = $FZF_DEFAULT_COMMAND | try
    let $FZF_DEFAULT_COMMAND = a:fzf_default_cmd
    execute a:cmd
  finally | let $FZF_DEFAULT_COMMAND = oldcmds | endtry
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
  call misc#open(items[-2])
  exec items[-1]
endfunction

function! s:fzf_search_tag_kinds(name, ...)
   call G_fzf_search_tag(a:name, {'kinds':a:000})
endfunction

" full_match_name, [{"kinds":[],}]
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

let s:fzf_file_project = 'find . \( -name ".hg" -o -name ".git" -o -name "build" -o -name ".vscode" -o -name "demo" \) -prune -o -type f'

" tex
let g:tex_flavor = 'latex'
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk -layout <q-args> -
:command! -complete=file -nargs=1 Rpdffmt :r !pdftotext -nopgbrk -layout <q-args> - |fmt -csw78

" vim-json
let g:vim_json_syntax_conceal = 0

" markdown
let g:vim_markdown_conceal = 0

" indentLine
let g:indentLine_setConceal = 0

" ------------------------------------------------------------------------------
" small functions
" ------------------------------------------------------------------------------

" close everything except normal buffer
function! G_focus()
  call misc#term#hideall() | pclose | cclose | lclose
endfunction

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

function! G_rm_qf_item(visual)
  let r = a:visual ? [getpos("'<")[1], getpos("'>")[1]] : [line('.'), line('.')]
  let l = getqflist() | call remove(l, r[0]-1, r[1]-1) | call setqflist(l) | call cursor(r[0], 1)
endfunction

if has('nvim')
  nnoremap __ :edit ~/.config/nvim/init.vim<cr>
else
  nnoremap __ :edit ~/.vimrc<cr>
endif

set rtp+=~/.fzf,.vim,.vim/after
call plug#begin('~/.config/nvim/plugged')
" common
"Plug 'scrooloose/syntastic'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'Yggdroot/indentLine'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'             " snippets used in ultisnips
Plug 'terryma/vim-multiple-cursors'
Plug 'triglav/vim-visual-increment'
Plug 'tpope/vim-unimpaired'
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe'         " auto complete
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'tpope/vim-fugitive'             " git wrapper
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'         "clang c/c++ format
Plug 'klen/python-mode'
Plug 'pangloss/vim-javascript'
Plug 'othree/html5.vim'
Plug 'elzr/vim-json'
Plug 'tikhomirov/vim-glsl'
Plug 'lervag/vimtex'                   " latex
Plug 'dedowsdi/misc'
Plug 'dedowsdi/cdef'
Plug 'Carpetsmoker/testing.vim'
" Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-repeat'
call plug#end()

" only use solarized colorscheme if it's real unix, not wsl
if misc#env#isRealUnix() | colorscheme solarized | endif
if !has('gui_running')
  " undercurl doesn't work on terminal
  hi clear SpellBad
  hi SpellBad cterm=underline
endif

" ------------------------------------------------------------------------------
" global text objects
" ------------------------------------------------------------------------------
vnoremap aa :<C-U>silent! call misc#to#selCurArg({})<cr>
vnoremap ia :<C-U>silent! call misc#to#selCurArg({'excludeSpace':1})<cr>
onoremap aa :normal vaa<cr>
onoremap ia :normal via<cr>
vnoremap al :<C-U>silent! call misc#to#selLetter()<cr>
onoremap al :normal val<cr>
vnoremap il :<C-U>silent! call misc#to#selLetter()<cr>
onoremap il :normal val<cr>

" vertical motion, starts with c as column
vnoremap ce :<c-u>exec 'norm! gv' <bar> call misc#mo#vertical_motion('E')<cr>
vnoremap cw :<c-u>exec 'norm! gv' <bar> call misc#mo#vertical_motion('W')<cr>
vnoremap cb :<c-u>exec 'norm! gv' <bar> call misc#mo#vertical_motion('B')<cr>

" ------------------------------------------------------------------------------
" maps
" ------------------------------------------------------------------------------
let s:maps = [
   \ ['Y',           'n',  1, [],           'y$'],
   \ ['K',           'n',  1, [],           ':let wid=win_getid()<bar>exec "norm! K"<bar>call win_gotoid(wid)<cr>'],
   \ ['<f3>',        'n',  1, [],           ':set hlsearch!<cr>'],
   \ ['<f4>',        'n',  1, [],           ':ALEHover<cr>'],
   \ ['<f5>',        'n',  1, [],           ':Cmr<cr>'],
   \ ['<f5>',        'n',  1, ['lpfg'],     ':call myl#runLpfg()<cr>'],
   \ ['<f5>',        'n',  1, ['vim'],      ':so %<cr>'],
   \ ['<c-f5>',      'n',  1, ['vim'],     ':VimlReloadScript<cr>'],
   \ ['<c-f7>',      'n',  1, [],          ':ALELint<cr>'],
   \ ['<c-f7>',      'n',  1, ['c'],       ':YcmDiags<cr>'],
   \ ['<f8>',        'n',  0, ['c'],        ':CdefSwitch<cr>'],
   \ ['<f9>',        'n',  0, ['vim'],      ':VimlBreakHere<cr>'],
   \ ['<c-f9>',       'n',  0, ['vim'],     ':VimlBreakNumberedFunction<cr>'],
   \ ['<f12>',       'n',  1, [],           ':YcmCompleter GoToDefinition<cr>'],
   \ ['<c-f12>',       'n',  1, [],         ':YcmCompleter GoToDeclaration<cr>'],
   \
   \ ['<c-l>',       'n',  1, [],           ':nohlsearch<Bar>diffupdate<CR><C-L>'],
   \
   \ ['<a-o>',       'n',  0, ['c'],        ':CdefSwitchFile<cr>'],
   \ ['<a-o>',       'n',  1, ['glsl'],     ':call myglsl#alternate()<cr>'],
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
   \ ['<expr> %t',   'c',  1, [],           'getcmdtype() == ":" ? expand("%:t") : "%t"'],
   \
   \ ['<leader>tt',   'n',  1, [],           ':call misc#term#toggleGterm()<cr>'],
   \ ['<leader>tt',   't',  1, [],           '<c-\><c-n>:call misc#term#toggleGterm()<cr>'],
   \ ['<leader>th',   'n',  1, [],           ':call misc#term#hideall()<cr>'],
   \ ['<leader>th',   't',  1, [],           '<c-\><c-n>:call misc#term#hideall()<cr>'],
   \
   \ ['<leader>aa',  'n',  1, ['c'],        ':call mycpp#doTarget("apitrace trace", "", ''<bar>& tee trace.log && qapitrace `grep -oP "(?<=tracing to ).*$" trace.log`'')<cr>'],
   \ ['<leader>al',  'n',  1, ['c'],        ':call mycpp#openLastApitrace()<cr>'],
   \ ['<leader>ar',  'n',  1, ['c'],        ':Crenderdoc<cr>'],
   \ ['<leader>an',  'n',  1, ['c'],        ':CnvidiaGfxDebugger<cr>'],
   \
   \ ['dd',          'n',  1, ['quickfix'], ':call G_rm_qf_item(0)<cr>'],
   \ ['d',          'v',  1, ['quickfix'], ':<c-u>call G_rm_qf_item(1)<cr>'],
   \
   \ ['<leader>ei',  'n',  1, ['c'],        ':call mycpp#manualInclude()<cr>'],
   \ ['<leader>ed',  'n',  0, ['c'],        ':CdefDef<cr>'],
   \ ['<leader>ed',  'v',  0, ['c'],        ':CdefDef<cr>'],
   \ ['<leader>ef',  'v',  1, ['c', 'glsl'],':ClangFormat<cr>'],
   \ ['<leader>ej',  'n',  1, ['vim'],      ':VimlJoin<cr>'],
   \
   \ ['<leader><leader>',  'n',  1, [],     ':set opfunc=misc#op#searchLiteral<CR>g@'],
   \ ['<leader><leader>',  'v',  1, [],     ':<c-u>call misc#op#searchLiteral(visualmode(), 1)<cr>'],
   \ ['<leader>s',         'n',  1, [],     ':set opfunc=misc#op#substitude<CR>g@'],
   \ ['<leader>s',         'v',  1, [],     ':<c-u>call misc#op#substitude(visualmode(), 1)<cr>'],
   \ ['<leader>sl',        'n',  0, [],     '<leader><leader>iwvif:s//'],
   \ ['<leader>s}',        'n',  0, [],     '<leader><leader>iwvi}:s//'],
   \ ['<leader>s{',        'n',  0, [],     '<leader>s{'],
   \ ['<leader>lg',  'n',  1, [],           ':set opfunc=misc#literalCopyGrep<CR>g@'],
   \ ['<leader>lg',  'v',  1, [],           ':<c-u>call misc#literalCopyGrep(visualmode(), 1)<CR>:grep -F <c-r>=@"<cr>'],
   \
   \ ['<c-j>',       'i',  1, ['c'],        '->'],
   \
   \ ['<leader>yd',  'n',  1, [],           ':YcmShowDetailedDiagnostic<cr>'],
   \ ['<leader>yf',  'n',  1, [],           ':YcmCompleter FixIt<cr>'],
   \ ['<leader>yt',  'n',  1, [],           ':YcmCompleter GetType<cr>'],
   \
   \ ['ga',          'nv', 0, [],           '<Plug>(EasyAlign)'],
   \ ]

if has('nvim')
  let g:projMaps =
        \ {'c': [
        \         ['<f5>',         'n', 1, [], ':CppMakeRun<cr>'],
        \         ['<f7>',         'n', 1, [], ':CppMake<cr>'],
        \         ['<f9>',         'n', 1, [], ':GdbToggleBreakpoint<cr>'],
        \         ['<f10>',        'n', 1, [], ':GdbNext<cr>'],
        \         ['<f11>',        'n', 1, [], ':GdbStep<cr>'],
        \         ['<f35>',        'n', 1, [], ':GdbFinish<cr>'],
        \         ['<m-f9>',       'n', 1, [], ':GdbWatchWord<cr>'],
        \         ['<m-f9>',       'n', 1, [], ':GdbWatchRange<cr>'],
        \         ['<leader>ds',   'n', 1, [], ':GdbDebugStop<cr>'],
        \         ['<leader>dd',   'n', 1, [], ':CppDebug<cr>'],
        \         ['<leader>de',   'n', 1, [], ':GdbEvalWord<cr>'],
        \         ['<leader>de',   'n', 1, [], ':GdbEvalRange<cr>'],
        \         ['<m-pageup>',   'n', 1, [], ':GdbFrameUp<cr>'],
        \         ['<m-pagedown>', 'n', 1, [], ':GdbFrameDown<cr>'],
        \       ]
        \ }
else
  let g:projMaps  = {
        \ 'c' : [
        \         ['<f5>',         'n', 1, [], ':CppMakeRun<cr>'],
        \         ['<f7>',         'n', 1, [], ':CppMake<cr>'],
        \         ['<f9>',         'n', 1, [], ':Break<cr>'],
        \         ['<c-f9>',       'n', 1, [], ':Clear<cr>'],
        \         ['<f10>',        'n', 1, [], ':Over<cr>'],
        \         ['<leader>ds',   'n', 1, [], ':Step<cr>'],
        \         ['<leader>df',   'n', 1, [], ':Finish<cr>'],
        \         ['<leader>dc',   'n', 1, [], ':Continue<cr>'],
        \         ['<leader>de',   'n', 1, [], ':Evaluate<cr>'],
        \         ['<leader>de',   'v', 1, [], ':Evaluate<cr>'],
        \ ]
        \ }
endif

call misc#ui#loadMaps(s:maps)
call misc#ui#loadAutoMap('quickfix')

" some tiny util
command! DCcollect :call misc#dc#startCopy(1)
command! DCcollectAppend :call misc#dc#startCopy(0)
command! -range DCpaste :call misc#dc#startPaste()
command! -nargs=+ LinkVimHelp let @" = misc#createVimhelpLink(<q-args>)
command! -nargs=+ LinkNvimHelp let @" = misc#createNvimhelpLink(<q-args>)
command! UpdateVimHelpLink call misc#updateLink(0)
command! UpdateNvimHelpLink call misc#updateLink(1)
command! -nargs=* EditTemp e `=tempname().'_'.<q-args>`
command! Synstack echo misc#synstack()
command! HiTest source $VIMRUNTIME/syntax/hitest.vim
command! TrimTrailingWhitespace :keepp %s/\v\s+$//g
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
  \ | diffthis | wincmd p | diffthis

