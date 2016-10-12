#!/bin/bash
# Install software
./MacOSX/programs.sh
# Link dot files
./dotfiles/symlink.sh
# Vundle
if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
    echo "Installing Vundle";
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim;
else
    echo "Vundle already installed";
fi
