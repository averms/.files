"
" Minimal vimrc for git operations and VSCode.
"

let g:minimal_init = v:true

source ~/.config/nvim/init.vim

if exists('g:vscode')
    nnoremap <leader>b <cmd>Find<cr>
    nnoremap <leader>e <cmd>Edit<cr>

    " Use K for hover
    nunmap gh
endif
