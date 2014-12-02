#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

#if [ -d /etc/X11/xinit/xinitrc.d ]; then
#  for f in /etc/X11/xinit/xinitrc.d/*; do
#    [ -x "$f" ] && . "$f"
#  done
#  unset f
#fi

# Load .Xresources
xrdb ~./.Xresources
# Set the background of i3
fe --bg-scale ~/Pictures/Wallpapers/ArchLinux1.png

exec i3

# exec i3 -v
# exec i3 -v >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1
# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
