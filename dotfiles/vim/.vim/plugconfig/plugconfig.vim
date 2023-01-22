" TMUX Navigator
" --------------
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

" EASY ALIGN:
" ----------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" FUGITIVE:
" --------
" Autodelete fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" Gitlab
let g:fugitive_gitlab_domains = ['https://gitlab.ravenpack.com']

" CHADTREE:
" ---------
nnoremap <leader>nn <cmd>CHADopen<cr>
nnoremap <leader>ne <cmd>CHADopen<cr>

" DASHBOARD:
" ----------
" Default value is clap
let g:dashboard_default_executive ='fzf'
"let g:dashboard_preview_command = 'cat'
"let g:dashboard_preview_pipeline = 'lolcat'
"let g:dashboard_preview_file = '/home/jcano/code/config-files/dotfiles/vim/.vim/plugconfig/neovim.logo'
"let g:dashboard_preview_file_height = 12
"let g:dashboard_preview_file_width = 80

" VIM DADBOD:
" -----------
nnoremap <leader>nd :DBUI<CR>

" FZF:
" ----
let g:fzf_preview_window = ['right:60%', 'ctrl-/']
