" my-sixteen.vim -- Vim color scheme.
" Author:      Aman
" Description: A 'light' colorscheme using exclusively the lower 16 colors of the xterm palette.
" Last Change: 2025-03-17

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "my-sixteen"

hi Normal        ctermbg=NONE ctermfg=0    cterm=NONE
hi NonText       ctermbg=NONE ctermfg=7    cterm=NONE
hi Comment       ctermbg=NONE ctermfg=8    cterm=italic
hi Constant      ctermbg=NONE ctermfg=1    cterm=NONE
hi Identifier    ctermbg=NONE ctermfg=10   cterm=NONE
hi Error         ctermbg=15   ctermfg=9    cterm=reverse
hi Ignore        ctermbg=NONE ctermfg=NONE cterm=NONE
hi PreProc       ctermbg=NONE ctermfg=4    cterm=NONE
hi Special       ctermbg=NONE ctermfg=3    cterm=NONE
hi Statement     ctermbg=NONE ctermfg=6    cterm=NONE
hi String        ctermbg=NONE ctermfg=3    cterm=NONE
hi Todo          ctermbg=NONE ctermfg=NONE cterm=reverse
hi Type          ctermbg=NONE ctermfg=2    cterm=NONE
hi Underlined    ctermbg=NONE ctermfg=NONE cterm=underline
hi StatusLine    ctermbg=0    ctermfg=15   cterm=NONE
hi StatusLineNC  ctermbg=8    ctermfg=15   cterm=NONE
hi VertSplit     ctermbg=8    ctermfg=8    cterm=NONE
hi TabLine       ctermbg=8    ctermfg=15   cterm=NONE
hi TabLineFill   ctermbg=8    ctermfg=8    cterm=NONE
hi TabLineSel    ctermbg=0    ctermfg=15   cterm=NONE
hi Title         ctermbg=NONE ctermfg=13   cterm=NONE
hi LineNr        ctermbg=NONE ctermfg=8    cterm=NONE
hi Cursor        ctermbg=10   ctermfg=0    cterm=NONE
hi CursorColumn  ctermbg=15   ctermfg=0    cterm=NONE
hi CursorLine    ctermbg=NONE ctermfg=NONE cterm=NONE
hi CursorLineNr  ctermbg=7    ctermfg=NONE cterm=NONE
hi helpLeadBlank ctermbg=NONE ctermfg=NONE cterm=NONE
hi helpNormal    ctermbg=NONE ctermfg=NONE cterm=NONE
hi Visual        ctermbg=14   ctermfg=0    cterm=NONE
hi VisualNOS     ctermbg=6    ctermfg=0    cterm=NONE
hi Pmenu         ctermbg=7    ctermfg=0    cterm=NONE
hi PmenuSbar     ctermbg=8    ctermfg=0    cterm=NONE
hi PmenuSel      ctermbg=8    ctermfg=15   cterm=NONE
hi PmenuThumb    ctermbg=0    ctermfg=0    cterm=NONE
hi FoldColumn    ctermbg=NONE ctermfg=8    cterm=NONE
hi Folded        ctermbg=6    ctermfg=15   cterm=NONE
hi WildMenu      ctermbg=11   ctermfg=0    cterm=NONE
hi SpecialKey    ctermbg=NONE ctermfg=7    cterm=NONE
hi DiffAdd       ctermbg=2    ctermfg=0    cterm=NONE
hi DiffChange    ctermbg=6    ctermfg=0    cterm=NONE
hi DiffDelete    ctermbg=1    ctermfg=0    cterm=NONE
hi DiffText      ctermbg=14   ctermfg=0    cterm=NONE
hi IncSearch     ctermbg=15   ctermfg=13   cterm=reverse
hi Search        ctermbg=11   ctermfg=0    cterm=NONE
hi Directory     ctermbg=NONE ctermfg=4    cterm=NONE
hi MatchParen    ctermbg=13   ctermfg=0    cterm=NONE
hi SpellBad      ctermbg=NONE ctermfg=9    cterm=NONE
hi SpellCap      ctermbg=NONE ctermfg=12   cterm=NONE
hi SpellLocal    ctermbg=NONE ctermfg=13   cterm=NONE
hi SpellRare     ctermbg=NONE ctermfg=14   cterm=NONE
hi ColorColumn   ctermbg=7    ctermfg=NONE cterm=NONE
hi SignColumn    ctermbg=NONE ctermfg=8    cterm=NONE
hi ErrorMsg      ctermbg=9    ctermfg=15   cterm=NONE
hi ModeMsg       ctermbg=NONE ctermfg=6    cterm=NONE
hi MoreMsg       ctermbg=12   ctermfg=15   cterm=NONE
hi Question      ctermbg=15   ctermfg=12   cterm=NONE
hi WarningMsg    ctermbg=13   ctermfg=15   cterm=NONE
