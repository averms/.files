" Settings for writing

setlocal textwidth=80

" Disable annoying default formatoptions
setlocal formatoptions=rctjnq

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
