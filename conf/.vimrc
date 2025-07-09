set shell=/bin/bash
" Define shell

" Define encoding
set encoding=utf-8

" Set the tex flavor
let g:tex_flavor = 'tex'

set nocompatible " be iMproved (set most everything after this, it resets a lot of options)
filetype off     " for vundle, set on later

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Alternatively, pass a path where Vundle should install plugins
" Call vundle#begin('~/some/path/here')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'airblade/vim-gitgutter'             " Git status of lines (switched to 'main' branch)
Plugin 'tpope/vim-commentary'               " Commenting via gcc
Plugin 'bogado/file-line'                   " Run vim A:B to open file a at line B (switched to 'main' branch)
Plugin 'ntpeters/vim-better-whitespace'     " Handles trailing whitespace (trim on save also)
Plugin 'tpope/vim-surround'                 " Change surrounding characters
Plugin 'zwimer/vim-caddyfile'               " Caddy syntax highlighting
" Plugin 'mbbill/undotree'                    " Undo tree
" Plugin 'Valloric/YouCompleteMe'             " Autocomplete
" Plugin 'lervag/vimtex'                      " Latex
" Plugin 'chrisbra/csv'                       " csv's work better (requires config!)
" Plugin 'godlygeek/tabular'                  " Align items with tabs at a character
" Plugin 'nathanaelkane/vim-indent-guides'    " Indent guides
" Plugin 'vim-scripts/haskell'                " Haskell
if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'
    endif
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Vim info file
set viminfo+=n~/.vim/viminfo

" Show information
set number
set showmode

" Auto complete commands with <TAB>
set wildmenu

" Syntax highlighting and file type
filetype on
filetype indent on
syntax on
set list
set listchars=tab:\ \ ┊,extends:…,precedes:…
" set listchars=eol:↓,tab:\ \ ┊,trail:●,extends:…,precedes:…,space:·

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

" Map l to @q
nnoremap l @q

" Remap U to u due to accidents
nnoremap U u

" Remap shift up to up
vnoremap <S-Up> <Up>

" Remap shift down to down
vnoremap <S-Down> <Down>

" Allow many tabs
set tabpagemax=500

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
let g:strip_whitespace_confirm=0

" Setup indent guides
colorscheme default
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=lightgrey ctermbg=252
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=lightgrey ctermbg=251
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1

" diff colors
if &diff
    colorscheme github
endif

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

function! DisplayColorSchemes()
   let currDir = getcwd()
   exec "cd $VIMRUNTIME/colors"
   for myCol in split(glob("*"), '\n')
      if myCol =~ '\.vim'
         let mycol = substitute(myCol, '\.vim', '', '')
         exec "colorscheme " . mycol
         exec "redraw!"
         echo "colorscheme = ". myCol
         sleep 2
      endif
   endfor
   exec "cd " . currDir
endfunction
