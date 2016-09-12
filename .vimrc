" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"Latex-Suite
Plugin 'LaTeX-Suite-aka-Vim-LaTeX'
"Python-mode
Plugin 'klen/python-mode'
"Dr. C's LaTeX indent
Plugin 'drc_indent'
"NERD Commenter
Plugin 'scrooloose/nerdcommenter'
"NERD Tree Explorer
Plugin 'scrooloose/nerdtree'
"vim-airline status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
call vundle#end()            " required
filetype plugin indent on    " required
" End Vundle


" Good vim defaults
set backspace=2         " backspace in insert mode works like normal editor
syntax on               " syntax highlighting
set tabstop=4			" tabs are 4 spaces
set shiftwidth=4		" indents are 4 spaces
set autoindent			" go back to the line
set nobackup            " get rid of anoying ~file
let mapleader = '\'
set title				" makes title bar display name

" Python-mode
let g:pymode_rope = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_lint_ignore = "E,W601"

" Airline
set laststatus=2

" LatexSuite
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode -src-specials $*'
let g:Tex_ViewRule_pdf='evince'
let g:tex_indent_items = 1

" Mappings yo!
inoremap jj <Esc>
augroup MyIMAPs
	au!
	au VimEnter * call IMAP('ELT', "\\begin{lstlisting}[language=<++>]\<CR><++>\<CR>\\end{lstlisting}<++>", 'tex')
	au VimEnter * call IMAP('EEX', "\\begin{ex}\<CR><++>\<CR>\\end{ex}<++>", 'tex')
	au VimEnter * call IMAP('ELN', "\\lstinline|<++>|<++>", 'tex')
augroup END
