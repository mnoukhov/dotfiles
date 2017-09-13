call plug#begin('~/.vim/plugged')
"Python-mode
Plug 'klen/python-mode'
"NERD Commenter
Plug 'scrooloose/nerdcommenter'
"NERD Tree Explorer
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs'
"vim-airline status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"git
Plug 'tpope/vim-fugitive'
"vimtex
Plug 'lervag/vimtex'
"snippets engine
Plug 'sirver/ultisnips'
"snippets
Plug 'honza/vim-snippets'
"autocompletion
Plug 'valloric/youcompleteme'
call plug#end()


" Good vim defaults
set backspace=2         " backspace in insert mode works like normal editor
set tabstop=4		" tabs are 4 spaces
set shiftwidth=4	" indents are 4 spaces
set autoindent		" go back to the line
set nobackup            " get rid of anoying ~file
let mapleader = '\'
set title		" makes title bar display name
inoremap jj <Esc>

" Python-mode
let g:pymode_rope = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_lint_ignore = "E,W601"

" Solarized
syntax enable
if has('gui_running')
	set guioptions-=r		" remove right scrollbar
	set guioptions-=L		" remove left scrollbar
	set guioptions-=T		" remove toolbar
	set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12
	set background=dark
	colorscheme solarized
endif

" Airline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256

" vimtex
let g:vimtex_compiler_latexmk = {'callback' : 0}

" Snippet trigger
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsUsePythonVersion = 3	
