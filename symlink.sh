#!/bin/bash
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

# Link Linux specific files (.config)
case $OSTYPE in linux*)
    warn "Linking linux .config files\n";
    cd linux
    ./symlink.sh
    cd ..
esac


# Link MacOS specific files (scripts)
case $OSTYPE in darwin*)
    warn "Linking mac scripts\n";
    cd MacOSX
    ./symlink.sh
    cd ..
esac

