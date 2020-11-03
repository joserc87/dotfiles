" FUGITIVE:
" --------
" Autodelete fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" Gitlab
let g:fugitive_gitlab_domains = ['https://gitlab.ravenpack.com']
