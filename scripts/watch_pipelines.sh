#!/usr/bin/bash

export DIR=$HOME/git/python/smart-topics

cd $DIR
pipeline_url=""
while [ -z "$pipeline_url" ]; do
  pipeline_url=$(glab ci list -u jcano5 -s running --source push -F json -P 1 | jq -r '.[0].web_url')
  if [ -z "$pipeline_url" ]; then
    echo -n "."
    sleep 10
  fi
done
xdg-open "$pipeline_url"
