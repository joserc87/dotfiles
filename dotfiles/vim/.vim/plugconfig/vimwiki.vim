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
let g:vimwiki_list = [wiki_1]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
nmap <A-PageUp> <Plug>(VimwikiDiaryPrevDay)
nmap <A-PageDown> <Plug>(VimwikiDiaryNextDay)
au BufNewFile ~/vimwiki/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template '%'
