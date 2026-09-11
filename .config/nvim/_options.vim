" space is a really good leader key
nnoremap <space> <nop>
let mapleader=" "

" modelines only in first or last 3 lines of file will be read
set modelines=3

" confirm if you want to exit unsaved instead of requiring !
set confirm

" reload file when resuming from ctrl-z
augroup checktime_more
    autocmd!
    autocmd VimResume * checktime
augroup END


" use opened windows and tabs when switching buffers.
set switchbuf=useopen,uselast

" use bash for !, :make, :grep, and :term (dash would be faster but bash is necessary
" for aliases and interactive.)
set shell=bash

" scroll padding of 5 lines from the cursor when moving vertically
set scrolloff=5

" set up the wild menu
set suffixes+=.pdf
set wildignore+=*.pyc,*.class,*.aux,*.so*
set wildignorecase
set wildmode=list:longest,full
set wildoptions-=pum

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

" shorter timeout length
set timeoutlen=800

" turn swap files off
set noswapfile

" use line numbers
set number

" don't autowrap text
set formatoptions-=t
" a good default textwidth for gw
set textwidth=88

" 1 press of tab = 4 spaces. A literal tab in file is 6 spaces so that it is easy to
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
set pumheight=12

set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m

" no external plugin providers.
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0

" disable some default plugins
let g:loaded_matchparen = 1
let g:loaded_matchit = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrw = 1

set spelllang=en_us
set mouse=nv

set winborder=rounded

" custom cursor depending on mode
set guicursor=n-v-c-sm-r-cr-o:hor20,i-ci:ver20

" fix it when leaving. see https://github.com/neovim/neovim/issues/2583
augroup fix_cursor
    autocmd!
    autocmd VimLeave * set guicursor=a:hor20
augroup END

set cursorline
set cursorlineopt=number

fun! g:GetNewlineLabel() abort
    let l:newline_labels = {'unix': 'LF', 'mac': 'CR', 'dos': 'CRLF'}
    return get(newline_labels, &fileformat)
endfun

" TODO: new statusline with ruler and building on top of defaults
" already have ruler in statusline
set noruler

" Format the status line
set statusline=
if exists('g:vscode')
else
    set statusline=%f%m%r%h
    set statusline+=\ •\ %.60{substitute(getcwd(),resolve($HOME),'~','')}
    set statusline+=%=
    set statusline+=\ %l:%c
    set statusline+=\ %{g:GetNewlineLabel()}\ %y
endif

" augroup diffcolors
"     autocmd!
"     autocmd Colorscheme * call s:SetDiffHighlights()
" augroup END
"
" function! s:SetDiffHighlights()
"     if &background == "dark"
"         highlight DiffAdd gui=bold guifg=none guibg=#2e4b2e
"         highlight DiffDelete gui=bold guifg=none guibg=#4c1e15
"         highlight DiffChange gui=bold guifg=none guibg=#45565c
"         highlight DiffText gui=bold guifg=none guibg=#996d74
"     else
"         highlight DiffAdd gui=bold guifg=none guibg=palegreen
"         highlight DiffDelete gui=bold guifg=none guibg=tomato
"         highlight DiffChange gui=bold guifg=none guibg=lightblue
"         highlight DiffText gui=bold guifg=none guibg=lightpink
"     endif
" endfunction

" Don't use true colors, we only need 16 for base16.
set notermguicolors

set background=light
colorscheme dim
" minicyan is also nice
" morning is also nice
