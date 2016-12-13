#!/bin/bash

. util.sh

##############
# LINK FILES #
##############

./symlink.sh

############
# SOFTWARE #
############

# Install MacOSX software
case $OSTYPE in darwin*)
    # Mac software
    warn "Mac version detected\n";
    cd MacOSX;
    ./programs.sh;
    cd ..;
esac

# Install generic software
# Vundle
if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
    info "Installing Vundle\n";
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim;
else
    warn "Vundle already installed\n";
fi
