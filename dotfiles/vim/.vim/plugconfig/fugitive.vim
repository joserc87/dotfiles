" FUGITIVE:
" --------
" Autodelete fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" MAPPINGS:
" Instead of just using :Git, just toggle the status
" nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gl :Glog<CR>

" Gitlab
let g:fugitive_gitlab_domains = ['https://gitlab.ravenpack.com']

" Shamelessly copied from https://gist.github.com/actionshrimp/6493611
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
command ToggleGStatus :call ToggleGStatus()
" nmap <F3> :ToggleGStatus<CR>
nnoremap <Leader>gs :ToggleGStatus<CR>
