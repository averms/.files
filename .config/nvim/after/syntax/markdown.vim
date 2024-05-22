" Improve compatibility with Pandoc syntax.

syntax region pandocMeta start=/\v%^---$/ end=/\v^---$/ keepend

syntax region pandocInlineMath matchgroup=markdownCodeDelimiter keepend
    \ start=/\v\$/ end=/\v\$/ skip=/\v\\\$/
syntax region pandocMathBlock matchgroup=markdownCodeDelimiter keepend
    \ start=/\v^\s*\zs\$\$/ end=/\v\$\$/ skip=/\v\\\$/

syntax region pandocPCite start=/\v\[-?\@/ end=/\v\]/ skip=/\v\\\]/
