" Settings for writing

setlocal textwidth=80

" Disable annoying default formatoptions
setlocal formatoptions=rctjnq

" No tabs
setlocal expandtab

" Some stupid ftplugin scripts clobber my softtabstop setting
setlocal softtabstop=-1

setlocal linebreak

" Optional leading whitespace
" Optionally match opening punctuation
" Numbers, #, and letters
" Closing punctuation
" Optional ending single space
" Or
" Bullet points

let &l:formatlistpat =
    \ '^\s*'
    \ . '[\[({]\?'
    \ . '[0-9#abcd]\{,2}'
    \ . '[\].)}]'
    \ . '\s'
    \ . '\|'
    \ . '^\s*[-+*]\s'

" Make header underlines like this
" ################################
nnoremap <buffer><silent> ,h0 <cmd>.copy+0<bar>normal! Vr#<CR>
nnoremap <buffer><silent> ,h1 <cmd>.copy+0<bar>normal! Vr=<CR>
nnoremap <buffer><silent> ,h2 <cmd>.copy+0<bar>normal! Vr-<CR>
nnoremap <buffer><silent> ,h3 <cmd>.copy+0<bar>normal! Vr^<CR>
nnoremap <buffer><silent> ,h4 <cmd>.copy+0<bar>normal! Vr"<CR>
