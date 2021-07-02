" GIT GUTTER:
" ----------
let g:gitgutter_map_keys = 0
nmap ) <Plug>(GitGutterNextHunk)
nmap ( <Plug>(GitGutterPrevHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
set foldtext=gitgutter#fold#foldtext()
highlight GitGutterAdd    gui=bold guifg=#009900 guibg=NONE ctermfg=2 ctermbg=NONE
highlight GitGutterChange gui=bold guifg=#bbbb00 guibg=NONE ctermfg=3 ctermbg=NONE
highlight GitGutterDelete gui=bold guifg=#ff2222 guibg=NONE ctermfg=1 ctermbg=NONE
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed = 'w'

