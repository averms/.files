runtime after/ftplugin/_prose.vim

setlocal shiftwidth=2
" definition lists with Pandoc syntax
setlocal comments=fb:*,fb:-,fb:+,n:>,fb::
setlocal commentstring=<!--\ %s\ -->
setlocal conceallevel=2

" ysiwb surround word in **
" or Sb surrounds selection in **
let b:surround_{char2nr('b')} = "**\r**"

" Disabling HTML include messes up spell checking, this fixes it.
" syntax spell toplevel

setlocal includeexpr=v:fname.'.md'

" Copied from fcpg/vim-wakiki
func! s:ToggleListItem() abort
    let line = getline('.')
    let box  = matchstr(line, '\[\%( \|x\)\]')
    if box != ""
        if box =~ ' '
            exe printf('s/\[\zs%s\ze\]/%s/', ' ', 'x')
            norm! ``
        elseif box =~ 'x'
            exe printf('s/\[\zs%s\ze\]/%s/', 'x', ' ')
            norm! ``
        endif
    endif
endfunc
nnoremap <buffer><silent> <leader>d <cmd>call <sid>ToggleListItem()<cr>
