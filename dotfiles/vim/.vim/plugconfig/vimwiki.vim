" VIMWIKI:
let wiki_root = {}
let wiki_root.path = '~/vimwiki/'
let wiki_root.syntax = 'markdown'
let wiki_root.ext = '.md'
let wiki_root.nested_syntaxes = {
            \'python': 'python',
            \'sql': 'sql',
            \'c++': 'cpp',
            \'js': 'javascript',
            \'json': 'json',
            \'sh': 'shell',
            \}
let wiki_root.template_path = '~/vimwiki/templates/'
let wiki_root.template_default = 'default'
let wiki_root.path_html = '~/vimwiki/site_html/'
" let wiki_root.custom_wiki2html = 'vimwiki_markdown'
" let wiki_root.custom_wiki2html = $HOME.'/.vim/plugged/vimwiki/autoload/vimwiki/customwiki2html.sh'
let wiki_root.custom_wiki2html = $HOME.'/.vim/plugged/vimwiki/autoload/vimwiki/wiki2html_w_pandoc.sh'
let wiki_root.template_ext = '.tpl'

let wiki_et = deepcopy(wiki_root)
let wiki_et.path = '~/vimwiki/projects/et/'
let wiki_et.path_html = '~/vimwiki/site_html/projects/et/'

let wiki_rpe = deepcopy(wiki_root)
let wiki_rpe.path = '~/vimwiki/projects/rpe/'
let wiki_rpe.path_html = '~/vimwiki/site_html/projects/et/'

let wiki_ta = deepcopy(wiki_root)
let wiki_ta.path = '~/vimwiki/projects/ta/'
let wiki_ta.path_html = '~/vimwiki/site_html/projects/et/'

let wiki_devops = deepcopy(wiki_root)
let wiki_devops.path = '~/vimwiki/ravenpack/devops/'
let wiki_devops.path_html = '~/vimwiki/site_html/ravenpack/devops/'

let wiki_rice = deepcopy(wiki_root)
let wiki_rice.path = '~/vimwiki/rice/'
let wiki_rice.path_html = '~/vimwiki/site_html/rice/'

let wiki_vim = deepcopy(wiki_root)
let wiki_vim.path = '~/vimwiki/tech/vim/'
let wiki_vim.path_html = '~/vimwiki/site_html/tech/vim/'

let wiki_git = deepcopy(wiki_root)
let wiki_git.path = '~/vimwiki/tech/git/'
let wiki_git.path_html = '~/vimwiki/site_html/tech/git/'

let wiki_docker = deepcopy(wiki_root)
let wiki_docker.path = '~/vimwiki/tech/docker/'
let wiki_docker.path_html = '~/vimwiki/site_html/tech/docker/'

let wiki_cloudwatch = deepcopy(wiki_root)
let wiki_cloudwatch.path = '~/vimwiki/tech/cloudwatch/'
let wiki_cloudwatch.path_html = '~/vimwiki/site_html/tech/cloudwatch/'

let wiki_tmux = deepcopy(wiki_root)
let wiki_tmux.path = '~/vimwiki/tech/tmux/'
let wiki_tmux.path_html = '~/vimwiki/site_html/tech/tmux/'

let wiki_sql = deepcopy(wiki_root)
let wiki_sql.path = '~/vimwiki/tech/sql/'
let wiki_sql.path_html = '~/vimwiki/site_html/tech/sql/'

let wiki_taskwarrior = deepcopy(wiki_root)
let wiki_taskwarrior.path = '~/vimwiki/tech/taskwarrior/'
let wiki_taskwarrior.path_html = '~/vimwiki/site_html/tech/taskwarrior/'

let g:vimwiki_list = [
    \ wiki_root,
    \ wiki_et,
    \ wiki_rpe,
    \ wiki_ta,
    \ wiki_devops,
    \ wiki_rice,
    \ wiki_vim,
    \ wiki_git,
    \ wiki_docker,
    \ wiki_cloudwatch,
    \ wiki_tmux,
    \ wiki_sql,
    \ wiki_taskwarrior
    \]
" let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
au BufNewFile ~/vimwiki/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template '%'
" nmap <M-PageUp> <Plug>(VimwikiDiaryPrevDay)
" nmap <M-PageDown> <Plug>(VimwikiDiaryNextDay)
au BufRead,BufNewFile ~/vimwiki/diary/*.md nnoremap <buffer> <M-k> :VimwikiDiaryPrevDa<CR>
au BufRead,BufNewFile ~/vimwiki/diary/*.md nnoremap <buffer> <M-j> :VimwikiDiaryNextDay<CR>
" nnoremap <leader>wo :split<CR>:call vimwiki#diary#make_note(0)<CR>
au BufRead,BufNewFile ~/git/entitytool/* nnoremap <buffer> <leader>wo :e ~/vimwiki/projects/entitytool/index.md<CR>
au BufWritePost ~/vimwiki/* Vimwiki2HTML
" au BufRead,BufNewFile ~/vimwiki/diary/*.md nnoremap <buffer> <leader>w<leader>w :bd<CR>
au BufRead,BufNewFile ~/vimwiki/*.md nnoremap <buffer> <leader>wo :bd<CR>
au BufRead,BufNewFile ~/vimwiki/*.md nnoremap <buffer> <leader>j :execute '/' . '\[ \]'<CR>
au BufRead,BufNewFile ~/vimwiki/*.md nnoremap <buffer> <leader>k :execute '?' . '\[ \]'<CR>
au BufRead,BufNewFile ~/vimwiki/*.md nnoremap <buffer> <leader>w<leader>o :bd<CR>
