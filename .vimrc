call plug#begin('~/.vim/plugged')

" Utility
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'albfan/nerdtree-git-plugin'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'valloric/youcompleteme'
Plug 'eshion/vim-sync'
Plug 'tpope/vim-fugitive'
Plug 'ctrlpvim/ctrlp.vim'

" Aesthetics
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim'

" Langs
Plug 'klen/python-mode'
Plug 'lervag/vimtex'
call plug#end()


" Good vim defaults
set backspace=2     " backspace in insert mode works like normal editor
set tabstop=4		" tabs are 4 spaces
set shiftwidth=4	" indents are 4 spaces
set autoindent		" go back to the line
set nobackup        " get rid of anoying ~file
let mapleader = '\'
set title		" makes title bar display name
set expandtab
inoremap jj <Esc>
" don't overwrite on paste
xnoremap p pgvy
" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
" trim trailing whitespace on buffer save
autocmd BufWritePre * %s/\s\+$//e

" Python-mode
let g:pymode_rope = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_lint_ignore = "E,W601"
let g:pymode_python = 'python3'
let g:pymode_syntax_space_errors = 0

syntax enable
if has('gui_running')
    set guioptions-=r		" remove right scrollbar
    set guioptions-=L		" remove left scrollbar
    set guioptions-=T		" remove toolbar
    set guioptions-=e		" make tabline good
    set guioptions-=m		" remove menubar
    set guifont=Monospace\ 11
    let g:airline_theme='bubblegum'
    set encoding=utf8
else
    " powerline on fedora terminal
    python3 from powerline.vim import setup as powerline_setup
    python3 powerline_setup()
    python3 del powerline_setup
    let g:airline_theme='bubblegum'
endif


" Colors
colo seoul256
let g:seoul256_background = 235

" Airline
set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" vimtex
let g:vimtex_compiler_latexmk = {'callback' : 0}

" Snippet trigger
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsUsePythonVersion = 3

"YCM
let g:ycm_min_num_of_chars_for_completion = 4

"CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,results/*
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
