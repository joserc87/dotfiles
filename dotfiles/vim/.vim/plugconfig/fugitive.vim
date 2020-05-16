" FUGITIVE:
" --------
" Autodelete fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" MAPPINGS:
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
