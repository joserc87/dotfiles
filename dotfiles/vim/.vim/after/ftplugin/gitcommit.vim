" Vim commit jira selector
" Language:	git commit file
" Maintainer:	Jose Ramon Cano <joserc87@gmail.com>
" Last Change:	2020 Apr 22

" Only do this when not done yet for this buffer
" if (exists("b:did_ftplugin"))
"   finish
" endif

inoremap <C-g> <ESC>:!gitmoji-menu<CR><ESC>"+pa<space>
nnoremap <C-g> :!gitmoji-menu<CR><ESC>"+P
nnoremap <CR> ddggP0xxW:silent !gitmoji-menu<CR>:redraw!<CR><ESC>"+Pa<space><ESC>l

" let b:did_ftplugin = 1
