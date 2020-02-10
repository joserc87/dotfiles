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

" Remove the scroll bars:
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

if !has('nvim')
  set ttymouse=xterm2
endif

" Enable per-project .vimrc's
" UNSAFE
" set exrc

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" TABS:
" -----
" In a codebase that uses 4 space characters for each indent:
" set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
" In a codebase that uses a single tab character that appears 4-spaces wide
" for each indent:

" 4 spaces instead of a tab
set tabstop=4 shiftwidth=4 expandtab

" PLUGINS:
" --------
" The folowing file contains all the plugins
source ~/.vim/plugins.vim
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on

" Solarized colors

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" NORMAL SETTINGS:
" ---------------
" Reload files automatically:
set autoread

" Smarter tab line for airline:
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" automatically populate the g:airline_symbols
let g:airline_powerline_fonts = 1
"
" Dont write backup files
set nobackup
set nowritebackup
set noswapfile

" Open new split panes to right and bottom, which feels more natural than
" Vim's default
set splitbelow
set splitright

"  Relative line numbers
set rnu

" COLOR SCHEMES:
" -------------

set background=dark    " Setting dark mode
syntax on

" colorscheme candystripe
" colorscheme kolor
" colorscheme predawn

"colorscheme gruvbox
"colorscheme solarized
"colorscheme monokai

" WIN
if has("win32")
  if has("gui_running")
    colorscheme solarized
  else
    " colors in windows console do not work very well
    colorscheme kolor
  endif
" MAC
elseif has ("mac")
  " colorscheme solarized
  " colorscheme gruvbox
  " let g:airline_theme='gruvbox'
  colorscheme onehalfdark
  let g:airline_theme='onehalfdark'
" LINUX
elseif has ("unix")
  if has("gui_running")
    " colorscheme srcery
    colorscheme monokai
  else
    " colorscheme torte
    colorscheme gruvbox
    " colorscheme onehalfdark
    " let g:airline_theme='onehalfdark'
  endif
else
  colorscheme torte
endif
" Uncomment for transparent vim background if you are ready to be made fun of
" in #rice.
" hi Normal guibg=NONE ctermbg=NONE

" FONT:
" -----
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    " set guifont=Consolas:h11:cANSI
    set guifont=Ubuntu\ Mono:h11:cANSI
  endif
endif

" MAPPINGS:
" --------
" Set the leader to -
:let mapleader = ","
nmap <space> <leader>
nmap <space><space> <leader><leader>

" TAGBAR:
nmap <F8> ;TagbarToggle<CR>

" NERDTree:
nmap <leader>ne ;NERDTreeFocus<CR>

" jj goes to normal mode
inoremap jj <ESC>

" WINDOW NAVIGATION:
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Map ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
" Make ctrlp find dotfiles too
let g:ctrlp_show_hidden = 1
" List the buffers with CtrlP
nmap <leader>bb ;CtrlPMRU<CR>
" Ignore some files:
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$|node_modules$|dist$|\v[\/](bin|build|bundle)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

nmap <silent> <A-Up> ;wincmd k<CR>
nmap <silent> <A-Down> ;wincmd j<CR>
nmap <silent> <A-Left> ;wincmd h<CR>
nmap <silent> <A-Right> ;wincmd l<CR>

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
" This replaces ;tabnew which I used to bind to this mapping
" This would be incompatible with testing
"nmap <leader>T ;enew<cr>

" Buffer operations:
nmap <leader>bl ;bnext<CR>
nmap <leader>bh ;bprevious<CR>
nmap <leader>bq ;bp <BAR> bd #<CR>

" quickfix operations:
nmap <leader>cc ;copen<CR>
nmap <leader>cl ;cn<CR>
nmap <leader>ch ;cp<CR>
nmap <leader>cq ;cclose<CR>


" Show all open buffers and their status
"nmap <leader>bl ;ls<CR>

" Tab movement
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

" EASY MOTION:
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" For navigation \s{char}{label}
map <leader>s <Plug>(easymotion-s)
" OR for \s{char}{char}{label}
" map <leader>s <Plug>(easymotion-s2)

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" EASY ALIGN:
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" LOCALVIRC:
let g:localvimrc_sandbox = 0
let g:localvimrc_persistent = 1

" Test different files:
if has ("autocmd")
    autocmd FileType python nmap <Leader>t ;call VimuxRunCommand("pytest")<CR>
    autocmd FileType java nmap <Leader>t ;call VimuxRunCommand("gradle test")<CR>
    autocmd FileType java nmap <Leader>tp ;call VimuxRunCommand("gradle build && ./run.sh")<CR>
    autocmd FileType groovy nmap <Leader>t ;call VimuxRunCommand("gradle test")<CR>
    autocmd FileType groovy nmap <Leader>tp ;call VimuxRunCommand("gradle build && ./run.sh")<CR>
endif

" Map ; to : so we don't have to press shift
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Because we enable external .vimrc's, we prevent :autocmd, shell and write
" commands being run inside project-specific .vimrc unless they are owned by
" me
" set secure

" This enables customizing the vimrc on the fly
" Idea taken from: http://vimcasts.org/episodes/updating-your-vimrc-file-on-the-fly/
" Source the vimrc file after saving it
if has ("autocmd")
	autocmd bufwritepost .vimrc source $MYVIMRC
endif

" nmap <leader>v :tabedit $MYVIMRC<CR>
" Actually it would be better in vertical split
 nmap <leader>v ;vsplit $MYVIMRC<CR>

" Useful fugitive configurations:
if has ("autocmd")
	" Autodelete fugitive buffers
	autocmd BufReadPost fugitive://* set bufhidden=delete
endif

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

" Autocompletion:
"                                            _      _   _             
"   ___ ___   ___    ___ ___  _ __ ___  _ __ | | ___| |_(_) ___  _ __  
"  / __/ _ \ / __|  / __/ _ \| '_ ` _ \| '_ \| |/ _ \ __| |/ _ \| '_ \ 
" | (_| (_) | (__  | (_| (_) | | | | | | |_) | |  __/ |_| | (_) | | | |
"  \___\___/ \___|  \___\___/|_| |_| |_| .__/|_|\___|\__|_|\___/|_| |_|
"                                      |_|                             
" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"        _   _               
"   ___ | |_| |__   ___ _ __ 
"  / _ \| __| '_ \ / _ \ '__|
" | (_) | |_| | | |  __/ |   
"  \___/ \__|_| |_|\___|_|   
"                            
