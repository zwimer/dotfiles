set shell=/bin/bash
"Define shell

" Set the tex flavor
let g:tex_flavor = 'tex'

set nocompatible		" be iMproved
filetype off			" for vundle, set on later

"Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"Alternatively, pass a path where Vundle should install plugins
"Call vundle#begin('~/some/path/here')

"Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Plugins
Plugin 'lervag/vimtex'
Plugin 'Valloric/YouCompleteMe'
Plugin 'https://github.com/tpope/vim-surround'
Plugin 'https://github.com/tpope/vim-commentary'
Plugin 'https://github.com/vim-scripts/haskell.vim'
"Bundle 'https://github.com/emgram769/vim-multiuser'

"All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Disable YouCOmpleteMe scratch spaces
set completeopt-=preview

"Show information
set number
set showmode

"Auto complete commands with <TAB>
set wildmenu

"Syntax highlighting and file type
filetype on
filetype indent on
syntax on

"Auto indent
set autoindent

"Text format
set tabstop=4
set linebreak
set smartcase
set ignorecase
set shiftwidth=4

"Search formatting
"Disable if you don't want to start searching until you hit enter
set hlsearch
set incsearch

"Allow pasting
set paste

"Display cursor info
"Note: must be set after paste
set ruler

"Allow backspace key
set backspace=indent,eol,start

"Allow the mouse to be used for everything but visual mode
set mouse=nic

"Map l to @q and ; to @w
nnoremap l @q
nnoremap ; @w

" Remap U to u
nnoremap U u

"Allow many tabs
set tabpagemax=50

"-------Custom commands-------

"Prepend line numbers to a file
command! PrependLineNumbers %s/^/\=printf('%-4d', line('.'))

"Switch to text editor mode
	"[s or ]s to move spell check selection left or right
	"z= to use spell check on selection
function! TEXT_fn()
   	set spell spelllang=en_us
	set breakindent
endfunction

"Used to easily call TEXT
command! TEXT call TEXT_fn()

"Disable beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif
