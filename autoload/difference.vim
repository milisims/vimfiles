function! difference#orig() abort
  let l:filetype = &filetype
  vert new
  set buftype=nofile
  setlocal modifiable
  read ++edit # | 0d_
  let &filetype = l:filetype
  setlocal nomodifiable
  nnoremap <buffer> q :diffoff!<CR>:bd<CR>
  diffthis
  set noscrollbind
  wincmd p
  diffthis
  set foldlevel=1
endfunction

function! difference#undobuf() abort
  let l:filetype = &filetype
  " let l:undofile = fnameescape(undofile(expand('%:p')))
  let l:undofile = undofile(expand('%:p'))
  if !filewritable(l:undofile)
    echom 'Unable to write to undofile: ' . l:undofile
    return
  endif
  write | execute 'wundo ' . fnameescape(l:undofile)
  let l:text = getline(1, '$')
  diffoff! | diffthis
  vert new
  set buftype=nofile
  setlocal modifiable
  silent put =l:text | 0d_
  let &filetype = l:filetype
  nnoremap <buffer> q :diffoff!<CR>:bd<CR>
  nnoremap <silent> <buffer> u :set ma<CR>u:dif<CR>:set noma<CR>
  nnoremap <silent> <buffer> <C-r> :set ma<CR><C-r>:dif<CR>:set noma<CR>
  execute 'rundo ' . fnameescape(l:undofile)
  setlocal nomodifiable
  set foldlevel=1
  diffthis
  set foldlevel=1
endfunction

function! s:diff_and_set_bindings() abort
  nmap <buffer> [q <Plug>unimpairedQPrevious:call <SID>diff_and_set_bindings()<CR>
  nmap <buffer> ]q <Plug>unimpairedQNext:call <SID>diff_and_set_bindings()<CR>
  nnoremap <buffer> q :diffoff!<CR>:bd<CR>
  diffthis
endfunction

function! difference#gitlog() abort
  " Not working
  if !exists('g:loaded_fugitive')
    echom 'Fugitive not loaded.'
    return
  endif
  diffoff! | diffthis
  vsplit
  silent Gdiff
  call s:diff_and_set_bindings()
  wincmd p
endfunction

" TODO: doesn't really work yet. Also fix yapfify
function! difference#format(type) abort
  let [l:lnum_start, l:col_start] = getpos("'[")[1:2]
  let [l:lnum_end, l:col_end] = getpos("']")[1:2]
  let l:filetype = &filetype
  let l:text = getline(1, '$')
  diffoff! | diffthis
  vert new
  set buftype=nofile
  setlocal modifiable
  silent put =l:text | 0d_
  setlocal nomodifiable
  let &filetype = l:filetype
  nnoremap <buffer> q :diffoff!<CR>:bd<CR>
  normal gggqG
  set foldlevel=1
  diffthis
  set foldlevel=1
endfunction
