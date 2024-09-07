syntax enable
set tabstop=2
set shiftwidth=2
set number
set ruler
" required by ctrlspace
set nocompatible
set hidden
set encoding=utf-8
set showtabline=1

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'preservim/nerdcommenter'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'branch': 'release/0.x'
  \ }
call plug#end()
" End plugins

" Plugin settings
let vim_markdown_preview_github=1

" ctrlspace - https://stackoverflow.com/questions/20245652/how-to-unbind-command-control-space-key-from-mac-os-x-10-9
nnoremap <silent><C-p> :CtrlSpace O<CR>
let g:CtrlSpaceUseTabline = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1

" lsp servers
au User lsp_setup call lsp#register_server({
     \ 'name': 'psalm-language-server',
     \ 'cmd': {server_info->[expand('vendor/bin/psalm-language-server')]},
     \ 'allowlist': ['php'],
     \ })

" asyncautocomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" Go Specific mappings
" nmap <C-C> :GoImports <CR>

