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
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'
Plug 'easymotion/vim-easymotion'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tools-life/taskwiki'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'tpope/vim-dotenv'
" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
" A class outliner for vim
Plug 'preservim/tagbar'
" Per-project vimrc
Plug 'embear/vim-localvimrc'
" Useful for XML/HTML
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
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
" Plug 'airblade/vim-rooter'
Plug 'voldikss/vim-floaterm'
Plug 'kshenoy/vim-signature'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'michaeljsmith/vim-indent-object'
Plug 'lucapette/vim-textobj-underscore'
Plug 'wellle/targets.vim'
Plug 'idbrii/textobj-word-column.vim'
Plug 'itchyny/vim-cursorword'
" Telescope
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'

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
Plug 'dense-analysis/ale'
Plug 'janko/vim-test'
Plug 'tpope/vim-dispatch'
Plug '5long/pytest-vim-compiler'
" Plug 'alfredodeza/pytest'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

Plug 'honza/vim-snippets'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" DB:
Plug 'kristijanhusak/vim-packager', { 'type': 'opt' }
Plug 'tpope/vim-dadbod', { 'branch': 'async-query' }
Plug 'kristijanhusak/vim-dadbod-ui'

" PYTHON:
" Plug 'klen/python-mode'
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

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

" OpenScad:
Plug 'sirtaj/vim-openscad'

" ICONS:
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" THEMES:
" Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
"Plug 'sonph/onehalf', {'rtp': 'vim/'}
"Plug 'joshdick/onedark'
"Plug 'srcery-colors/srcery-vim'
"Plug 'crusoexia/vim-monokai'
"
" ---- End Plug list: ---- "

" OTHER:
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

Plug 'itchyny/calendar.vim'

call plug#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
