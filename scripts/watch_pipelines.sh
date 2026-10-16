#!/usr/bin/bash

# Wait for my next running push pipeline, open it, then follow it until it
# finishes and send a desktop notification with the result.

export DIR=$HOME/git/python/smart-topics

notify() {
  notify-send -a GitLab -h "string:x-dunst-stack-tag:pipeline-$pipeline_id" "$@"
}

cd $DIR
pipeline=""
while [ -z "$pipeline" ]; do
  pipeline=$(glab ci list -u jcano5 -s running --source push -F json -P 1 | jq -c '.[0] // empty')
  if [ -z "$pipeline" ]; then
    echo -n "."
    sleep 10
  fi
done
pipeline_id=$(jq -r '.id' <<< "$pipeline")
pipeline_url=$(jq -r '.web_url' <<< "$pipeline")
ref=$(jq -r '.ref' <<< "$pipeline")
xdg-open "$pipeline_url"
notify -u low "Pipeline $pipeline_id running" "<a href=\"$pipeline_url\">$ref</a>"

status=running
while [[ "$status" =~ ^(created|waiting_for_resource|preparing|pending|running)$ ]]; do
  sleep 15
  status=$(glab ci get -p "$pipeline_id" -F json | jq -r '.status // empty')
  [ -z "$status" ] && status=running  # transient glab/network error: keep polling
  echo -n "."
done
echo " $status"

case "$status" in
  success) notify "Pipeline $ref passed" "<a href=\"$pipeline_url\">$pipeline_id</a>" ;;
  manual)  notify "Pipeline $ref waiting on a manual job" "<a href=\"$pipeline_url\">$pipeline_id</a>" ;;
  *)       notify -u critical "Pipeline $ref $status" "<a href=\"$pipeline_url\">$pipeline_id</a>" ;;
esac
