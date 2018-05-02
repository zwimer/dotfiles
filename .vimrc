set shell=/bin/bash
" Define shell

" Set the tex flavor
let g:tex_flavor = 'tex'

set nocompatible		" be iMproved
filetype off			" for vundle, set on later

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Alternatively, pass a path where Vundle should install plugins
" Call vundle#begin('~/some/path/here')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'lervag/vimtex'						" Latex
Plugin 'Valloric/YouCompleteMe'				" Autocomplete
Plugin 'airblade/vim-gitgutter'				" Git status of lines
Plugin 'tpope/vim-commentary'				" Commenting via gcc
Plugin 'bogado/file-line'					" Run vim A:B to open file a at line B
Plugin 'ntpeters/vim-better-whitespace'		" Handles trailing whitespace (trim on save also)
" Plugin 'tpope/vim-surround'				" Change surrounding characters
" Plugin 'chrisbra/csv'						" csv's work better (requires config!)
" Plugin 'godlygeek/tabular'				" Align items with tabs at a character
" Plugin 'nathanaelkane/vim-indent-guides'	" Indent guits
" Plugin 'vim-scripts/haskell'				" Haskell

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Show information
set number
set showmode

" Auto complete commands with <TAB>
set wildmenu

" Syntax highlighting and file type
filetype on
filetype indent on
syntax on

" Auto indent
set autoindent

" Text format
set tabstop=4
set linebreak
set smartcase
set ignorecase
set shiftwidth=4

" Search formatting
" Disable if you don't want to start searching until you hit enter
set hlsearch
set incsearch

" Allow backspace key
set backspace=indent,eol,start

" Allow the mouse to be used for everything
set mouse=a

" Map l to @q and ; to @w
nnoremap l @q
nnoremap ; @w

" Remap U to u
nnoremap U u

" Allow many tabs
set tabpagemax=50

" Allow pasting
set paste

" Display cursor info
" Note this must be set after paste
set ruler

" Vimtex disable callbacks
let g:vimtex_compiler_latexmk = {'callback' : 0}

" Disable YouCompleteMe scratch spaces
set completeopt-=preview

" Setup gutter
set updatetime=250
let g:gitgutter_max_signs = 500

" Setup better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" Setup indent guides
colorscheme default
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=lightgrey ctermbg=252
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=lightgrey ctermbg=251
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1


"-------Custom commands-------


" Prepend line numbers to a file
command! PrependLineNumbers %s/^/\=printf('%-4d', line('.'))

" Switch to text editor mode
" [s or ]s to move spell check selection left or right
" z= to use spell check on selection
function! TEXT_fn()
   	set spell spelllang=en_us
	set breakindent
endfunction

" Used to easily call TEXT
command! TEXT call TEXT_fn()

" Disable beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif
