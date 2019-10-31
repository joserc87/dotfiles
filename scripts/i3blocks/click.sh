#!/usr/bin/env bash

# echo Keep clicking me!; [[ "$BLOCK_BUTTON" ]] && notify-send clicked
echo "`date +'%a %d %b'` <b>`date +'%T'`</b> "; [[ "$BLOCK_BUTTON" ]] && gsimplecal &

