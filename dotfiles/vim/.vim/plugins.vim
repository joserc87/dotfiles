"/home/jcano/git/entitytool/ravenpack/reporting/views/categoryreport.py Automagic installation of Plug
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

" MOTION:
Plug 'easymotion/vim-easymotion'

" EDIT:
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-abolish'
Plug 'godlygeek/tabular'
" new objects
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'michaeljsmith/vim-indent-object'
Plug 'lucapette/vim-textobj-underscore'
Plug 'wellle/targets.vim'
Plug 'idbrii/textobj-word-column.vim'
" Automatically add some closing quotes
"" Plug 'Raimondi/delimitMate'

" UI:
" A class outliner for vim
Plug 'preservim/tagbar'
Plug 'embear/vim-localvimrc'
Plug 'voldikss/vim-floaterm'
Plug 'kshenoy/vim-signature'
" Underlines the word under the cursor
Plug 'itchyny/vim-cursorword'
" An implementation of the Popup API from vim in Neovim. Hope to upstream when complete
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
" Window maximizer
Plug 'szw/vim-maximizer'
" Airline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Indentation
"" Plug 'nathanaelkane/vim-indent-guides'



"""""""
" IDE "
"""""""

" GIT:
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'

" FILE_NAVIGATION:
Plug 'kyazdani42/nvim-tree.lua'
Plug 'tpope/vim-projectionist'
" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'rmagatti/auto-session'
Plug 'rmagatti/session-lens'
" Nerdtree
" Plug 'scrooloose/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'junegunn/vim-easy-align'

" LSP:
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Using fork of lspsaga until main supports nvim > 5.1
Plug 'tami5/lspsaga.nvim'
" Plug 'glepnir/lspsaga.nvim'

" FORMAT:
Plug 'mhartington/formatter.nvim'

" SNIPPETS:
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'honza/vim-snippets'

" TESTS:
Plug 'janko/vim-test'
Plug 'tpope/vim-dispatch'

" DEBUG:
Plug 'puremourning/vimspector'
" Plug 'joonty/vdebug'
" Rooter changes the working directory to the project root when you open a
" file or directory.
" Plug 'airblade/vim-rooter'

" LINT:
Plug 'folke/trouble.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Ale is useful, but temporarily dissabled
" Plug 'dense-analysis/ale'

" AUTOCOMPLETION:
" Plug 'Valloric/YouCompleteMe'
" let g:ycm_add_preview_to_completeopt=0
" let g:ycm_confirm_extra_conf=0
" set completeopt-=preview
" Plug 'marijnh/tern_for_vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Coq
" main one
""" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
""" " 9000+ Snippets
""" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
"""
""" " lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
""" " Need to **configure separately**
""" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
""" " - shell repl
""" " - nvim lua api
""" " - scientific calculator
""" " - comment banner
""" " - etc
""" "

"""""""""""""
" LANGUAGES "
"""""""""""""

" DB:
Plug 'kristijanhusak/vim-packager', { 'type': 'opt' }
Plug 'tpope/vim-dadbod', { 'branch': 'async-query' }
Plug 'kristijanhusak/vim-dadbod-ui'

" PYTHON:
Plug '5long/pytest-vim-compiler'
Plug 'mattboehm/vim-unstack'
Plug 'sagi-z/vimspectorpy', { 'do': { -> vimspectorpy#update() } }
" Plug 'alfredodeza/pytest'
" Plug 'klen/python-mode'
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" JAVASCRIPT:
Plug 'jelera/vim-javascript-syntax'
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

" DASH:
" Plug 'rizzatti/dash.vim'

" OPENSCAD:
Plug 'sirtaj/vim-openscad'

" ARDUINO:
" Plug '4Evergreen4/vim-hardy'

""""""""
" UTIL "
""""""""

" WIKI:
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tools-life/taskwiki'
Plug 'itchyny/calendar.vim'

" TMUX:
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" INTEGRATIONS:
Plug 'tpope/vim-dotenv'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

""""""""
" RICE "
""""""""

" ICONS:
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'

" THEMES:
Plug 'sainnhe/gruvbox-material'
" Plug 'morhetz/gruvbox'
" Plug 'sonph/onehalf', {'rtp': 'vim/'}
" Plug 'joshdick/onedark'
" Plug 'srcery-colors/srcery-vim'
" Plug 'crusoexia/vim-monokai'

" DASHBOARD:
" Plug 'glepnir/dashboard-nvim'

call plug#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
