#!/usr/bin/env bash

if [[ "$BLOCK_BUTTON" ]] ; then
    # Update, non cached
    if [[ "$BLOCK_BUTTON" == 1 ]] ; then # With left cilck, open
        $HOME/.local/bin/xdg-open "http://aws-jenkins:8080/user/jcano/my-views/view/Frontend/" > /dev/null
        $HOME/Scripts/jenkins status -c --pango
    elif [[ "$BLOCK_BUTTON" == 3 ]] ; then # With right click, reload
        $HOME/Scripts/jenkins status --pango
    else
        $HOME/Scripts/jenkins status -c --pango
    fi
else
    $HOME/Scripts/jenkins status -c --pango
fi

