" KEYBINDINGS:
" -----------

nmap <space> <leader>
nmap <space><space> <leader><leader>

" Map ; to : so we don't have to press shift
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" jj goes to normal mode
inoremap jj <ESC>

" Open vimrc and other vim configs
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>V :vsplit $MYVIMRC<CR>

" NAVIGATION:
" WINDOW
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" BUFFER
nnoremap <leader>bl :bnext<CR>
nnoremap <leader>bh :bprevious<CR>
nnoremap <leader>bq :bp <BAR> bd #<CR>
nnoremap <M-j> :tabnext<CR>
nnoremap <M-k> :tabprevious<CR>
nnoremap <M-l> :bnext<CR>
nnoremap <M-h> :bprevious<CR>
nnoremap <M-q> :bp <BAR> bd #<CR>
nnoremap <backspace> <C-^>
" QUICKFIX
nnoremap <leader>cc :copen<CR>
nnoremap <leader>cl :cn<CR>
nnoremap <leader>ch :cp<CR>
nnoremap <leader>cq :cclose<CR>
"nmap <leader>bl :ls<CR> " Show all open buffers and their status
" TAB
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabnew<CR>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap tq  :tabclose<CR>

" IDE:
nnoremap <C-M-F> :Ag<space>

vnoremap <C-M-J> :m '>+1<CR>gv=gv
vnoremap <C-M-K> :m '<-2<CR>gv=gv
