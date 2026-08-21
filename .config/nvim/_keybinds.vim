" Make Q a no-op because I never want to be in Ex mode
nnoremap Q <Nop>

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
nnoremap <F10> <cmd>lua vim.show_pos()<cr>

" End of line in insert mode
inoremap <c-e> <c-o>$

" Beginning of line in insert mode
inoremap <c-a> <c-o>^

" Switch CWD to the directory of the open buffer
nnoremap <silent> <leader>cd <cmd>cd %:p:h<cr>

" Make escape on terminal easier to press.
tnoremap <c-f> <c-\><c-n>

" noremap h <nop>
" noremap l <nop>

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

" LSP mappings
" gra: code action
" grn: rename
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
