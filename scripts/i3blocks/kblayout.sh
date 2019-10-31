#!/usr/bin/env bash

if [[ "$BLOCK_BUTTON" ]] ; then
    $HOME/Scripts/switchkblayout
fi
setxkbmap -print | grep xkb_symbols | cut -d'+' -f 2

