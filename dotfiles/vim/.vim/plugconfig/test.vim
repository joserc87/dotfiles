" VIMTEST:
" -----
" autocmd FileType python nnoremap <Leader>t :call VimuxRunCommand("pytest")<CR>
" Unit testing
noremap <silent> t<C-n> :TestNearest<CR>
noremap <silent> t<C-f> :TestFile<CR>
noremap <silent> t<C-s> :TestSuite<CR>
noremap <silent> t<C-l> :TestLast<CR>
noremap <silent> t<C-g> :TestVisit<CR>
noremap <silent> <leader>t :TestLast<CR>
let test#python#runner = 'pytest'
let test#strategy = "neovim"
" let test#python#pytest#options = "--color=no --tb=short -q"
let g:test#preserve_screen = 1
