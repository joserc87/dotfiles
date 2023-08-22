#!/usr/bin/bash

# Needed to run alacritty from the cronjob
# https://superuser.com/questions/351528/open-a-terminal-from-a-crontab
export DISPLAY=:0
# Needed to run dunstify from a cronjob
# https://www.reddit.com/r/NixOS/comments/yw87my/comment/ixd7g39/?utm_source=share&utm_medium=web2x&context=3
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

function check_git_status {
  dir="$1"
  pushd "$dir" > /dev/null

  if [ ! -z "$(git status --porcelain)" ]; then 
    # Working directory dirty
    echo "... DIRTY:     $dir"
    msg="The folder has some files to push to git

    $dir"
    ACTION=$(dunstify -t 600000 --action="default,OpenLazyGit" "Changes to push" "$msg")

    case "$ACTION" in
    "default")
	alacritty -e zsh -c lazygit code/braindump
	;;
    "2")
	;;
    esac
    
  else
    echo "... ALL CLEAN: $dir"
  fi

  popd > /dev/null
}

check_git_status ~/ansible
check_git_status ~/code/braindump
check_git_status ~/code/dotfiles
