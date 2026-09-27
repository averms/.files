"""
""" Welcome home
"""

command! Erc edit $MYVIMRC

"" Options

" Space is a really good leader key
nnoremap <space> <nop>
let mapleader=" "
let maplocalleader=","

" Modelines only in first or last 3 lines of file will be read
set modelines=3

" Confirm if you want to exit unsaved instead of requiring !
set confirm

" Reload file when resuming from ctrl-z
augroup checktime_more
    autocmd!
    autocmd VimResume * checktime
augroup END

" Use opened windows and tabs when switching buffers
set switchbuf^=useopen

" Use bash for !, :make, :grep, and :term no matter the login shell
set shell=bash

" Scroll padding of 5 lines from the cursor when moving vertically
set scrolloff=5

" Set up the wild menu
set suffixes+=.pdf
set wildignore+=*.pyc,*.class,*.aux,*.so,*.so.*
set wildignorecase
set wildmode=list:longest,full
set wildoptions-=pum

" Make the paragraph motions work as expected (ignore roff macros)
set paragraphs=
set sections=

set listchars+=space:·

" Turn off highlighting after search
set nohlsearch

set nowrapscan

" Smartcase (case-sensitive when caps in pattern)
set ignorecase
set smartcase

" Try to improve scrolling performance
set synmaxcol=300

" Shorter timeout length
set timeoutlen=800

" Turn swap files off
set noswapfile

" Use line numbers
set number

" Don't autowrap text
set formatoptions-=t
" a good default textwidth for gw
set textwidth=88

" 1 press of tab = 4 spaces. A literal tab in file is 6 spaces so that it is easy to
" tell.
set expandtab
set tabstop=6
set shiftwidth=4

" The value of softtabstop should always be equivalent to shiftwidth
set softtabstop=-1

" Lots of ftplugins clobber these two
augroup restore_indent_opts
    autocmd!
    autocmd FileType * setlocal tabstop< softtabstop<
augroup END

" Indent stuff is interesting in Vim. Most filetypes have indentexpr defined by default,
" so 'smartindent' almost never has an effect. 'autoindent' is also rarely used because
" indentexpr overrides it. The defaults work for me.

" Don't give annoying messages when ins-completing
set shortmess+=c

" Other useful completion options
set completeopt=menuone,noinsert
set pumheight=12

" No external plugin providers
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0

" Disable some default plugins
let g:loaded_matchparen = 1
let g:loaded_matchit = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrw = 1

set spelllang=en_us
set mouse=nv

set winborder=rounded

" Custom cursor depending on mode
set guicursor=n-v-c-sm-r-cr-o:hor20,i-ci:ver20

set cursorline
set cursorlineopt=number

" Don't use true colors, we only need 16 for base16
set notermguicolors

set background=light
colorscheme dim
" minicyan and morning are also nice

"" Keybinds

" To allow Kitty to open links, temporarily disable mouse support by holding shift while
" clicking

" For the vscode-neovim extension
if exists('g:vscode')
    let g:averms_minimal_init = v:true

    nnoremap <leader>b <cmd>Find<cr>
    nnoremap <leader>e <cmd>Edit<cr>

    " Use K for hover instead
    nunmap gh

    " next/prev diagnostic
    nnoremap ]d <cmd>lua require('vscode').action('editor.action.marker.next')<cr>
    nnoremap [d <cmd>lua require('vscode').action('editor.action.marker.prev')<cr>

    " code actions
    nnoremap gra <cmd>lua require('vscode').action('editor.action.quickFix')<cr>
    xnoremap gra <cmd>lua require('vscode').action('editor.action.quickFix')<cr>
endif

" Remap semicolon to colon and vice versa
nnoremap ; :
xnoremap ; :
onoremap ; :
nnoremap : ;
xnoremap : ;
onoremap : ;

" Easy paste of yanked text
nnoremap ,p "0p
xnoremap ,p "0p
nnoremap ,P "0P
xnoremap ,P "0P

" Easy access to system clipboard
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>p "+p
xnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>P "+P

" End of line in insert mode
inoremap <c-e> <c-o>$

" Beginning of line in insert mode
inoremap <c-a> <c-o>^

" Switch CWD to the directory of the open buffer
nnoremap <leader>cd <cmd>cd %:p:h<cr>

" Make escape on terminal easier to press
tnoremap <c-space> <c-\><c-n>

" noremap h <nop>
" noremap l <nop>

" Alternate file
nnoremap <leader><leader> <c-^>

" LSP mappings
" gra: code action
" grn: rename
" gri: go to all implementations
nnoremap <leader>f <cmd>lua vim.lsp.buf.format { async = true }<cr>

" Auto-insert bracket pairs
fun! s:bracketpair_mappings() abort
    inoremap <buffer> (<CR> (<CR>)<Esc>O
    inoremap <buffer> {<CR> {<CR>}<Esc>O
    inoremap <buffer> [<CR> [<CR>]<Esc>O
endfun
augroup bind_bracket_pairs
    autocmd!
    autocmd FileType c,cpp,css,javascript,json,lua,meson,python,rust,yaml,go,toml,tcl call <sid>bracketpair_mappings()
augroup END

"" Commands and plugins and fancy Lua stuff

lua require "averms"
