setlocal colorcolumn=100
" setlocal spell
let b:cursorword = 0
setlocal foldminlines=0
setlocal concealcursor=n
setlocal foldnestmax=20

setlocal formatoptions+=tno

" setlocal formatlistpat=^\\v\\s*%(\\a\|\\d+)[.)]\\ze%($\|\\s+\\S)
setlocal formatlistpat=^\\v\\s*
setlocal formatlistpat+=%(
setlocal formatlistpat+=[-+*]
setlocal formatlistpat+=%(\ \\[[\ x]\\])?
setlocal formatlistpat+=\\\\|
setlocal formatlistpat+=\\d\\+[.)]
setlocal formatlistpat+=\\a[.)]
setlocal formatlistpat+=)\\s\\+

" setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal comments=b:-\ [\ ],b:+\ [\ ],b:-,b:#,b:+

setlocal commentstring=#\ %s

setlocal textwidth=99

nmap <buffer> gO <Plug>(org-headline-open-above)Headline<Esc>[ viw<C-g>
nmap <buffer> go <Plug>(org-headline-open-below)Headline<Esc>[ viw<C-g>

nmap <buffer> \gO <Plug>(org-headline-open-above)TODO Headline<Esc>[ viw<C-g>
nmap <buffer> \go <Plug>(org-headline-open-below)TODO Headline<Esc>[ viw<C-g>

nnoremap <buffer> gJ vipJgwip
nnoremap <buffer> gK vipJ:let store_reg = @/ \| .s/[.!?]\zs\s\+\ze\u/\r/geI \| let @/ = store_reg \| unl store_reg<CR>
" ContextAdd <buffer> indrawer {-> org#property#isindrawer('.')}
" Contextualize indrawer inoremap <buffer> ; property<C-r>=UltiSnips#Anon(":${1:prop}: ${0:val}", "property")<Cr>

" nnoremap <buffer> \d :call org#keyword#set(org#outline#keywords().done[-1])<Cr>

" ContextAdd <buffer> startoflist {-> getline('.') =~ '\v^\s*' . g:org#regex#list#bullet . '\s*$'}
" Contextualize startoflist inoremap <buffer> <expr> [ '[ ] '
" Contextualize default imap <buffer> <expr> [ g:contextualize.i.map['['].do()

" ContextAdd <buffer> linkend {-> getline('.')[: col('.') - 2] =~ '\[\[[^\[\]]*\]\[[^\[\]]*\]\]$'}
" ContextAdd <buffer> inlink {-> getline('.')[col("'>") : col("'>")+1] == ']]'}
" Contextualize inlink snoremap <buffer> <Tab> <Esc>2f]a
" Contextualize linkend inoremap <buffer> <Tab> <Esc>hhvi]<C-g>
" Contextualize default imap <buffer> <expr> <Tab> g:contextualize.i.map['<lt>tab>'].do()

" ContextAdd <buffer> checkboxlist {-> getline('.')[: col('.') - 2] =~ '\v^\s*' . g:org#regex#list#bullet . '\s*\[[- xX]\]\s*$'}
" Contextualize checkboxlist inoremap <buffer> <Bs> <Bs><Bs><Bs><Bs>
" Contextualize default imap <buffer> <expr> <Bs> g:contextualize.i.map['<lt>bs>'].do()

" Contextualize inSyntax orgLink nmap <buffer> K <Plug>(org-follow-link)
" " xnoremap <silent> <buffer> K :<C-u>call notebox#setupLink('', 'v')<Cr>

" " TODO make it easier to say (in checked box?) -- easy with tree-sitter
" ContextAdd <buffer> checkbox   {-> getline('.')[col('.') - 2 : col('.')] =~? '\[.]'}
" Contextualize checkbox nmap <buffer> x <Plug>(org-check-toggle)
" ContextAdd <buffer> listitem {-> org#listitem#checkline('.')}
" Contextualize listitem nnoremap <buffer> - m`^Wi+<C-o>$+<Esc>``l
