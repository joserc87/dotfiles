#!/usr/bin/env bash

playing_icon='<span color="#AAFFFF"></span>'
paused_icon='<span color="#FFCC00"></span>'
stopped_icon='<span color="#FF00FF"></span>'


mpc_status=$(
    mpc status | \
        grep '^\[.*\]' | \
        sed -n -e 's/^\[\(.*\)].*$/\1/p'
)


if [[ "$BLOCK_BUTTON" ]] ; then
    case $mpc_status in
        playing) # If it's playing, pause
            mpc pause > /dev/null
            ;;
        paused) # If it's paused, play
            mpc play > /dev/null
            ;;
        "") # If it's not loaded, load files
            mpc add rain/0.m4a \
                rain/1.m4a \
                rain/2.m4a \
                rain/3.m4a \
                rain/4.m4a \
                rain/5.m4a \
                rain/6.m4a \
                rain/7.m4a > /dev/null
            mpc play > /dev/null
            ;;
    esac
fi

mpc_status=$(
    mpc status | \
        grep '^\[.*\]' | \
        sed -n -e 's/^\[\(.*\)].*$/\1/p'
)



case $mpc_status in
    playing)
        echo $playing_icon
        ;;
    paused)
        echo $paused_icon
        ;;
    *)
        echo $stopped_icon
        ;;
esac
