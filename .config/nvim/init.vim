"
" Welcome home.
"

command! Erc edit $MYVIMRC

if exists('g:vscode')
    let g:minimal_init = v:true

    nnoremap <leader>b <cmd>Find<cr>
    nnoremap <leader>e <cmd>Edit<cr>

    " Use K for hover
    nunmap gh

    " next/prev diagnostic
    nnoremap ]d <cmd>lua require('vscode').action('editor.action.marker.next')<cr>
    nnoremap [d <cmd>lua require('vscode').action('editor.action.marker.prev')<cr>

    " code actions
    nnoremap gra <cmd>lua require('vscode').action('editor.action.quickFix')<cr>
    xnoremap gra <cmd>lua require('vscode').action('editor.action.quickFix')<cr>
endif

source ~/.config/nvim/_options.vim
source ~/.config/nvim/_keybinds.vim

lua require "averms"
