
" BASIC SETTINGS:
:let mapleader = " "
set tabstop=4 shiftwidth=4 expandtab " 4 spaces instead of a tab
set autoread " Reload files automatically
" Dont write backup files
set nobackup
set nowritebackup
set noswapfile
" Open new split panes to right and bottom, which feels more natural than
" Vim's default
set splitbelow
set splitright
set number relativenumber " shows number + relative. Otherwise, set rnu
if !has('nvim')
  set ttymouse=xterm2
endif
" set clipboard=unnamedplus

" Enable per-project .vimrc's
" UNSAFE
" set exrc

" LOCALVIRC:
let g:localvimrc_sandbox = 0
let g:localvimrc_persistent = 1
" Because we enable external .vimrc's, we prevent :autocmd, shell and write
" commands being run inside project-specific .vimrc unless they are owned by
" me
set secure
"
" Autocompletion
" set wildmode=longest,list,full

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" This enables customizing the vimrc on the fly
" Idea taken from: http://vimcasts.org/episodes/updating-your-vimrc-file-on-the-fly/
" Source the vimrc file after saving it
if has ("autocmd")
	autocmd bufwritepost .vimrc source $MYVIMRC
endif

let g:python_host_prog = '~/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/home/jcano/.pyenv/versions/neovim3/bin/python'
let $EDITOR = 'floaterm'

let g:ale_disable_lsp = 1
" let g:ale_sign_column_alway = 0
" let g:ale_sign_error = ''
" let g:ale_sign_warning = ''

" FIRENVIM:
au BufEnter jira.ravenpack.com_*.txt set filetype=markdown

" GBrowse doesn't work if netrw is disabled, so we define our own command
function! Browse(pathOrUrl)
  " This doesn't work with /usr/bin/vim on macOS (doesn't identify as macOS).
  if has('mac')| let openCmd = 'open'| else| let openCmd = 'xdg-open'| endif
    silent execute "! " . openCmd . " " . shellescape(a:pathOrUrl, 1)| " Escape Path or URL and pass as arg to open command.
    echo openCmd . " " shellescape(a:pathOrUrl, 1)| " Echo what we ran so it's visible.
endfunction
command! -nargs=1 Browse call Browse(<q-args>)|     " :Browse runs :call Browse() (defined above).
