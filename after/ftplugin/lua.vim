if has('nvim') && get(g:, 'loaded_nvim_treesitter', 0)
  setlocal foldmethod=expr
  setlocal foldexpr=v:lua.tsfold(v:lnum)
endif
