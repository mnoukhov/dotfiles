" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"bufkill
Plugin 'qpkorr/vim-bufkill'
"Python-mode
Plugin 'klen/python-mode'
"Dr. C's LaTeX indent
Plugin 'drc_indent'
"NERD Commenter
Plugin 'scrooloose/nerdcommenter'
"NERD Tree Explorer
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
"vim-airline status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Latex-Suite
Plugin 'LaTeX-Suite-aka-Vim-LaTeX'
call vundle#end()            " required
filetype plugin indent on    " required
" End Vundle


" Good vim defaults
set backspace=2         " backspace in insert mode works like normal editor
set tabstop=4			" tabs are 4 spaces
set shiftwidth=4		" indents are 4 spaces
set autoindent			" go back to the line
set nobackup            " get rid of anoying ~file
let mapleader = '\'
set title				" makes title bar display name

" Buffer shit
map BP :BB<CR>
map BN :BF<CR>
map BD :BD<CR>

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
set laststatus=2
if has('gui_running')
	let g:airline_powerline_fonts = 1
	let g:airline_theme='solarized'
	let g:airline#extensions#tabline#enabled = 1
else
	let g:airline_theme='serene'
endif

" LatexSuite
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode -src-specials $*'
let g:Tex_ViewRule_pdf='evince'
let g:tex_indent_items = 1

inoremap jj <Esc>
augroup MyIMAPs
	au!
	au VimEnter * call IMAP('ELT', "\\begin{lstlisting}[language=<++>]\<CR><++>\<CR>\\end{lstlisting}<++>", 'tex')
	au VimEnter * call IMAP('EEX', "\\begin{ex}\<CR><++>\<CR>\\end{ex}<++>", 'tex')
	au VimEnter * call IMAP('ELN', "\\lstinline|<++>|<++>", 'tex')
augroup END
