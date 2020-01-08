#!/usr/bin/env bash

eval $(xdotool getmouselocation --shell)

/home/jose/repos/dmenu/dmenu -i -l 10 -y $Y -x $X -w 300 -m 0
