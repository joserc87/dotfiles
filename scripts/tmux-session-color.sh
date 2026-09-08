#!/usr/bin/env bash
# Sets @session-color, a session-scoped user option, based on a hash of the
# session's name -- so ad-hoc/manual sessions get a stable, distinct accent
# color without any per-session config. .tmux.conf's status-left and
# window-status-current-format read this option live. tmuxp-managed sessions
# set @session-color explicitly in their yaml, applied after this, which wins.
set -euo pipefail

name=$(tmux display-message -p '#{session_name}')
hash=$(printf '%s' "$name" | cksum | cut -d' ' -f1)

palette=(colour24 colour28 colour94 colour131 colour61 colour30 colour100 colour125)
color=${palette[$((hash % ${#palette[@]}))]}

tmux set-option -t "$name" "@session-color" "$color"
