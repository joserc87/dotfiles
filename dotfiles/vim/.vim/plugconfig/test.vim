" VIMTEST:
" -----
" autocmd FileType python nnoremap <Leader>t :call VimuxRunCommand("pytest")<CR>
" Unit testing
noremap <silent> <leader>tn :TestNearest<CR>
noremap <silent> <leader>tN :TestNearest -strategy=floaterm -vv<CR>
noremap <silent> <leader>tm :TestNearest -strategy=shtuff -vv<CR>
noremap <silent> <leader>td :TestNearest -strategy=vimspectorpy -vv<CR>
noremap <silent> <leader>tf :TestFile<CR>
noremap <silent> <leader>tF :TestFile -strategy=shtuff -vv<CR>
noremap <silent> <leader>ts :TestSuite -vv -m \"not slow and not skip and not knownfail and not require_cache\" core/tests/unit_tests<CR>
noremap <silent> <leader>tS :TestSuite -strategy=shtuff -vv -m \"not slow and not skip and not knownfail and not require_cache\" core/tests/<CR>
noremap <silent> <leader>tl :TestLast -vv<CR>
noremap <silent> <leader>tg :TestVisit -vv<CR>
noremap <silent> <leader>tt :TestLast<CR>
noremap <silent> <leader>tT :TestLast -strategy=shtuff -vv<CR>
let test#python#runner = 'pytest'
let test#python#options = {
  \ 'suite': '-m "not slow and not skip and not knownfail and not require_cache"',
\}
" let test#strategy = "neovim"
let test#strategy = "dispatch"
" let test#python#pytest#options = "--color=no --tb=short -q"
let g:test#preserve_screen = 1
" let test#custom_runners = {'Python': ['Py_Test']}

let g:dispatch_compilers = {}
let g:dispatch_compilers['./vendor/bin/'] = ''
let g:dispatch_compilers['pyunit'] = 'pytest'
let g:shtuff_receiver = 'testrunner'

autocmd FileType python let b:dispatch = 'pytest%'


let g:vimspectorpy#launcher = "tmux"
