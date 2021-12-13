" VIMTEST:
" -----
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
