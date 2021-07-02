" Floaterm:
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1
let g:floaterm_opener = 'edit'

" nnoremap <C-p> :FloatermNew fzf<CR>
nnoremap <C-p> :FloatermNew --disposable --autoclose=2 fzf --preview '~/.vim/plugged/fzf.vim/bin/preview.sh {}'<CR>
nnoremap <leader>fz :FloatermNew fzf --preview '~/.vim/plugged/fzf.vim/bin/preview.sh {}'<CR>
nnoremap <leader>fs :FloatermNew zsh<CR>
nnoremap <leader>fr :FloatermNew ranger<CR>
nnoremap <leader>fp :FloatermNew  --wintype=normal --position=right --width=0.4 ipython<CR>
nnoremap <leader>fP :FloatermNew  --wintype=normal --position=right --width=0.4 python<CR>
nnoremap <Leader>fg :FloatermNew --disposable --autoclose=2 lazygit<CR>
nnoremap <Leader>ft :FloatermNew --disposable --autoclose=2 taskwarrior-tui<CR>

nnoremap <leader>ff :FloatermToggle<CR>
tnoremap <leader>ff <C-\><C-n>:FloatermToggle<CR>
tnoremap <leader>fg <C-\><C-n>:FloatermToggle<CR>
tnoremap <leader>fj <C-\><C-n>

nnoremap <leader>fh :FloatermPrev<CR>
tnoremap <leader>fh <C-\><C-n>:FloatermPrev<CR>
nnoremap <leader>fl :FloatermNext<CR>
tnoremap <leader>fl <C-\><C-n>:FloatermNext<CR>

nnoremap <leader>f> :FloatermSend<CR>
vnoremap <leader>f> :FloatermSend<CR>
