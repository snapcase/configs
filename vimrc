set nocompatible      " We don't want vi compatibility.
set smartindent
set autoindent
set expandtab
set tabstop=8
set softtabstop=2
set shiftwidth=2
set scrolloff=3
set number
set pastetoggle=<F12>
set ignorecase
set hlsearch
set ruler

set modeline          " allows files to change vim-settings

" attempting to fix the syntax highlight performance
set nocursorcolumn
set nocursorline
syntax sync minlines=256

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

syntax enable         " syntax highlighting

if $TERM =~ "256"
  set t_Co=256
endif

syntax on

" <Space> clears search highlight
noremap <silent> <Space> :silent noh<Bar>echo<CR>

" Toggle line numbers
noremap <c-n> :set number!<CR>
