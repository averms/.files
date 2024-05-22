runtime after/ftplugin/_pairs.vim

" Lua-specific pairs
inoremap <buffer> [[<CR> [[<CR>]]<Esc>O

" cause the dumb ftplugin wants to change my formatoptions
setlocal formatoptions-=o
setlocal formatoptions-=c
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.lua'

" regular comments with `--`
" multiline header comments like:
"   --- header
"   -- blah blah blah
"   --
setlocal comments=s1:---,m:--,ex:--,:--
