" base16-Materia
" Author: Defman21
" Generated From: https://github.com/averms/base16-vim

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "base16-materia"

" Editor colors
hi Normal       guifg=#CDD3DE guibg=#263238 ctermfg=07   ctermbg=00  
hi Debug        guifg=#EC5F67              ctermfg=01      
hi Directory    guifg=#89DDFF              ctermfg=04      
hi Error        guifg=#263238 guibg=#EC5F67 ctermfg=00   ctermbg=01  
hi ErrorMsg     guifg=#EC5F67 guibg=#263238 ctermfg=01   ctermbg=00  
hi Exception    guifg=#EC5F67              ctermfg=01      
hi FoldColumn   guifg=#80CBC4 guibg=#2C393F ctermfg=06   ctermbg=10  
hi Folded       guifg=#707880 guibg=#2C393F ctermfg=08   ctermbg=10  
hi IncSearch    guifg=#2C393F guibg=#EA9560 ctermfg=10   ctermbg=09 gui=NONE  cterm=NONE
hi Macro        guifg=#EC5F67              ctermfg=01      
hi MatchParen                guibg=#707880     ctermbg=08  
hi ModeMsg      guifg=#8BD649              ctermfg=02      
hi MoreMsg      guifg=#8BD649              ctermfg=02      
hi Question     guifg=#89DDFF              ctermfg=04      
hi Search       guifg=#2C393F guibg=#FFCC00 ctermfg=10   ctermbg=03  
hi Substitute   guifg=#2C393F guibg=#FFCC00 ctermfg=10   ctermbg=03 gui=NONE  cterm=NONE
hi SpecialKey   guifg=#707880              ctermfg=08      
hi TooLong      guifg=#EC5F67              ctermfg=01      
hi Underlined   guifg=NONE                         ctermfg=NONE    
hi Visual                    guibg=#37474F     ctermbg=11  
hi VisualNOS    guifg=#EC5F67              ctermfg=01      
hi WarningMsg   guifg=#EC5F67              ctermfg=01      
hi WildMenu     guifg=#EC5F67 guibg=#FFCC00 ctermfg=01      
hi Title        guifg=#89DDFF              ctermfg=04     gui=NONE  cterm=NONE
hi Conceal      guifg=#89DDFF guibg=#263238 ctermfg=04   ctermbg=00  
hi Cursor       guifg=#263238 guibg=#CDD3DE ctermfg=00   ctermbg=07  
hi NonText      guifg=#707880 guibg=#263238 ctermfg=08   ctermbg=00  
hi LineNr       guifg=#707880 guibg=#2C393F ctermfg=08   ctermbg=10  
hi SignColumn   guifg=#707880 guibg=#2C393F ctermfg=08   ctermbg=10  
hi StatusLine   guifg=#C9CCD3 guibg=#37474F ctermfg=12   ctermbg=11 gui=NONE  cterm=NONE
hi StatusLineNC guifg=#707880 guibg=#2C393F ctermfg=08   ctermbg=10 gui=NONE  cterm=NONE
hi VertSplit    guifg=#37474F guibg=#37474F ctermfg=11   ctermbg=11 gui=NONE  cterm=NONE
hi ColorColumn               guibg=#2C393F     ctermbg=10 gui=NONE  cterm=NONE
hi CursorColumn              guibg=#2C393F     ctermbg=10 gui=NONE  cterm=NONE
hi QuickFixLine              guibg=#2C393F     ctermbg=10 gui=NONE  cterm=NONE
hi Pmenu        guifg=#CDD3DE guibg=#2C393F ctermfg=07   ctermbg=10 gui=NONE  cterm=NONE
hi PmenuSel     guifg=#2C393F guibg=#CDD3DE ctermfg=10   ctermbg=07  
hi TabLine      guifg=#707880 guibg=#2C393F ctermfg=08   ctermbg=10 gui=NONE  cterm=NONE
hi TabLineFill  guifg=#707880 guibg=#2C393F ctermfg=08   ctermbg=10 gui=NONE  cterm=NONE
hi TabLineSel   guifg=#8BD649 guibg=#2C393F ctermfg=02   ctermbg=10 gui=NONE  cterm=NONE
hi CursorLineNr guifg=#C9CCD3 guibg=#2C393F ctermfg=12   ctermbg=10  

" Hacky workaround for Neovim bug. Adapted from
" https://github.com/neovim/neovim/issues/9019#issuecomment-521532103.
if has('gui_running') || &termguicolors
  hi CursorLine      guibg=#2C393F ctermfg=white ctermbg=10 gui=NONE cterm=NONE
else
  hi CursorLine guifg=#FFFFFF guibg=#2C393F      ctermbg=10 gui=NONE cterm=NONE
endif

" General language syntax
hi Boolean      guifg=#EA9560   ctermfg=09      
hi Character    guifg=#EC5F67   ctermfg=01      
hi Comment      guifg=#707880   ctermfg=08      
hi Conditional  guifg=#82AAFF   ctermfg=05      
hi Constant     guifg=#EA9560   ctermfg=09      
hi Define       guifg=#82AAFF   ctermfg=05     gui=NONE  cterm=NONE
hi Delimiter    guifg=#EC5F67   ctermfg=14      
hi Float        guifg=#EA9560   ctermfg=09      
hi Function     guifg=#89DDFF   ctermfg=04      
hi Identifier   guifg=#EC5F67   ctermfg=01     gui=NONE  cterm=NONE
hi Include      guifg=#89DDFF   ctermfg=04      
hi Keyword      guifg=#82AAFF   ctermfg=05      
hi Label        guifg=#FFCC00   ctermfg=03      
hi Number       guifg=#EA9560   ctermfg=09      
hi Operator     guifg=#CDD3DE   ctermfg=07     gui=NONE  cterm=NONE
hi PreProc      guifg=#FFCC00   ctermfg=03      
hi Repeat       guifg=#FFCC00   ctermfg=03      
hi Special      guifg=#80CBC4   ctermfg=06      
hi SpecialChar  guifg=#EC5F67   ctermfg=14      
hi Statement    guifg=#EC5F67   ctermfg=01     gui=NONE  cterm=NONE
hi StorageClass guifg=#FFCC00   ctermfg=03      
hi String       guifg=#8BD649   ctermfg=02      
hi Structure    guifg=#82AAFF   ctermfg=05      
hi Tag          guifg=#FFCC00   ctermfg=03      
hi Todo         guifg=#FFCC00 guibg=NONE ctermfg=03 ctermbg=NONE  
hi Type         guifg=#FFCC00   ctermfg=03     gui=NONE  cterm=NONE
hi Typedef      guifg=#FFCC00   ctermfg=03      

" Diff mode
hi DiffAdd    guifg=#8BD649 guibg=#2C393F ctermfg=02 ctermbg=10 gui=NONE cterm=NONE
hi DiffChange guifg=#707880 guibg=#2C393F ctermfg=08 ctermbg=10 gui=NONE cterm=NONE
hi DiffDelete guifg=#EC5F67 guibg=#2C393F ctermfg=01 ctermbg=10 gui=NONE cterm=NONE
hi DiffText   guifg=#89DDFF guibg=#2C393F ctermfg=04 ctermbg=10 gui=NONE cterm=NONE

" ft-diff
hi link diffBDiffer WarningMsg
hi link diffCommon WarningMsg
hi link diffDiffer WarningMsg
hi link diffIdentical WarningMsg
hi link diffIsA WarningMsg
hi link diffNoEOL WarningMsg
hi link diffOnly WarningMsg
hi link diffRemoved WarningMsg
hi link diffAdded String

" Spelling
hi SpellBad   ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE cterm=underline gui=underline guisp=#EC5F67
hi SpellCap   ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE cterm=underline gui=underline guisp=#80CBC4
hi SpellLocal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE cterm=underline gui=underline guisp=#89DDFF
hi SpellRare  ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE cterm=underline gui=underline guisp=#82AAFF

" Terminal colors
if has("nvim")
  let g:terminal_color_0 = "#263238"
  let g:terminal_color_1 = "#EC5F67"
  let g:terminal_color_2 = "#8BD649"
  let g:terminal_color_3 = "#FFCC00"
  let g:terminal_color_4 = "#89DDFF"
  let g:terminal_color_5 = "#82AAFF"
  let g:terminal_color_6 = "#80CBC4"
  let g:terminal_color_7 = "#CDD3DE"
  let g:terminal_color_8 = "#707880"
  let g:terminal_color_9 = "#EC5F67"
  let g:terminal_color_10 = "#8BD649"
  let g:terminal_color_11 = "#FFCC00"
  let g:terminal_color_12 = "#89DDFF"
  let g:terminal_color_13 = "#82AAFF"
  let g:terminal_color_14 = "#80CBC4"
  let g:terminal_color_15 = "#FFFFFF"
  let g:terminal_color_background = g:terminal_color_0
  let g:terminal_color_foreground = g:terminal_color_5
  if &background == "light"
    let g:terminal_color_background = g:terminal_color_7
    let g:terminal_color_foreground = g:terminal_color_2
  endif
elseif has("terminal")
  let g:terminal_ansi_colors = [
      \ "#263238",
      \ "#EC5F67",
      \ "#8BD649",
      \ "#FFCC00",
      \ "#89DDFF",
      \ "#82AAFF",
      \ "#80CBC4",
      \ "#CDD3DE",
      \ "#707880",
      \ "#EC5F67",
      \ "#8BD649",
      \ "#FFCC00",
      \ "#89DDFF",
      \ "#82AAFF",
      \ "#80CBC4",
      \ "#FFFFFF",
  \]
endif

" vim: filetype=vim expandtab shiftwidth=2 softtabstop=2
