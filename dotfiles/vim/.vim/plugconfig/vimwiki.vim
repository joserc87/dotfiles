" VIMWIKI:
let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'
let wiki_1.nested_syntaxes = {
            \'python': 'python',
            \'c++': 'cpp',
            \'js': 'javascript',
            \'json': 'json',
            \'sh': 'shell',
            \}
let wiki_1.template_path = '~/vimwiki/templates/'
let wiki_1.template_default = 'default'
let wiki_1.path_html = '~/vimwiki/site_html/'
" let wiki_1.custom_wiki2html = 'vimwiki_markdown'
" let wiki_1.custom_wiki2html = $HOME.'/.vim/plugged/vimwiki/autoload/vimwiki/customwiki2html.sh'
let wiki_1.custom_wiki2html = $HOME.'/.vim/plugged/vimwiki/autoload/vimwiki/wiki2html_w_pandoc.sh'
let wiki_1.template_ext = '.tpl'
let wiki_2 = {
    \ 'path': '~/vimwiki/vim/',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ 'nested_syntaxes': {
        \ 'python': 'python',
        \ 'c++': 'cpp',
        \ 'js': 'javascript',
        \ 'json': 'json',
        \ 'sh': 'shell',
    \ }
\ }
let g:vimwiki_list = [wiki_1, wiki_2]
" let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
au BufNewFile ~/vimwiki/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template '%'
" nmap <M-PageUp> <Plug>(VimwikiDiaryPrevDay)
" nmap <M-PageDown> <Plug>(VimwikiDiaryNextDay)
au BufRead,BufNewFile ~/vimwiki/diary/*.md nnoremap <buffer> <M-k> :VimwikiDiaryPrevDa<CR>
au BufRead,BufNewFile ~/vimwiki/diary/*.md nnoremap <buffer> <M-j> :VimwikiDiaryNextDay<CR>
" nnoremap <leader>wo :split<CR>:call vimwiki#diary#make_note(0)<CR>
au BufRead,BufNewFile ~/git/entitytool/* nnoremap <buffer> <leader>wo :e ~/vimwiki/projects/entitytool.md<CR>
au BufWritePost ~/vimwiki/projects/* Vimwiki2HTML
" au BufRead,BufNewFile ~/vimwiki/diary/*.md nnoremap <buffer> <leader>w<leader>w :bd<CR>
au BufRead,BufNewFile ~/vimwiki/*.md nnoremap <buffer> <leader>wo :bd<CR>
au BufRead,BufNewFile ~/vimwiki/*.md nnoremap <buffer> <leader>j :execute '/' . '\[ \]'<CR>
au BufRead,BufNewFile ~/vimwiki/*.md nnoremap <buffer> <leader>k :execute '?' . '\[ \]'<CR>
