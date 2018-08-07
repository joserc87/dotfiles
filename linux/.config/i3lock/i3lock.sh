#!/usr/bin/env bash
set -eu

[[ -z "$(pgrep i3lock)" ]] || exit

#i3lock -n -u -t -i ${HOME}/.config/i3lock/lock.png
#i3lock -n -u -c000000

timestamp() {
  date +"%Y-%m-%d_%H-%M-%S"
}

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#ff00ffcc'  # default
D='#FFFFFF33'  # default
T='#ee00eeee'  # text
T='#FFFFFF33'  # text
W='#880000bb'  # wrong
V='#bb00bbbb'  # verifying

# Pause the music
playerctl pause || true

# Log the lock
echo "L $(timestamp)" >> ~/lock.log

# Disable notifications
# https://faq.i3wm.org/question/5654/how-can-i-disable-notifications-when-the-screen-locks-and-enable-them-again-when-unlocking/index.html

#./x86_64-pc-linux-gnu/i3lock \
i3lock \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--textcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--screen 0            \
--blur 5              \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \
--keylayout 2         \
-n
# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
# --textsize=20
# --modsize=10
# --timefont=comic-sans
# --datefont=monofur
# etc

# logunlock
# Log the lock
echo "U $(timestamp)" >> ~/lock.log
