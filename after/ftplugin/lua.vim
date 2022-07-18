if has('nvim') && get(g:, 'loaded_nvim_treesitter', 0)
  setlocal foldmethod=expr
  setlocal foldexpr=v:lua.mia.foldexpr(v:lnum)
endif

setlocal formatprg=stylua\ -

nnoremap <silent> <expr> <buffer> K ':help ' . expand('<cword>') . ((expand('<cWORD>') =~# expand('<cword>') . '(') ? "(\<Cr>" : "\<Cr>")
setlocal tagfunc=v:lua.vim.lsp.tagfunc

if expand('%') =~? '_spec.lua$'
  nmap <buffer> \t <Plug>PlenaryTestFile
endif

nnoremap <buffer> <Bs> <cmd>call testing#prompt()<Cr>

for i in range(97, 122)  " a-z, make <C-v><C-a> insert <C-a>.
  execute 'inoremap <buffer> <C-v><C-' . nr2char(i) . '> <lt>C-' . nr2char(i) . '>'
endfor
inoremap <buffer> <C-v><Esc> <lt>Esc>
inoremap <buffer> <C-v><Tab> <lt>Tab>
inoremap <buffer> <C-v><Cr> <lt>Cr>

" why is this here?
augroup vimrc_lua
  autocmd!
  if has('nvim')
    autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync()
  endif
augroup END

let b:refactor_prefix = 'local'
