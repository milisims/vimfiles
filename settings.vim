" Settings: {{{1
set mouse=niv
set report=0
set hidden
set path=.,**
set virtualedit=block
set formatoptions=1crl
set nomodeline
if has('patch-7.3.541')
  set formatoptions+=j
endif
set updatetime=500
set winaltkeys=no
set pastetoggle=<F2>
set viewoptions=folds,cursor,slash,unix

set timeout ttimeout
set timeoutlen=750  " Time out on mappings
set ttimeoutlen=250 " for key codes
set shell=bash

call mkdir($DATADIR .. '/view', "p")
call mkdir($HOME .. '/.backup', "p")
call mkdir($DATADIR .. '/tmp/backup', "p")
call mkdir($DATADIR .. '/tmp/swap', "p")
call mkdir($DATADIR .. '/tmp/undo', "p")

if exists('$SUDO_USER')
  set nowritebackup
else
  set backupdir=$DATADIR/tmp/backup
  set backupdir+=~/.backup
  set backup
  set backupext=.bak
  set directory=$DATADIR/tmp/swap//  " // necessary
  set directory+=.
  if has('persistent_undo')
    set undodir=$DATADIR/tmp/undo
    set undodir+=.
    set undofile
  endif
endif
set fileformats=unix,dos,mac
set history=10000
set noswapfile
if has('nvim')
  if exists('$SUDO_USER') | set shada= | endif
  set shada='300,<10,@50,s100,h
else
  set viminfo='300,<10,@50,h,n$DATADIR/viminfo
endif

set textwidth=99
set softtabstop=2
set shiftwidth=2
set smarttab
set autoindent
set shiftround
set expandtab

set ignorecase
set smartcase
set infercase
set wildignorecase
set incsearch
set showmatch
set matchtime=3

set nowrap
set linebreak
set breakat=\ \	;:,!?
set nostartofline
set whichwrap+=[,]

set spellsuggest=best,10

" Save when exiting a buffer/window. Saving on idle is a bit too aggressive for me.
set autowriteall
augroup vimrc_writeall
  autocmd!
  autocmd WinLeave,FocusLost * ++nested if &modifiable && filereadable(expand('%')) | update | endif
augroup END

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " let g:ctrlp_use_caching = 0
endif

set splitright
set switchbuf=useopen
set backspace=indent,eol,start
set diffopt=algorithm:histogram,filler
set showfulltag
set completeopt=menuone
if has('patch-7.4.784')
  set completeopt+=noselect
  set completeopt+=noinsert
endif
if exists('+inccommand')
  set inccommand=nosplit
endif

set shortmess=aAoOTI
set scrolloff=4
set sidescrolloff=2
set number
set relativenumber
set lazyredraw
set showtabline=2
set pumheight=20
set cmdheight=2
set cmdwinheight=5
set laststatus=2
set colorcolumn=80
set cursorline
set signcolumn=yes

set list
set listchars=nbsp:⊗
set listchars+=tab:▷‒
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=trail:•
set showbreak=↘
set fillchars=vert:┃
set nojoinspaces
set wildmenu wildmode=longest:full,full

if has('termguicolors')
  set termguicolors
  if !has('nvim')
    let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
    let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  endif
endif

" Lush colorscheming
if !has('nvim')
  colorscheme evolution
endif

if has('patch-7.4.1570')
  set shortmess+=c
  set shortmess+=F
endif

if has('conceal') && v:version >= 703
  set conceallevel=2
endif

if has('folding')
  set foldmethod=syntax
  set foldlevelstart=99
  set foldnestmax=3
endif
set foldtext=fold#text()

" Autocommands: {{{1

augroup vimrc_general
  autocmd!
  au BufWinLeave * if empty(&buftype) && &modifiable && !empty(expand('%')) | mkview | endif
  au BufWinEnter * if empty(&buftype) && &modifiable && !empty(expand('%')) | silent! loadview | endif

  autocmd WinEnter,FocusGained * checktime

  " Update filetype on save if empty
  autocmd BufWritePost * ++nested if empty(&filetype) | unlet! b:ftdetect | filetype detect | endif

  " When editing a file, always jump to the last known cursor position, if valid.
  autocmd BufReadPost *
        \ if &ft !~ '^git\c' && ! &diff && line("'\"") > 0 && line("'\"") <= line("$")
        \|   execute 'normal! g`"zvzz'
        \| endif

  " Disable paste and/or update diff when leaving insert mode
  autocmd InsertLeave * if &paste | setlocal nopaste | echo 'nopaste' | endif
  autocmd InsertLeave * if &diff | diffupdate | endif

  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")

augroup END

augroup vimrc_numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

augroup vimrc_filetype
  autocmd!
  autocmd FileType qfreplace setlocal nofoldenable
  autocmd FileType sh let g:is_bash=1
  autocmd FileType sh let g:sh_fold_enabled=5
  autocmd BufRead * if empty(&filetype) | set commentstring=#%s | endif
augroup END

" Mappings: {{{1
let g:mapleader='\'
" let g:maplocalleader="\\"

nnoremap <Space> :
xnoremap <Space> :
cnoremap <expr> <space> (getcmdtype()==":" && empty(getcmdline())) ? 'lua ' : '<C-]> '
nnoremap ! :!

if !has('nvim')
  " C-space in kitty with my settings
  nnoremap [32;5u <Space>
  inoremap [32;5u <Space>
endif

inoremap <C-c> <Esc>
inoremap <Esc> <C-c>
snoremap <C-c> <Esc>
snoremap <Esc> <C-c>
inoremap jk <Esc>
snoremap jk <Esc>
nnoremap Y y$

augroup vimrc_crmap
  autocmd!
  " Not sure why quickfix lists are modifiable.
  autocmd BufEnter * if &modifiable | nnoremap <buffer> <Cr> za| endif
augroup END

nnoremap zE zMzO
nnoremap zO zCzO
nnoremap zV zMzv

if !exists('g:loaded_tmux_navigator')
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
endif

nnoremap <expr> 0 getline('.')[: col('.') - 2] =~ '^\s*$' ? '0' : '0^'
xnoremap <expr> 0 getline('.')[: col('.') - 2] =~ '^\s*$' ? '0' : '0^'
onoremap <expr> 0 getline('.')[: col('.') - 2] =~ '^\s*$' ? '0' : '^'

nnoremap <expr> $ (v:count > 0 ? 'j$' : '$')
xnoremap <expr> $ (v:count > 0 ? 'j$h' : '$h')
onoremap <expr> $ (v:count > 0 ? 'j$' : '$')

inoremap <C-f> <C-g>U<Right>
inoremap <C-b> <C-g>U<Left>

inoremap <C-w> <C-g>u<C-w><C-g>u
inoremap <C-u> <C-g>u<C-u><C-g>u
inoremap <M-u> <C-k>*

nnoremap <expr> j (v:count > 4 ? "m'" . v:count . 'j' : 'gj')
xnoremap <expr> j (v:count > 4 ? "m'" . v:count . 'j' : 'gj')
nnoremap <expr> k (v:count > 4 ? "m'" . v:count . 'k' : 'gk')
xnoremap <expr> k (v:count > 4 ? "m'" . v:count . 'k' : 'gk')
nnoremap gj j
xnoremap gj j
nnoremap gk k
xnoremap gk k

nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

nnoremap <silent><C-w>z :vert resize | resize | normal! ze<CR>

nnoremap [a :<C-u>execute v:count1 . 'previous'<CR>
nnoremap ]a :<C-u>execute v:count1 . 'next'<CR>
nnoremap [b :<C-u>execute v:count1 . 'bprevious'<CR>
nnoremap ]b :<C-u>execute v:count1 . 'bnext'<CR>
nnoremap [l :<C-u>execute v:count1 . 'lprevious'<CR>
nnoremap ]l :<C-u>execute v:count1 . 'lnext'<CR>
nnoremap [q :<C-u>execute v:count1 . 'cprevious'<CR>
nnoremap ]q :<C-u>execute v:count1 . 'cnext'<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>
nnoremap [<Space> :<C-u>silent! put!=repeat(nr2char(10), v:count1)\|']+1\|call repeat#set("[ ")<CR>
nnoremap ]<Space> :<C-u>silent! put =repeat(nr2char(10), v:count1)\|'[-1\|call repeat#set("] ")<CR>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-x> <C-a>

inoreabbrev -> ➜

nnoremap c* :<C-u>let @/ = '\<'.expand('<cword>').'\>'<Cr>cgn
nnoremap c. /\V<C-r>=escape(@", '\')<Cr><Cr>cgn<C-a><Esc>
nnoremap d. /\V<C-r>=escape(@", '\')<Cr><Cr>dgn

nnoremap <expr> >> "\<Esc>" . repeat('>>', v:count1)
nnoremap <expr> << "\<Esc>" . repeat('<<', v:count1)
xnoremap < <gv
xnoremap > >gv

xnoremap <M-j> :move '>+1<CR>gv=gv
xnoremap <M-k> :move '<-2<CR>gv=gv
nnoremap <M-j> :move .+1<CR>==
nnoremap <M-k> :move .-2<CR>==
inoremap <M-j> <C-c>:move .+1<CR>==gi
inoremap <M-k> <C-c>:move .-2<CR>==gi

nnoremap <expr> ~ getline('.')[col('.') - 1] =~# '\a' ? '~' : 'w~'
nnoremap cp yap}p
nnoremap g<Cr> i<Cr><Esc>l

nnoremap <expr> <silent> g<Space> :<C-u>autocmd TextChangedI <buffer> ++once stopinsert<Cr>i

" nnoremap <silent> <C-]> g<C-]>
" " TODO: Generalized split function that simply splits vertical or horizontal depending on how those
" " are already split. Vert first, then horizontal.
" nnoremap <silent> g] :vert stjump<CR>
" nnoremap <silent> g<C-]> :stjump<CR>

nnoremap \p "0p
nnoremap \P "0P
xnoremap \p "0p
xnoremap \P "0P

xnoremap \y "*y
xnoremap \Y "+y

" Select last edited text. improved over `[v`], eg works with visual block
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'
onoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

nnoremap <F9> :<C-u>call SynStack()<CR>
function! SynStack()
  let group = synIDattr(synID(line('.'), col('.'), 1), 'name')
  let glist = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  " let hlgroup = synIDattr(synIDtrans(hlID(group)), 'name')
  let hlgroup = '	Highlighting: ' . synIDattr(synID(line("."), col("."), 1), "name") . ' ➤ '
        \ . synIDattr(synID(line("."), col("."), 0), "name") . ' ➤ '
        \ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
  echo group glist hlgroup
endfunc


" Internal plugins: {{{1
" I want these to load even if --noplugins is used.
" nnoremap <silent> <Space>do :call difference#orig()<cr>

onoremap <silent>ai :<C-u>call textobjects#indent(0)<CR>
onoremap <silent>ii :<C-u>call textobjects#indent(1)<CR>
xnoremap <silent>ai <Esc>:call textobjects#indent(0)<CR><Esc>gv
xnoremap <silent>ii <Esc>:call textobjects#indent(1)<CR><Esc>gv

if has('nvim')
  nnoremap <silent> <C-Up>    :<C-u>call winresize#go(1, v:count1)<CR>
  nnoremap <silent> <C-Down>  :<C-u>call winresize#go(1, -v:count1)<CR>
  nnoremap <silent> <C-Left>  :<C-u>call winresize#go(0, v:count1)<CR>
  nnoremap <silent> <C-Right> :<C-u>call winresize#go(0, -v:count1)<CR>
else
  nnoremap <silent> <Esc>[1;5A :<C-u>call winresize#go(1, v:count1)<CR>
  nnoremap <silent> <Esc>[1;5B :<C-u>call winresize#go(1, -v:count1)<CR>
  nnoremap <silent> <Esc>[1;5D :<C-u>call winresize#go(0, v:count1)<CR>
  nnoremap <silent> <Esc>[1;5C :<C-u>call winresize#go(0, -v:count1)<CR>
endif


nnoremap ]p <silent> :<C-u>call yankring#cycle(v:count1)<CR>
nnoremap [p <silent> :<C-u>call yankring#cycle(-v:count1)<CR>

" nnoremap <silent> <Space>R :<C-u>set opfunc=refactor#expression_to_variable<CR>g@
xnoremap <silent> R         :<C-u>call refactor#expression_to_variable(visualmode(), 1)<CR>
nnoremap <silent> gR        :<C-u>set opfunc=refactor#name_in_project<CR>g@
xnoremap <silent> gR        :<C-u>call refactor#name_in_project(visualmode(), 1)<CR>

nnoremap <silent> <F2> :call util#openf(expand("<cfile>"))<CR>
xnoremap <silent> <F2> :<C-u>call util#openf(util#get_visual_selection())<CR>

nnoremap ]z zj:call fold#goto_open(1)<Cr>
nnoremap [z zk:call fold#goto_open(-1)<Cr>

" Not plugins but fits in with the text objects above
xnoremap il ^og_
xnoremap al 0o$
onoremap il :<C-u>normal! ^vg_<CR>
onoremap al :<C-u>normal! 0v$<CR>
onoremap ar a]
onoremap ir i]

nnoremap ]s m`]s
nnoremap [s m`[s

" Commands: {{{1
command! -complete=filetype -bang -nargs=? EditFtplugin execute 'edit $CFGDIR/after/ftplugin/'
      \ . (empty(expand('<args>')) ? &filetype : expand('<args>')) . (empty("<bang>") ? '.vim' : '.lua')
command! Clearqflist call setqflist([])
command! -nargs=? -complete=buffer Clearloclist call setloclist(empty(<q-args>) ? 0 : bufnr(<q-args>), [])

" Plugins {{{1
if !has('packages') || exists('$SUDO_USER')
  finish
endif

set packpath+=$CFGDIR

" if has('nvim') && !empty($CONDA_PREFIX_1)
"   let g:python3_host_prog = $CONDA_PREFIX_1 . '/envs/nvim-base/bin/python'
"   if !filereadable(g:python3_host_prog)
"     echohl Error
"     echo "conda env 'nvim-base' not found"
"     echohl None
"   endif
" endif

command! PackUpdate call pack#update()
command! PackClean  call pack#clean()
command! PackStatus call pack#status()
command! PackList JumpSplitOrEdit $CFGDIR/autoload/pack.vim
command! -nargs=1 -complete=custom,pack#list PackEdit packadd minpac | execute 'Telescope fd cwd='..minpac#getpluginfo(<q-args>).dir
command! -nargs=1 -complete=custom,pack#list PackOpen pack#open(<q-args>)

" function! s:move(name) abort
"   execute 'write' a:name
" endfunction

" command! -nargs=1 -complete=file Move write <q-args>|buf #

" vim-sneak {{{2
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

let g:sneak#label = 1
let g:sneak#absolute_dir = 1
let g:sneak#use_ic_scs = 1

" vim-tmux-navigator {{{2
let g:tmux_navigator_disable_when_zoomed = 1

" targets {{{2
let g:targets_aiAI = 'aIAi'

" vim-filebeagle {{{2
let g:filebeagle_suppress_keymaps = 1
nmap <silent> \- <Plug>FileBeagleOpenCurrentBufferDir
let g:loaded_netrwPlugin = 'v9999'

" vim-matchup {{{2
let g:matchup_matchparen_offscreen = {}

" vim-commentary {{{2
xmap gc  <Plug>Commentary
nmap gc  <Plug>Commentary
omap gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap cgc <Plug>ChangeCommentary
nmap gcu <Plug>Commentary<Plug>Commentary

" vim-cursorword
let g:cursorword_delay = 250

" undotree {{{2
nnoremap <F6> :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 0
let undotree_HighlightChangedText = 0

" }}}
if has('nvim')
  " vim-gutentags {{{2
  let g:gutentags_cache_dir = $DATADIR.'/tags'
  let g:gutentags_ctags_exclude = ['data']

  " vim-signify {{{2
  augroup vimrc_signify
    autocmd!
    autocmd ColorScheme * highlight link SignifyLineAdd             String
    autocmd ColorScheme * highlight link SignifyLineChange          Todo
    autocmd ColorScheme * highlight link SignifyLineDelete          Error
    autocmd ColorScheme * highlight link SignifyLineChangeDelete    SignifyLineChange
    autocmd ColorScheme * highlight link SignifyLineDeleteFirstLine SignifyLineDelete

    autocmd ColorScheme * highlight link SignifySignAdd             String
    autocmd ColorScheme * highlight link SignifySignChange          Todo
    autocmd ColorScheme * highlight link SignifySignDelete          Error
    autocmd ColorScheme * highlight link SignifySignChangeDelete    SignifyLineChange
    autocmd ColorScheme * highlight link SignifySignDeleteFirstLine SignifyLineDelete
  augroup END
  let g:signify_vcs_list = ['git']
  let g:signify_sign_delete = '-'
  let g:signify_sign_change = '~'
  let g:signify_skip_filetype = { 'markdown': 1 }
  let g:signify_disable_by_default = 1

endif

" Windows {{{2
if has('win32')
  function! s:setup_guifont() abort
    Guifont! DejaVu Sans Mono:h9
  endfunction
  call defer#onidle('call s:setup_guifont()')
endif
