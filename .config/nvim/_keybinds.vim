" Make Q a no-op because I never want to be in Ex mode
nnoremap Q <Nop>

" Remap 0 and ^ to make the one that is more useful easier to press.
nnoremap 0 ^
nnoremap ^ 0
xnoremap 0 ^
xnoremap ^ 0

" Remap semicolon to colon and vice versa
nnoremap ; :
xnoremap ; :
nnoremap : ;
xnoremap : ;

" Easy paste of yanked text
nnoremap ,p "0p
xnoremap ,p "0p
nnoremap ,P "0P
xnoremap ,P "0P

" Easy access to system clipboard
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>p "+p
xnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>P "+P

" To allow Kitty to open links, temporarily disable mouse support by holding shift while
" clicking.

" Get the syntax group of under the cursor.
nnoremap <F10> <cmd>echo synIDattr(synID(line('.'), col('.'), 1), 'name')<CR>

" End of line in insert mode
inoremap <c-e> <c-o>$

" Beginning of line in insert mode
inoremap <c-a> <c-o>^

" Quickfix list
nnoremap ]q <cmd>cnext<cr>
nnoremap [q <cmd>cprevious<cr>

" Switch CWD to the directory of the open buffer
nnoremap <silent> <leader>cd <cmd>cd %:p:h<cr>

" Make escape on terminal easier to press.
tnoremap <c-x> <c-\><c-n>

noremap h <nop>
noremap l <nop>

" Toggle and untoggle spell checking
nnoremap <leader>ss <cmd>setlocal spell!<cr>

" Shortcuts
" next:        ]s
" previous:    [s
" add to dict: zg
" suggest:     z=

" Easy way to move between windows
nmap <c-k> <C-W>k
nmap <c-h> <C-W>h
nmap <c-l> <C-W>l
nmap <c-j> <C-W>j

" Next and previous buffer
nnoremap <leader>l <cmd>bnext<cr>
nnoremap <leader>h <cmd>bprevious<cr>

" Alternate file
nnoremap <leader><leader> <c-^>

" Switch buffer and edit with a view search
nnoremap <leader>b :buffer <c-d>
nnoremap <leader>e :edit <c-d>
nnoremap <leader>v :vsplit <c-d>

" Delete trailing white space. Copied from editorconfig.lua.
fun! s:clean_extra_spaces() abort
    let l:view = winsaveview()
    silent! undojoin
    silent keepjumps keeppatterns %s/\s\+$//e
    call winrestview(l:view)
endfun
command! Stripwhite call <sid>clean_extra_spaces()

" Delete all other buffers; leaves a no-name buffer.
fun! s:delete_bufs()
    let l:file = expand('%:p')
    write | bufdo! bdelete
    execute 'edit' l:file
endfun
command! Bufonly call <sid>delete_bufs()

" Upper case mode. Auto off at end
fun! s:enable_capsmode() abort
    augroup capsmode
        autocmd!
        autocmd InsertCharPre * let v:char = toupper(v:char)
        autocmd InsertLeave * if exists('#InsertCharPre') | autocmd! capsmode | endif
    augroup END
endfun
nnoremap <leader>ci :call <sid>enable_capsmode()<cr>i
nnoremap <leader>ca :call <sid>enable_capsmode()<cr>a
