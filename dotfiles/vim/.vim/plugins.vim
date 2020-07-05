" Automagic installation of Plug
" As seen in https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" set nocompatible              " be iMproved, required
" filetype off                  " required
" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

" ---- Plugin list: ---- "
Plug 'VundleVim/Vundle.vim'

" PLUGINS:
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
"" Plug 'scrooloose/syntastic'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'altercation/vim-colors-solarized'
Plug 'easymotion/vim-easymotion'
Plug 'vimwiki/vimwiki'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
" A class outliner for vim
" Plug 'majutsushi/tagbar'
" Plug 'klen/python-mode'
" Per-project vimrc
Plug 'embear/vim-localvimrc'
" Useful for XML/HTML
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" To align text
Plug 'godlygeek/tabular'
" Tabularize is much better
" Plug 'junegunn/vim-easy-align'
" Debugger
"Plug 'joonty/vdebug'
" Arduino IDE
" Plug '4Evergreen4/vim-hardy'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'voldikss/vim-floaterm'

" CODE:
" Indentation
"" Plug 'nathanaelkane/vim-indent-guides'
" Automatically add some closing quotes
"" Plug 'Raimondi/delimitMate'
" By pressing C-c after {, it will put the pointer in the line between { and }
imap <C-c> <CR><Esc>O
" Autocompletion
" Plug 'Valloric/YouCompleteMe'
" let g:ycm_add_preview_to_completeopt=0
" let g:ycm_confirm_extra_conf=0
" set completeopt-=preview
" Plug 'marijnh/tern_for_vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'janko/vim-test'
Plug 'tpope/vim-dispatch'
" Plug '5long/pytest-vim-compiler'

" JAVASCRIPT:
Plug 'jelera/vim-javascript-syntax'
"" TODO: Enable this for javascript
"" Plug 'pangloss/vim-javascript'
" Syntax highlighting for json
Plug 'elzr/vim-json'

" TYPESCRIPT:
" tsuquyomi disabled because it lags when the file is saved
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
" Plug 'Quramy/tsuquyomi'
" Plug 'leafgarland/typescript-vim'
" Plug 'Quramy/vim-js-pretty-template'

" CSS:
Plug 'ap/vim-css-color'
Plug 'chrisbra/Colorizer'

" RAILS:
" Plug 'tpope/vim-rails'
" Plug 'jgdavey/vim-turbux'

" DART:
Plug 'dart-lang/dart-vim-plugin'

" DASH INTEGRATION:
" Plug 'rizzatti/dash.vim'

" OpenScad
Plug 'sirtaj/vim-openscad'

" THEMES:
Plug 'morhetz/gruvbox'
"Plug 'sonph/onehalf', {'rtp': 'vim/'}
"Plug 'joshdick/onedark'
"Plug 'srcery-colors/srcery-vim'
"Plug 'crusoexia/vim-monokai'
"
" ---- End Plug list: ---- "

call plug#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
