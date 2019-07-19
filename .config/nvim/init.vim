autocmd!

" should I export it instead?
if !empty($TMUX) && !has('nvim')
  set term=xterm-256color
endif

" ------------------------------------------------------------------------------
" basic setting
" ------------------------------------------------------------------------------
set ttimeout ttimeoutlen=5 timeoutlen=1000
set number ruler novisualbell showmode showcmd hidden mouse=a background=dark
set incsearch  ignorecase smartcase
set list listchars=trail:┄,tab:†·,extends:>,precedes:<,nbsp:+
set concealcursor=vn conceallevel=0
set autoindent smartindent expandtab smarttab
set shiftwidth=4 tabstop=8 softtabstop=4
set showmatch matchtime=3
set laststatus=2 cmdheight=1 scrolloff=1
set spell spelllang=en_us dictionary+=spell
set nrformats=octal,hex,bin
set path+=/usr/local/include,/usr/include/c++/5
set backspace=indent,eol,start
let &backup = !has('vms')
set wildmenu history=200
set shellslash
" set colorcolumn=+1
set backupdir=$HOME/.vimbak directory=$HOME/.vimswap//
set sessionoptions+=unix,slash                     " use unix /
" search tag in dir of current file upward until root, use current dir tags if
" nothing found
set tags=./tags;,tags
set wildmode=longest,list " set wildmode to unix glob
set wildignore=*.o,*.a,*.so,tags,TAGS,*/.git/*,.git,*/build/*,build
set matchpairs+=<:>                                " add match pair for < and >
set fileencodings=ucs-bom,utf-8,gbk,cp936,big5,gb18030,latin1,utf-16
let &grepprg = 'grep -n $* /dev/null --exclude-dir={.git,.hg} -I'
" set grepprg=ag\ --vimgrep\ $* grepformat=%f:%l:%c:%m
if executable('zsh')
  let &shell = '/bin/zsh -o extendedglob'
endif

filetype plugin indent on
syntax enable
packadd cfilter
runtime ftplugin/man.vim

" setup maps ctrl|shift + fuc_keys, alt+[a-z]
if !has('gui_running')
  " set termguicolors
  let xterm_maps = {
    \   'ctrl_fn': [ '[1;5P]', '[1;5Q]', '[1;5R]', '[1;5S]' ],
    \   'shift_fn':[ '[1;2P]', '[1;2Q]', '[1;2R]', '[1;2S]' ],
    \   'sets' : {},
    \   'maps' : {}
    \ }

  let rxvt_maps = {
    \   'ctrl_fn': [ '[11^]', '[12^]', '[13^]', '[14^]',
    \                '[15^]', '[17^]', '[18^]', '[19^]',
    \                '[20^]', '[21^]', '[23^]', '[24^]'  ],
    \   'shift_fn':[ '[23~]', '[24~]', '[25~]', '[26~]',
    \                '[28~]', '[29~]', '[31~]', '[32~]',
    \                '[33~]', '[34~]', '[23$]', '[24$]'  ],
    \   'sets' : {},
    \   'maps' : {}
    \ }

  let maps = xterm_maps
  if &term =~? 'rxvt'
    let maps = rxvt_maps
  endif

  let i = 1
  for key in maps.ctrl_fn
    exec printf('set <f%d>=%s', 24 + i, key)
    exec printf('map <f%d> <c-f%d>', 24 + i, i)
    let i += 1
  endfor

  let i = 1
  for key in maps.shift_fn
    exec printf('set <f%d>=%s', 12 + i, key)
    exec printf('map <f%d> <c-f%d>', 12 + i, i)
    let i += 1
  endfor

  " for [key, value] in items(maps.sets)
  "   exec printf('set %s=%s', key, value)
  " endfor
  " for [key, value] in items(maps.maps)
  "   exec printf('map %s %s', key, value)
  "   exec printf('map! %s %s', key, value)
  " endfor

  if &term =~# 'xterm' || &term =~# 'rxvt'
    for letter in map(range(26), {i,v->nr2char(char2nr('a')+v)})
      exec printf('set <a-%s>=%s', letter, letter)
    endfor
  endif

else

endif

if has('gui_running') || &termguicolors
  " 16 ansi colors (gruvbox) for gvim or if 'termguicolors' is on
  let g:terminal_ansi_colors = [
              \ '#282828',
              \ '#cc241d',
              \ '#98971a',
              \ '#d79921',
              \ '#458588',
              \ '#b16286',
              \ '#689d6a',
              \ '#a89984',
              \ '#928374',
              \ '#fb4934',
              \ '#b8bb26',
              \ '#fabd2f',
              \ '#83a598',
              \ '#d3869b',
              \ '#8ec07c',
              \ '#ebdbb2',
              \ ]
endif

if has('nvim')
  set rtp^=$HOME/.vim,$HOME/.vim/after
  let g:python3_host_prog = '/usr/bin/python3'
  let &shada="'200,<50,s10,h"
  tnoremap <expr> <m-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  " map to <c-f#> and <s-f#>
  for i in range(1,12)
    exec printf('map <f%d> <s-f%d>', i+12, i)
    exec printf('map <f%d> <c-f%d>', i+24, i)
  endfor
else
  set viminfo='500,<50,s10,h
  " viminfo= doesn't expand environment variable, check n of viminfo for detail
  let &viminfo .= ',r'.$VIMRUNTIME.'/doc'
  packadd termdebug

  if has('gui_running')
    set lines=100 columns=999
    set guioptions=aegim " remove menu, scroll bars
  endif
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
  autocmd FileType * try | call call('abbre#'.expand('<amatch>'), [])
              \ | catch /.*/ | endtry
  autocmd FileType * call misc#ui#loadFiletypeMap(expand('<amatch>'))
  autocmd FileType * setlocal formatoptions-=o formatoptions+=j
augroup end

" ------------------------------------------------------------------------------
" plugin
" ------------------------------------------------------------------------------

" ale
let g:ale_vim_vint_show_style_issues = 0
let g:ale_linters_explicit = 1

" you can not disable lint while enable language server, so i turn off auto
" lint.
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0

let g:ale_linters = {
\   'vim': ['vint'],
\   'sh': ['shellcheck'],
\   'glsl' : ['glslang'],
\   'cpp'  : []
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
" remove tab from select_completion, it's used in ultisnips
let g:ycm_key_list_select_completion = ['<Down>']
" let g:clang_user_options = ' -DCLANG_COMPLETE_ONLY' " not working
" compile_command.json exists?

" easyalign

" fugitive
command! -nargs=* Glg Git! lg --color=never <args>
command! -nargs=* Glg Git! log --graph --pretty=format:'%h - <%an> (%ad)%d %s' --abbrev-commit --date=local <args>

" lightline
let g:lightline = {
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
if &t_Co == 256
  let g:lightline.colorscheme = 'gruvbox'
endif

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
let s:fzf_btags_cmd = 'ctags -D "META_Object(library,name)=" -f -
            \ --excmd=number --sort=no --fields-c++=+{properties}{template}
            \ --fields=KsSi --kinds-c++=+pUN --links=yes --language-force=c++'

function! G_fzf_cpp_btags()
  " display everything except filename and line number.
  " fuzzy search all fields.
  call fzf#vim#buffer_tags(
        \ '',[s:fzf_btags_cmd . ' ' . expand('%:S')],
        \ {'options' :
        \      '--tiebreak=begin --with-nth 1,4.. --nth .. --prompt "Ctags> "'}
        \ )
endfunction

function! s:fzf_cpp_tags(...)
  let query = get(a:000, 0, '')
  " there exists an extra field which i don't know how to control in
  " fzf#vim#tags, that's why it use 1,4..-2
  let tags_options = { 'options' : '--no-reverse -m -d "\t" --tiebreak=begin
              \ --with-nth 1,4..-2 -n .. --prompt "Ctags> "'}
  call fzf#vim#tags(
        \ query,
        \ extend(copy(g:fzf_layout), tags_options))
endfunction

" change FZF_DEFAULT_COMMAND, execute cmd, restore FZF_DEFALUT_COMMAND
function! s:fzf(fzf_default_cmd, cmd)
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
    let source += [printf("%s\t%s\t%s\t%s\t%s", tag.name, tag.kind,
                \ get(tag, 'signature', ''), tag.filename, tag.cmd)]
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

let g:fzf_file_project = 'find . \( -name ".hg" -o -name ".git" -o
            \ -name "build" -o -name ".vscode" \) -prune -o -type f'

" tex
let g:tex_flavor = 'latex'
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk -layout <q-args> -
:command! -complete=file -nargs=1 Rpdffmt :r !pdftotext
            \ -nopgbrk -layout <q-args> - |fmt -csw78

" vim-json
let g:vim_json_syntax_conceal = 0

" markdown
let g:vim_markdown_conceal = 0

" indentLine
let g:indentLine_setConceal = 0

" auto-pairs
let g:AutoPairsShortcutToggle = '<a-a>'
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''

" gutentags
let g:gutentags_project_root = ['.vim']
let g:gutentags_exclude_project_root = [$HOME]
let g:gutentags_exclude_filetypes = ['cmake', 'sh', 'json', 'md']
let g:gutentags_define_advanced_commands = 1

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

function! s:less(cmd)
  exec 'e ' . tempname()
  setlocal buftype=nofile nobuflisted noswapfile
  exec printf('put! =execute(''%s'')', substitute(a:cmd, "'", "''", 'g'))
endfunction

nnoremap -- :edit $MYVIMRC<cr>

function! s:man()
  let wid=win_getid() | exec 'norm! K' | call win_gotoid(wid)
endfunction

function! s:omap(to)
  return printf(":normal v%s\"%s\<cr>", a:to, v:register)
endfunction

" text object
vnoremap aa :<C-U>silent! call misc#to#selCurArg({})<cr>
vnoremap ia :<C-U>silent! call misc#to#selCurArg({'excludeSpace':1})<cr>
onoremap <expr> ia <sid>omap('ia')
onoremap <expr> aa <sid>omap('aa')
vnoremap al :<C-U>silent! call misc#to#selLetter()<cr>
onoremap <expr> al <sid>omap('al')
vnoremap il :<C-U>silent! call misc#to#selLetter()<cr>
onoremap <expr> il <sid>omap('il')
vnoremap ic :<c-u>call misc#to#verticalE()<cr>
onoremap <expr> ic <sid>omap('ic')

" circumvent count, register changes
function! s:setupOpfunc(func)
  let &opfunc = a:func
  return 'g@'
endfunction

" motion and operator
nmap     ,a  <Plug>(EasyAlign)
vmap     ,a  <Plug>(EasyAlign)
map      ,c  <Plug>Commentary
nmap     ,cc <Plug>CommentaryLine
nmap     ,cu <Plug>Commentary<Plug>Commentary
nmap     ,cs <plug>NERDCommenterSexy
vmap     ,cs <Plug>NERDCommenterSexy
nnoremap ,e  :call misc#mo#vertical_motion('E')<cr>
nnoremap ,w  :call misc#mo#vertical_motion('W')<cr>
nnoremap ,b  :call misc#mo#vertical_motion('B')<cr>
vnoremap ,e  :<c-u>exec 'norm! gv' <bar> call misc#mo#vertical_motion('E')<cr>
vnoremap ,w  :<c-u>exec 'norm! gv' <bar> call misc#mo#vertical_motion('W')<cr>
vnoremap ,b  :<c-u>exec 'norm! gv' <bar> call misc#mo#vertical_motion('B')<cr>
onoremap ,e  :normal v,e<cr>
onoremap ,w  :normal v,w<cr>
onoremap ,b  :normal v,b<cr>
nnoremap ,,  ,
nnoremap ,l  :set opfunc=misc#op#searchLiteral<CR>g@
vnoremap ,l  :<c-u>call misc#op#searchLiteral(visualmode(), 1)<cr>
nnoremap ,s  :set opfunc=misc#op#substitude<CR>g@
vnoremap ,s  :<c-u>call misc#op#substitude(visualmode(), 1)<cr>
nnoremap <expr> ,h  <sid>setupOpfunc('misc#op#system')
vnoremap ,h  :<c-u>call misc#op#system(visualmode(), 1)<cr>
nnoremap <expr> ,<bar> <sid>setupOpfunc('misc#op#column')
vnoremap ,<bar>  :<c-u>call misc#op#column(visualmode(), 1)<cr>
nmap     ,sl :let @/="\\v<".expand("<cword>").">"<cr>vif:s/<c-r><c-/>/
nmap     ,s} :let @/="\\v<".expand("<cword>").">"<cr>vi}:s/<c-r><c-/>/
nmap     ,s{ ,s}
nnoremap ,G  :set opfunc=misc#op#literalGrep<CR>g@
vnoremap ,G  :<c-u>call misc#op#literalGrep(visualmode(), 1)<CR>
nnoremap ,g  :set opfunc=misc#op#searchInBrowser<CR>g@
vnoremap ,g  :<c-u>call misc#op#searchInBrowser(visualmode(), 1)<cr>

nnoremap yoc :exe 'set colorcolumn='. (empty(&colorcolumn) ? '+1' : '')<cr>

nnoremap Y  y$
nnoremap K  :call <sid>man()<cr>
nnoremap gc :SelectLastPaste<cr>

nnoremap <f3>    :set hlsearch!<cr>
nnoremap <f4>    :ALEHover<cr>
nnoremap <c-f7>  :ALELint<cr>
nnoremap <f12>   :YcmCompleter GoToDefinition<cr>
nnoremap <c-f12> :YcmCompleter GoToDeclaration<cr>

nnoremap <c-l> :nohlsearch<Bar>diffupdate<CR><C-L>
nnoremap <c-j> :BTags<cr>
nnoremap <c-h> :History<cr>
nnoremap <c-b> :Buffers<cr>
nnoremap <c-p> :call <sid>fzf(g:fzf_file_project, ":Files")<cr>
nnoremap <a-p> :FZF<cr>

" stop cursor movement from breaking undo in insert mode
inoremap <Left>  <c-g>U<Left>
inoremap <Right> <c-g>U<Right>
inoremap <C-Left>  <c-g>U<c-Left>
inoremap <C-Right> <c-g>U<c-Right>
inoremap <expr> <Home> repeat('<c-g>U<Left>', col('.') - 1)
inoremap <expr> <End> repeat('<c-g>U<Right>', col('$') - col('.'))
imap <a-l> <Right>
imap <a-h> <Left>

cnoremap <expr> %%  getcmdtype() == ":" ? expand("%:h")."/" : "%%"
cnoremap <expr> %t  getcmdtype() == ":" ? expand("%:t") : "%t"

nnoremap <leader>tt :call misc#term#toggleGterm()<cr>
tnoremap <leader>tt <c-\><c-n>:call misc#term#toggleGterm()<cr>
nnoremap <leader>th :call misc#term#hideall()<cr>
tnoremap <leader>th <c-\><c-n>:call misc#term#hideall()<cr>
nnoremap <leader>yd :YcmShowDetailedDiagnostic<cr>
nnoremap <leader>yf :YcmCompleter FixIt<cr>
nnoremap <leader>yt :YcmCompleter GetType<cr>

if has('nvim')
  let g:projMaps =
        \ {'c': [
        \         ['<f5>',         'n', 1, [], ':CppMakeRun<cr>'],
        \         ['<f6>',         'n', 1, [], ':CppCmake<cr>'],
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
        \         ['<f6>',         'n', 1, [], ':CppCmake<cr>'],
        \         ['<f7>',         'n', 1, [], ':CppMake<cr>'],
        \         ['<f9>',         'n', 1, [], ':Break<cr>'],
        \         ['<c-f9>',       'n', 1, [], ':Clear<cr>'],
        \         ['<f10>',        'n', 1, [], ':Over<cr>'],
        \         ['<c-f11>',      'n', 1, [], ':Step<cr>'],
        \         ['<s-f11>',      'n', 1, [], ':Finish<cr>'],
        \         ['<leader>dc',   'n', 1, [], ':Continue<cr>'],
        \         ['<leader>de',   'n', 1, [], ':Evaluate<cr>'],
        \         ['<leader>de',   'v', 1, [], ':Evaluate<cr>'],
        \ ]
        \ }
endif

set rtp+=~/.fzf,.vim,.vim/after
call plug#begin('~/.config/nvim/plugged')
"Plug 'scrooloose/syntastic'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' | Plug 'junegunn/vim-easy-align'
" Plug 'Yggdroot/indentLine'
" Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
" Plug 'jiangmiao/auto-pairs'
Plug 'ludovicchabant/vim-gutentags'
"Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-scriptease'
" Plug 'alx741/vinfo'
Plug 'tommcdo/vim-exchange'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'             " snippets used in ultisnips
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe'         " auto complete
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'rhysd/vim-clang-format'         "clang c/c++ format
Plug 'othree/html5.vim'
Plug 'elzr/vim-json'
Plug 'tikhomirov/vim-glsl'
Plug 'dedowsdi/cdef'
" Plug 'plasticboy/vim-markdown'
" Plug 'klen/python-mode'
" Plug 'pangloss/vim-javascript'
" Plug 'lervag/vimtex'                   " latex
call plug#end()

let g:gruvbox_number_column='bg1'
colorscheme gruvbox
if !has('gui_running')
  " undercurl doesn't work on terminal
  hi clear SpellBad
  hi SpellBad cterm=underline
endif

" some tiny util
command! -nargs=+ LinkVimHelp let @+ = misc#createVimhelpLink(<q-args>)
command! -nargs=+ LinkNvimHelp let @+ = misc#createNvimhelpLink(<q-args>)
command! UpdateVimHelpLink call misc#updateLink(0)
command! UpdateNvimHelpLink call misc#updateLink(1)
command! -nargs=* EditTemp e `=tempname().'_'.<q-args>`
command! Synstack echo misc#synstack()
command! SynID echo synIDtrans(synID(line('.'), col('.'), 1))
command! -nargs=+ SynIDattr echo synIDattr(
            \ synIDtrans(synID(line('.'), col('.'), 1)), <f-args>)
command! HiTest source $VIMRUNTIME/syntax/hitest.vim
command! TrimTrailingWhitespace :keepp %s/\v\s+$//g
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
  \ | diffthis | wincmd p | diffthis
command! SelectLastPaste exec 'normal! `[' . getregtype() . '`]'
command! -nargs=+ -complete=command Less call <sid>less(<q-args>)
command ReverseQuickFixList call setqflist(reverse(getqflist()))
command! SuperWrite :w !sudo tee % > /dev/null
command! ToggleAutoPairs :call AutoPairsToggle()
command! Terminal exe 'terminal' |
            \ call term_sendkeys("", printf("cd %s \<cr>",
            \ fnamemodify(bufname(winbufnr(winnr('#'))), ':h') ) )
