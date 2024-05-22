runtime after/ftplugin/_pairs.vim

" Clean up comment syntax, the default has a bunch of useless stuff.
setlocal commentstring=//%s
setlocal comments=s1:/*,mb:*,ex:*/,b:///,://
setlocal path+=/usr/include,/usr/local/include
setlocal cinoptions+=:0,L0
