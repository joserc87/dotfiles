#!/usr/bin/bash

# Opens brave browser with a specific profile

BRAVE_DIR="$HOME/.config/BraveSoftware/Brave-Browser/"

list_profiles() {
  local_state="$BRAVE_DIR/Local State"
  jq -r '.profile.info_cache | (keys[] as $k | "\($k);\(.[$k].name)")' "$local_state"
}

open_profile_by_name() {
  IFS=$'\n'
  for profile in $(list_profiles); do
    profile_id=$(echo "$profile" | cut -d';' -f1)
    profile_name=$(echo "$profile" | cut -d';' -f2)
    if [ "$profile_name" == "$1" ]; then
      brave --profile-directory="$profile_id" --class="$profile_name" &
      unset IFS
      return
    fi
  done
  unset IFS
  echo "Profile not found"
}

select_profile_dmenu() {
  # Open dmenu in vertical and case-insensitive mode
  profile_name=$(list_profiles | cut -d';' -f2 | sort | dmenu -p "Select profile" -l 10 -i)
  open_profile_by_name "$profile_name"
}

#list_profiles
select_profile_dmenu
