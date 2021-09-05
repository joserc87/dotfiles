" vim:fdm=marker
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

" Sensible Y. For old Y, just do yy!
nnoremap Y y$

" NAVIGATION: {{{
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
" nnoremap <M-j> :tabnext<CR>
" nnoremap <M-k> :tabprevious<CR>
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
" }}}

" IDE: {{{
" Search:
" nnoremap <C-p> :Files<CR>
nnoremap <C-M-F> :Ag<space>
nnoremap <leader>/ :Ag<space>
vnoremap <leader>/ y:Ag<space><C-R>=escape(@",'/\')<CR><CR>
vnoremap / y/\V<C-R>=escape(@",'/\')<CR><CR>
" }}}

" Buffers: {{{
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>bh :History<CR>
nnoremap <leader>bl :BLines<CR>
nnoremap <leader>bL :Lines<CR>
" }}}

" Git: {{{
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
" Very useful to see other revisions of the current buffer
" nnoremap <Leader>gh :0Glog<CR>
nnoremap <leader>gH :Commits<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gP :Gpull<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gs :ToggleGStatus<CR>
" }}}
"
" Debugger: {{{
" Debugger remaps
nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>dq :call vimspector#Reset()<CR>
nnoremap <leader>dR :call vimspector#Restart()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dh  <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d$ :call vimspector#Continue()<CR>
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>dbc <Plug>VimspectorToggleConditionalBreakpoint
" }}}


" Command: {{{
nnoremap <leader><C-R> :History:<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>; :Commands<CR>

vnoremap <C-M-J> :m '>+1<CR>gv=gv
vnoremap <C-M-K> :m '<-2<CR>gv=gv

nnoremap cn *``cgn
nnoremap cN *``cgN
" }}}

" CLIPBOARD: {{{
nnoremap yy  "+Y
nnoremap +  "+
vnoremap +  "+
" }}}

" TOGGLE: {{{
nnoremap <leader>sa :set laststatus=0<CR>:AirlineToggle<CR>
function! BgToggleSol()
    if (&background == "light")
      set background=dark 
    else
       set background=light 
    endif
endfunction

nnoremap <F4> :set relativenumber! number! showmode! showcmd! hidden! ruler!<CR> :AirlineToggle<CR>:set laststatus=0<CR>:set cmdheight=1<CR>
nnoremap <silent> <F5> :call BgToggleSol()<cr>
" }}}

" Execute line under cursor
nnoremap <leader>x :exe getline('.')<CR>
nnoremap <leader>nw :GonvimFilerOpen<CR>
nnoremap <leader>nW :GonvimWorkspaceNew<CR>
nnoremap <leader>nh :GonvimWorkspacePrevious<CR>
nnoremap <leader>nl :GonvimWorkspaceNext<CR>
"
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
