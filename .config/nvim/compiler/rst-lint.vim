let current_compiler = 'rst-lint'

CompilerSet makeprg=rst-lint\ --level\ info\ %
CompilerSet errorformat=%ESEVERE\ %f:%l\ %m,%EERROR\ %f:%l\ %m,%WWARNING\ %f:%l\ %m,%IINFO\ %f:%l\ %m,%C%m

" Errorformat copied from neomake and translated like so:
" let @a = 'CompilerSet errorformat=' . escape({efmt}, '" |\')
" where {efmt} is the copied text.
