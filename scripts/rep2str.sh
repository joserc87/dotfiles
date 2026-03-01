#!/usr/bin/bash

function create_print_statement() {
  echo -n "print(\""
  cat
  echo "\")"
}
#create_print_statement | python 
#echo "print('$(cat)')" | python | xclip -selection clipboard
echo "$1"
