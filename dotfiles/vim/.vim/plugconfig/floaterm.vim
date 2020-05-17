" Floaterm:
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

nnoremap <C-p> :FloatermNew fzf<CR>
nnoremap <leader>fz :FloatermNew fzf --preview '~/.vim/bundle/fzf.vim/bin/preview.sh {}'<CR>
nnoremap <leader>fs :FloatermNew zsh<CR>
nnoremap <leader>fr :FloatermNew ranger<CR>
nnoremap <leader>fp :FloatermNew  wintype='normal' position='right' width=0.5 ipython<CR>
nnoremap <leader>ff :FloatermToggle<CR>
