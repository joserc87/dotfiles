" VIMTEST:
" -----
" autocmd FileType python nnoremap <Leader>t :call VimuxRunCommand("pytest")<CR>
" Unit testing
noremap <silent> <leader>tn :TestNearest -vv<CR>
    noremap <silent> <leader>tN :TestNearest -strategy=floaterm -vv<CR>
noremap <silent> <leader>tf :TestFile -vv<CR>
noremap <silent> <leader>ts :TestSuite -vv<CR>
noremap <silent> <leader>tl :TestLast -vv<CR>
noremap <silent> <leader>tg :TestVisit -vv<CR>
noremap <silent> <leader>tt :TestLast -vv<CR>
let test#python#runner = 'pytest'
" let test#strategy = "neovim"
let test#strategy = "dispatch"
" let test#python#pytest#options = "--color=no --tb=short -q"
let g:test#preserve_screen = 1
" let test#custom_runners = {'Python': ['Py_Test']}

let g:dispatch_compilers = {}
let g:dispatch_compilers['./vendor/bin/'] = ''
let g:dispatch_compilers['pyunit'] = 'pytest'

autocmd FileType python let b:dispatch = 'pytest%'
