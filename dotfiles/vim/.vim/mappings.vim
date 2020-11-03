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
nnoremap <leader>vv :e $MYVIMRC<CR>
nnoremap <leader>V :vsplit $MYVIMRC<CR>

" NAVIGATION:
" WINDOW
" This is done with tmux navigation
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>
" BUFFER
nnoremap <leader>bl :bnext<CR>
nnoremap <leader>bh :bprevious<CR>
nnoremap <leader>bq :bp <BAR> bd #<CR>
nnoremap <M-j> :tabnext<CR>
nnoremap <M-k> :tabprevious<CR>
nnoremap <M-l> :bnext<CR>
nnoremap <M-h> :bprevious<CR>
nnoremap <M-q> :bp <BAR> bd #<CR>
" nnoremap <backspace> <C-^>
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
" Search:
nnoremap <C-M-F> :Ag<space>
nnoremap <leader>/ :Ag<space>

" Buffers:
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>bh :History<CR>
nnoremap <leader>bl :BLines<CR>
nnoremap <leader>bL :Lines<CR>

" Git:
" Shamelessly copied from https://gist.github.com/actionshrimp/6493611
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
command ToggleGStatus :call ToggleGStatus()
nnoremap <leader>gh :BCommits<CR>
nnoremap <leader>gH :Commits<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gP :Gpull<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gg :FloatermNew lazygit<CR>
nnoremap <Leader>gs :ToggleGStatus<CR>


" Command:
nnoremap <leader><C-R> :History:<CR>
nnoremap <leader>: :Commands:<CR>

vnoremap <C-M-J> :m '>+1<CR>gv=gv
vnoremap <C-M-K> :m '<-2<CR>gv=gv

nnoremap cn *``cgn
nnoremap cN *``cgN

" CLIPBOARD:
nnoremap yy  "+Y
nnoremap +  "+
vnoremap +  "+

" TOGGLE:
nnoremap <leader>sa :set laststatus=0<CR>:AirlineToggle<CR>
function! BgToggleSol()
    if (&background == "light")
      set background=dark 
    else
       set background=light 
    endif
endfunction

nnoremap <silent> <F5> :call BgToggleSol()<cr>
