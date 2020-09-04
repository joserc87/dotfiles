let g:tmux_navigator_no_mappings = 1
"let g:tmux_navigator_disable_when_zoomed = 1

nnoremap <c-h> :TmuxNavigateLeft<cr>
nnoremap <c-j> :TmuxNavigateDown<cr>
nnoremap <c-k> :TmuxNavigateUp<cr>
nnoremap <c-l> :TmuxNavigateRight<cr>
" nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
" nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
" nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
" nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
" <c-\> is used by floaterm! We cannot use it here
" nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
