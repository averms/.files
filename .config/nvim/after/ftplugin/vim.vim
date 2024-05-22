runtime after/ftplugin/_pairs.vim

setlocal formatoptions-=o
setlocal foldmethod=marker
let g:vim_indent_cont = shiftwidth()

fun! s:MakeHeaderComment() abort
    let sep = repeat('"', 72)
    return sep . "\n" . sep
endfun

nnoremap <buffer> ,c 0D"=<sid>MakeHeaderComment()<cr>gpO" =><space>
