#!/bin/sh
# Import symlink functions
. ../util.sh

dotfiles=""

symlink_home vim/ .vim
symlink_home vim/ .vimrc
# For neovim, link to the .config folder
symlink vim/ .vimrc ~/.config/nvim/ init.vim

symlink_home git/ .gitconfig
symlink_home git/ .gitignore_global

symlink_home "" .bash_profile
symlink_home "" .zshrc
symlink_home "" .tmux.conf

symlink_home "" .tmuxinator

