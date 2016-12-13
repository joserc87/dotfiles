#!/bin/sh
# Import symlink functions
. ./util.sh

dotfiles=""

# Link script files
warn "Linking scripts\n";
symlink_home "" scripts

# Link dot files
warn "Linking configuration files\n";
cd dotfiles
./symlink.sh
cd ..

# Link MacOS specific files (scripts)
case $OSTYPE in darwin*)
    warn "Linking mac scripts\n";
    cd MacOSX
    ./symlink.sh
    cd ..
esac

