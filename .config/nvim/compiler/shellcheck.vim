let current_compiler = 'shellcheck'

CompilerSet makeprg=shellcheck\ -a\ \-o\ all\ -Cnever\ -f\ gcc\ %
CompilerSet errorformat=%f:%l:%c:\ %trror:\ %m\ [SC%n],%f:%l:%c:\ %tarning:\ %m\ [SC%n],%I%f:%l:%c:\ Note:\ %m\ [SC%n]

" Errorformat copied from neomake and translated like so:
" let @a = 'CompilerSet errorformat=' . escape({efmt}, '" |\')
" where {efmt} is the copied text.
