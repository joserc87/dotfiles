#!/usr/bin/env bash

if [[ "$BLOCK_BUTTON" ]] ; then
    #report=$($HOME/Scripts/devtime --week --short)
    report=$($HOME/Scripts/devtime --week)
    notify-send -a DevTime -t 0 "Dev Uptime" "$report"
fi
$HOME/Scripts/devtime --short

