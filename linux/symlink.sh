#!/bin/bash
# Import symlink functions
. ../util.sh

dotfiles=""

# Link script files
warn "Linking linux config files\n";
symlink .config/ alacritty ~/.config alacritty 
symlink .config/ clipit ~/.config clipit 
symlink .config/ i3 ~/.config i3 
symlink .config/ i3blocks ~/.config i3blocks 
symlink .config/ i3lock ~/.config i3lock 
symlink .config/ ranger ~/.config ranger 
symlink .config/ rofi ~/.config rofi 
symlink .config/ compton.conf ~/.config compton.conf 

# Link home files
warn "Linking linux home files\n";
# Workaround for lightdm 1.33.1 breaking qtile 0.37.0's session entry; see the
# comments in linux/.xsession. Drop this once lightdm fixes its Xsession wrapper.
symlink "" .xsession ~ .xsession
