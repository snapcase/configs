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
set encoding=utf-8    
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

" open help in new tabs
cabbrev help tab help 

" colors
if $TERM =~ "256"
  set t_Co=256
  "colorscheme neverland 
endif

" reformat paragraphs (visual/normal)
vmap Q gq
nmap Q gqap

" forgot to sudo?
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

" <F2> toggles NerdTree
map <F2> :NERDTreeToggle<CR>

" <Space> clears search highlight
noremap <silent> <Space> :silent noh<Bar>echo<CR>

" insert datestamp when you type dts  
iab <expr> dts strftime("%a %d %b %Y")

" vim-snipmate
au BufRead *.php set ft=php.html
au BufNewFile *.php set ft=php.html

" Define a function that can tell me if a file is executable
function! FileExecutable (fname)
  execute "silent! ! test -x" a:fname
  return v:shell_error
endfunction
" Automatically make scripts executable if they aren't already
au BufWritePost *.sh if FileExecutable("%:p") | :!chmod a+x %   endif

"au Filetype haskell call SetHaskellOpts()
"function! SetHaskellOpts()
"  setlocal autochdir
"  setlocal shiftwidth=4
"endfunction

au BufRead,BufNewFile *.md set filetype=markdown
