#!/usr/bin/env bash

if [[ "$BLOCK_BUTTON" ]] ; then
    if [[ "$BLOCK_BUTTON" == 1 ]] ; then
        /usr/bin/pavucontrol -t 3 --name "pavucontrol-bar"
        $HOME/Scripts/i3blocks/volume_control.py signal
    elif [[ "$BLOCK_BUTTON" == 4 ]] ; then # Mouse up
        $HOME/Scripts/volume up
    elif [[ "$BLOCK_BUTTON" == 5 ]] ; then # Mouse down
        $HOME/Scripts/volume down
    elif [[ "$BLOCK_BUTTON" == 3 ]] ; then # Right mouse -> mute toggle
        $HOME/Scripts/i3blocks/volume_control.py toggle 
    fi
fi

# Show the volume
$HOME/Scripts/i3blocks/volume_control.py i3blocks
