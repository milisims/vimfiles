setlocal spell
setlocal expandtab
setlocal autoindent
setlocal textwidth=0
setlocal formatoptions=12crqno
setlocal comments=n:>
setlocal formatlistpat="^\s*\(\w\+[\]:.)}\t ]\s*\|\*\)\s*"
setlocal comments=b:*,b:-,b:1.,b:a.
setlocal wrap
setlocal conceallevel=0
setlocal breakindent
setlocal breakindentopt=min:50,shift:2
setlocal commentstring=<!--%s-->

let b:ncm2_look_enabled = 1
let b:autopairs_skip = ["'"]

imap <c-x><c-i> <plug>(citebib-complete)

imap <buffer> <c-x><c-i> <plug>(citebib-complete)

nnoremap <buffer><silent> <F11> :set ft=markdown<CR>
nnoremap <buffer><silent> <F12> :packadd vim-pandoc-syntax<CR>:setlocal filetype=pandoc<CR>:so $CFGDIR/after/ftplugin/markdown.vim<CR>
" vim: set ts=2 sw=2 tw=99 et :
