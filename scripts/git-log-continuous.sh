#!/usr/bin/env bash

# Runs git status continuously every couple of seconds.
# Idea taken from: https://gist.github.com/mikecharles/e808c77ddcc5ff239fe2696c61ffe1f1

# Run in a separate buffer, vim/paginator like
printf "\e[?1049h\e[H"
trap "printf '\033[?1049l'; exit 0" 2

while true ; do
  #clear
  # To avoid glitch, go to the begining of the terminal instead
  printf "\033c"
  # OR tput reset

  # Show the log
  printf "\e[0;35mgit graph\n---------\n\n\e[m"
  git --no-pager tree --branches --remotes --tags -n 10 #`tput lines`

  sleep 5
done
