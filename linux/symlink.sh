#!/bin/sh
# Import symlink functions
. ../util.sh

dotfiles=""

# Link script files
warn "Linking linux config files\n";
symlink .config/ clipit ~/.config clipit 
symlink .config/ i3 ~/.config i3 
symlink .config/ i3blocks ~/.config i3blocks 
symlink .config/ i3lock ~/.config i3lock 
symlink .config/ ranger ~/.config ranger 
symlink .config/ rofi ~/.config rofi 
symlink .config/ compton.conf ~/.config compton.conf 
