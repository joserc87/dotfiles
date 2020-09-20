
" MARKDOWN:
" Set any *.md file to Markdown by default
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
" To enable fenced code block syntax highlighting
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
" ysiwi will make word italic (*italic*):
" ysiwb will make word bold (**word**):
autocmd FileType markdown,octopress let b:surround_{char2nr('i')} = "*\r*"
autocmd FileType markdown,octopress let b:surround_{char2nr('b')} = "**\r**"

" EmbeddedJavaScript:
autocmd BufNewFile,BufRead *.ejs set filetype=html

" ANTLR:
au BufRead,BufNewFile *.g set syntax=antlr3
au BufRead,BufNewFile *.g4 set syntax=antlr

" HTML:
autocmd FileType html setlocal softtabstop=4 shiftwidth=4 tabstop=4 noexpandtab
" JS:
autocmd FileType javascript setlocal softtabstop=2 shiftwidth=2 tabstop=2 expandtab
set foldmethod=syntax
set foldcolumn=1
let javaScript_fold=1
set foldlevelstart=99

" SPELL:
au BufRead,BufNewFile *.spl set syntax=spell

" XML:
autocmd FileType xml set formatexpr=xmlformat#Format()

" PYTHON:
set foldmethod=syntax
autocmd FileType python set foldmethod=indent

