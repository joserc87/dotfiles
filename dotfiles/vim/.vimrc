"  _   _         __     ___           
" | \ | | ___  __\ \   / (_)_ __ ___  
" |  \| |/ _ \/ _ \ \ / /| | '_ ` _ \ 
" | |\  |  __/ (_) \ V / | | | | | | |
" |_| \_|\___|\___/ \_/  |_|_| |_| |_|
"                                     
"
" José Ramón Cano Yribarren
" joserc87@gmail.com
"
" This configuration file is released under the GPL terms
" This vim configuration file was written based on my
" own preferences, but hoping that you can find useful
" stuff to create your own. ;)

" BASIC SETTINGS:
" Set the leader to space
:let mapleader = " "
nmap <space> <leader>
nmap <space><space> <leader><leader>


" VUNDLE:

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
source ~/.vim/plugins.vim
call vundle#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on

" THEME:
source ~/.vim/theme.vim

"        _             _           
"  _ __ | |_   _  __ _(_)_ __  ___ 
" | '_ \| | | | |/ _` | | '_ \/ __|
" | |_) | | |_| | (_| | | | | \__ \
" | .__/|_|\__,_|\__, |_|_| |_|___/
" |_|            |___/             

" AIRLINE:
" -------
" Smarter tab line for airline:
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" automatically populate the g:airline_symbols
let g:airline_powerline_fonts = 1

" NERDTREE:
" --------
nmap <leader>ne ;NERDTreeFocus<CR>

" EASY ALIGN:
" ----------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" FUGITIVE:
" --------
" Autodelete fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" TAGBAR:
" ------
" nmap <F8> ;TagbarToggle<CR>

" VIMUX:
" -----
" Unit testing with <Leader>t:
if has ("autocmd")
    autocmd FileType python nmap <Leader>t ;call VimuxRunCommand("pytest")<CR>
    autocmd FileType java nmap <Leader>t ;call VimuxRunCommand("gradle test")<CR>
    autocmd FileType java nmap <Leader>tp ;call VimuxRunCommand("gradle build && ./run.sh")<CR>
    autocmd FileType groovy nmap <Leader>t ;call VimuxRunCommand("gradle test")<CR>
    autocmd FileType groovy nmap <Leader>tp ;call VimuxRunCommand("gradle build && ./run.sh")<CR>
endif

" OTHER PLUGINS:
source ~/.vim/ctrlp.vim
source ~/.vim/coc.vim
source ~/.vim/easymotion.vim

"  _                                               
" | | __ _ _ __   __ _ _   _  __ _  __ _  ___  ___ 
" | |/ _` | '_ \ / _` | | | |/ _` |/ _` |/ _ \/ __|
" | | (_| | | | | (_| | |_| | (_| | (_| |  __/\__ \
" |_|\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___||___/
"                |___/             |___/           

" MARKDOWN:
" Set any *.md file to Markdown by default
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
" To enable fenced code block syntax highlighting
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
" ysiwi will make word italic (*italic*):
" ysiwb will make word bold (**word**):
autocmd FileType markdown,octopress let b:surround_{char2nr('i')} = "*\r*"
autocmd FileType markdown,octopress let b:surround_{char2nr('b')} = "**\r**"

" EmbeddedJavaScript:
autocmd BufNewFile,BufRead *.ejs set filetype=html

" ANTLR:
au BufRead,BufNewFile *.g set syntax=antlr3
au BufRead,BufNewFile *.g4 set syntax=antlr

" SPELL:
au BufRead,BufNewFile *.spl set syntax=spell

" HTML:
autocmd FileType html setlocal softtabstop=4 shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType javascript setlocal softtabstop=2 shiftwidth=2 tabstop=2 expandtab

" PYTHON:
autocmd FileType python set foldmethod=indent

"        _   _               
"   ___ | |_| |__   ___ _ __ 
"  / _ \| __| '_ \ / _ \ '__|
" | (_) | |_| | | |  __/ |   
"  \___/ \__|_| |_|\___|_|   
"                            

" BASIC SETTINGS:
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

" This enables customizing the vimrc on the fly
" Idea taken from: http://vimcasts.org/episodes/updating-your-vimrc-file-on-the-fly/
" Source the vimrc file after saving it
if has ("autocmd")
	autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Autocompletion
set wildmode=longest,list,full

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" KEYBINDINGS:
" -----------

" Map ; to : so we don't have to press shift
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" jj goes to normal mode
inoremap jj <ESC>

" Open vimrc
nmap <leader>v ;vsplit $MYVIMRC<CR>

" NAVIGATION:
" WINDOW
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" BUFFER
nmap <leader>bl ;bnext<CR>
nmap <leader>bh ;bprevious<CR>
nmap <leader>bq ;bp <BAR> bd #<CR>
" QUICKFIX
nmap <leader>cc ;copen<CR>
nmap <leader>cl ;cn<CR>
nmap <leader>ch ;cp<CR>
nmap <leader>cq ;cclose<CR>
"nmap <leader>bl ;ls<CR> " Show all open buffers and their status
" TAB
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
" Alternatively use
"nnoremap th :tabnext<CR>
"nnoremap tl :tabprev<CR>
"nnoremap tn :tabnew<CR>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
