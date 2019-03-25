call plug#begin('~/.vim/plugged')

" Utility
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'albfan/nerdtree-git-plugin'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'eshion/vim-sync'
Plug 'tpope/vim-fugitive'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Konfekt/FastFold'
Plug 'editorconfig/editorconfig-vim'
Plug 'mileszs/ack.vim'

" Aesthetics
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim'

" Langs
Plug 'klen/python-mode', {'branch': 'develop'}
Plug 'tmhedberg/SimpylFold'
Plug 'lervag/vimtex'
Plug 'scrooloose/syntastic'

" Autocompletion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-ultisnips'
call plug#end()


" Good vim defaults
set backspace=2     " backspace in insert mode works like normal editor
set tabstop=4       " tabs are 4 spaces
set shiftwidth=4    " indents are 4 spaces
set expandtab       " expand tabs to spaces
set autoindent      " go back to the line
set nobackup        " get rid of anoying ~file
set title           " makes title bar display name
set number          " shows numbers
autocmd BufWritePre * %s/\s\+$//e " trim trailing whitespace on save
syntax on
filetype plugin indent on
set wildcharm=<tab>

" Neovim
set inccommand="nosplit"

" Terminal
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap <Esc> <C-\><C-n>
au TermOpen * setlocal nonumber norelativenumber

" Remaps
let mapleader = '\'
inoremap jj <Esc>
"don't overwrite on paste
xnoremap p pgvy
"clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
" buffer switching
:nnoremap <C-l> :buffer<Space><tab>

" UI
let g:seoul256_srgb = 1
set t_Co=256
colo seoul256
if has('gui_running')
    set guioptions-=r       " remove right scrollbar
    set guioptions-=L       " remove left scrollbar
    set guioptions-=T       " remove toolbar
    set guioptions-=e       " make tabline good
    set guioptions-=m       " remove menubar
    set guifont=Monospace\ 11
    set encoding=utf8
endif


" Python-Mode
let g:pymode_python = 'python3'
let g:pymode_options_colorcolumn = 0
let g:pymode_lint = 0
let g:pymode_lint_ignore = "E,W601"
let g:pymode_syntax_space_errors = 0
let g:pymode_folding = 0
let g:pymode_rope_completion = 0

" Airline
set laststatus=2    " Always display the statusline in all windows
set noshowmode      " Don't display mode name (e.g. Insert) below airline
let g:airline_theme='bubblegum'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" vimtex
let g:vimtex_compiler_progname = 'nvr'

" Snippet trigger
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsUsePythonVersion = 3

" CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,results/*
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Buffers
nmap <C-l> :bnext<CR>
nmap <C-h> :bprevious<CR>
nmap <C-x> :bp <BAR> bd #<CR>

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args='--ignore=E501,W503'
let g:syntastic_mode_map = { 'mode': 'passive' }

" SimplyFold
let g:SimpylFold_fold_import = 0

" Ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev ag Ack

" NCM2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
