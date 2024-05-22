runtime after/ftplugin/_pairs.vim

if !exists('b:shfmt_cmd')
    let b:shfmt_cmd = 'shfmt -s -i 4'
endif
command! -buffer Format call averms#shfmt#Fmt()

fun! s:MakeHeaderComment() abort
    let sep = '# '.repeat('-', 70)
    return sep . "\n" . sep
endfun
nnoremap <buffer> ,c 0D"=<sid>MakeHeaderComment()<cr>gpO#<space>

if !(filereadable('Makefile') || filereadable('makefile'))
    compiler shellcheck
endif
