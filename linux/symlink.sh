#!/bin/sh
# Import symlink functions
. ../util.sh

dotfiles=""

# Link script files
warn "Linking linux config files\n";
symlink linux/.config clipit ~/.config clipit 
symlink linux/.config i3 ~/.config i3 
symlink linux/.config i3blocks ~/.config i3blocks 
symlink linux/.config i3lock ~/.config i3lock 
symlink linux/.config ranger ~/.config ranger 
symlink linux/.config rofi ~/.config rofi 
symlink linux/.config compton.conf ~/.config comton.conf 
