fun! g:GetNewlineLabel() abort
    let l:newline_labels = {'unix': 'LF', 'mac': 'CR', 'dos': 'CRLF'}
    return get(newline_labels, &fileformat)
endfun

" Format the status line
set statusline=
set statusline+=%f%m%r%h
set statusline+=\ •\ %.60{substitute(getcwd(),$HOME,'~','')}
set statusline+=%=
set statusline+=\ %l:%c
set statusline+=\ %{g:GetNewlineLabel()}\ %y

set cursorline
set cursorlineopt=number

" Don't use true colors, we only need 16 for base16.
set notermguicolors

" Need to enable before setting color scheme so they aren't sourced twice:
" https://github.com/neovim/neovim/issues/9311.
syntax enable

" augroup color_additions
"     autocmd ColorScheme *
"         \ hi clear Identifier
" augroup END

set background=light
colorscheme my-sixteen
