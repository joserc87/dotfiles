#!/usr/bin/env bash

# Needed to run alacritty from the cronjob
# https://superuser.com/questions/351528/open-a-terminal-from-a-crontab
export DISPLAY=:0
# Needed to run dunstify from a cronjob
# https://www.reddit.com/r/NixOS/comments/yw87my/comment/ixd7g39/?utm_source=share&utm_medium=web2x&context=3
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

function notify_reminders {
    ACTION=$(dunstify -t 600000 --action="default,OpenClockwork" "Reminder" "$1")
    case "$ACTION" in
    "default")
	xdg-open "$2"
	;;
    "2")
	;;
    esac
}

# Send a notification to remind myself to update clockwork
# before shutting down the computer.
notify_reminders "Update clockwork" "https://ravenpack.atlassian.net/plugins/servlet/ac/clockwork-cloud/clockwork-mywork?project.key=DS&project.id=10045"
