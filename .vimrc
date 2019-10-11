" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'StanAngeloff/php.vim'
call plug#end()
" End plugins

" Plugin settings
let vim_markdown_preview_github=1

" Go Specific mappings
nmap <C-C> :GoImports <CR>


set tabstop=2
set shiftwidth=2
set number
set ruler
