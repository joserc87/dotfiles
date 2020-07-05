" FUGITIVE:
" --------
" Autodelete fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" MAPPINGS:
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>

" Gitlab
let g:fugitive_gitlab_domains = ['https://gitlab.ravenpack.com']
