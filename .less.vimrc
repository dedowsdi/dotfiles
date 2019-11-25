" tiny vimrc used for less or pager

autocmd!
set ttimeout ttimeoutlen=5 timeoutlen=1000
set nocompatible ruler novisualbell showmode showcmd hidden mouse=a background=dark
set incsearch  ignorecase smartcase
set showmatch matchtime=3
set laststatus=2 cmdheight=2 scrolloff=1
set wildmode=longest,list " set wildmode to unix glob
set matchpairs+=<:>
set buftype=nofile nomodifiable fdc=0 nobuflisted
nnoremap -- :edit +set\ noreadonly ~/.less.vimrc<cr>
nnoremap <f3> :set hlsearch!<cr>

"nnoremap s :SearchOption<space>
"command! -nargs=1 SearchOption /\v\C^\s*<args>
" option

filetype plugin indent on
syntax enable

if has('unix')
  call plug#begin('~/.vim/plugged')
  " Plug 'altercation/vim-colors-solarized'
  Plug 'morhetz/gruvbox'
  Plug 'dedowsdi/misc'
  call plug#end()
  colorscheme gruvbox
endif

" set termguicolors
let g:gruvbox_number_column='bg1'
colorscheme gruvbox
