" My customizations to Neovim's default colorscheme.

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "my-default"

hi Statement cterm=NONE gui=NONE
hi Comment cterm=italic ctermfg=DarkGray
hi clear Pmenu
" hi PmenuSel cterm=reverse gui=reverse blend=0
