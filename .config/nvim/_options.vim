" space is a really good leader key
nnoremap <space> <nop>
let mapleader=" "

" modelines only in first or last 3 lines of file will be read
set modelines=3

" confirm if you want to exit unsaved instead of requiring !
set confirm

" use opened windows and tabs when switching buffers.
set switchbuf=useopen,uselast

" use bash for !, :make, :grep, and :term (dash would be faster but bash is necessary
" for aliases and interactive.)
set shell=bash

" scroll padding of 5 lines from the cursor when moving vertically
set scrolloff=5

" custom cursor depending on mode
set guicursor=n-v-c-sm-r-cr-o:hor20,i-ci:ver20

" fix it when leaving (https://github.com/neovim/neovim/issues/2583)
augroup fix_cursor
    autocmd!
    autocmd VimLeave * set guicursor=a:hor20
augroup END

" set up language-agnostic find path
set path=.,

" set up the wild menu
set wildignorecase
set wildmode=list:longest,full
set suffixes+=.pdf
set wildignore+=*.pyc,*.class,*.aux,*.so*

" already have ruler in statusline
set noruler

" Make the paragraph motions work as expected (ignore roff macros).
set paragraphs=
set sections=

set listchars+=space:·

" turn off highlighting after search
set nohlsearch

set nowrapscan

" smartcase (case-sensitive when caps in pattern)
set ignorecase
set smartcase

" inccommand and incsearch are good by default.

" don't redraw while executing macros (good performance config)
set lazyredraw

" Try to improve scrolling performance
set synmaxcol=300
syntax sync minlines=80

" don't jump to start of line on changing buffers.
set nostartofline

" shorter timeout length
set timeoutlen=600

" turn backup off
set nowritebackup
set noswapfile

" use line numbers
set number

" don't autowrap text, don't auto insert the current comment leader.
set formatoptions-=t
" a good default textwidth for gw
set textwidth=88

" 1 press of tab = 4 spaces. A literal tab in file is 8 spaces so that it is easy to
" tell.
set expandtab
set tabstop=6
set shiftwidth=4
" Softtabstop should always be equivalent to shiftwidth.
set softtabstop=-1

" Indent stuff is interesting in Vim. Most filetypes have indentexpr defined by default,
" so 'smartindent' almost never has an effect. 'autoindent' is also rarely used because
" indentexpr overrides it. The defaults work for me.

" don't give annoying messages when ins-completing
set shortmess+=c

" other useful completion options
set completeopt=menuone,noinsert
set pumheight=6

" no external plugin providers.
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0

" disable some default plugins
let g:loaded_matchparen = 1
let g:loaded_matchit = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrw = 1

set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m

set spelllang=en_us
set mouse=nv
