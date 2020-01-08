#!/usr/bin/env bash

devtime=$HOME/Scripts/devtime
if [[ "$BLOCK_BUTTON" ]] ; then
    if [[ "$BLOCK_BUTTON" == 1 ]] ; then
        #report=$($HOME/Scripts/devtime --week --short)
        report=$($devtime --week)
        notify-send -a DevTime -t 0 "Dev Uptime" "$report"
    elif [[ "$BLOCK_BUTTON" == 3 ]] ; then
        editi3 ~/.lock.log
    fi
fi
$devtime --short

