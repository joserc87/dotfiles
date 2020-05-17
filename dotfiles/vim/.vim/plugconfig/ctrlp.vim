"   ____ _        _       ____  
"  / ___| |_ _ __| |     |  _ \ 
" | |   | __| '__| |_____| |_) |
" | |___| |_| |  | |_____|  __/ 
"  \____|\__|_|  |_|     |_|    
                              
let g:ctrlp_map = '<c-o>'
let g:ctrlp_cmd = 'CtrlPMRU'
" Make ctrlp find dotfiles too
let g:ctrlp_show_hidden = 1
" List the buffers with CtrlP
nnoremap <leader>bb :CtrlPBuffer<CR>
" Ignore some files:
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$|node_modules$|dist$|\v[\/](bin|build|bundle)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
