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

lockfile=~/.lock.log

# Pause the music
playerctl pause || true


# Mute slack
source ~/.tokens
# slack-cli snooze start 180 || echo "Failed to snooze slack"
~/Scripts/slack-status || echo "Failed to change slack status"

# Log the lock
echo "L $(timestamp)" >> $lockfile

# Disable notifications
# https://faq.i3wm.org/question/5654/how-can-i-disable-notifications-when-the-screen-locks-and-enable-them-again-when-unlocking/index.html
notify-send "DUNST_COMMAND_PAUSE"

#./x86_64-pc-linux-gnu/i3lock \

# Troll mode 1
# i3lock -u -p default -i ~/Pictures/wallpapers/AuthDevLock.png -n

# Regular blur:
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
echo "U $(timestamp)" >> $lockfile

# Enable notifications
notify-send "DUNST_COMMAND_RESUME"
# Unmute slack
# slack-cli snooze end
slack-cli status edit " " ":python:" || echo "Failed to change slack status"

