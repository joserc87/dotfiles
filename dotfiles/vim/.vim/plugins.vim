set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" ---- Plugin list: ---- "
Plugin 'VundleVim/Vundle.vim'

" PLUGINS:
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
"" Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Plugin 'altercation/vim-colors-solarized'
Plugin 'easymotion/vim-easymotion'
Plugin 'vimwiki'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'
" Git
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/gv.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'airblade/vim-gitgutter'
" A class outliner for vim
" Plugin 'majutsushi/tagbar'
" Plugin 'klen/python-mode'
" Per-project vimrc
Plugin 'embear/vim-localvimrc'
" Useful for XML/HTML
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
" To align text
Plugin 'godlygeek/tabular'
" Tabularize is much better
" Plugin 'junegunn/vim-easy-align'
" Debugger
"Plugin 'joonty/vdebug'
" Syntax highlighting for json
Plugin 'elzr/vim-json'
" Arduino IDE
" Plugin '4Evergreen4/vim-hardy'
Plugin 'tpope/vim-repeat'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'airblade/vim-rooter'
" CODE:
" Indentation
"" Plugin 'nathanaelkane/vim-indent-guides'
" Automatically add some closing quotes
"" Plugin 'Raimondi/delimitMate'
" By pressing C-c after {, it will put the pointer in the line between { and }
imap <C-c> <CR><Esc>O
" Autocompletion
" Plugin 'Valloric/YouCompleteMe'
" let g:ycm_add_preview_to_completeopt=0
" let g:ycm_confirm_extra_conf=0
" set completeopt-=preview
" Plugin 'marijnh/tern_for_vim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'janko/vim-test'
Plugin 'tpope/vim-dispatch'
" Plugin '5long/pytest-vim-compiler'

" JAVASCRIPT:
Plugin 'jelera/vim-javascript-syntax'
"" TODO: Enable this for javascript
"" Plugin 'pangloss/vim-javascript'

" TYPESCRIPT:
" tsuquyomi disabled because it lags when the file is saved
" Plugin 'Shougo/vimproc.vim', {'do' : 'make'}
" Plugin 'Quramy/tsuquyomi'
" Plugin 'leafgarland/typescript-vim'
" Plugin 'Quramy/vim-js-pretty-template'

" CSS:
Plugin 'ap/vim-css-color'
Plugin 'chrisbra/Colorizer'

" RAILS:
" Plugin 'tpope/vim-rails'
" Plugin 'jgdavey/vim-turbux'

" DART:
Plugin 'dart-lang/dart-vim-plugin'

" DASH INTEGRATION:
" Plugin 'rizzatti/dash.vim'

" OpenScad
Plugin 'sirtaj/vim-openscad'

" THEMES:
Plugin 'morhetz/gruvbox'
"Plugin 'sonph/onehalf', {'rtp': 'vim/'}
"Plugin 'joshdick/onedark'
"Plugin 'srcery-colors/srcery-vim'
"Plugin 'crusoexia/vim-monokai'
"
" ---- End Plugin list: ---- "

call vundle#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
