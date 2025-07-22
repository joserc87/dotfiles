#!/usr/bin/bash

export DIR=$HOME/git/python/smart-topics

cd $DIR
last_id=$(glab ci list -u jcano5 -s running --source push -F json -P 1 | jq '.[0].id')
