#!/usr/bin/env bash

# https://www.thingiverse.com/thing:3085130
thing_url="${1}/zip"
dir="$HOME/3D/Thingiverse/"
cd $dir
wget --trust-server-names $thing_url 2> last_download.log
filename=$(awk <last_download.log '/^Saving to:/{print substr($0,13,length($0)-17)}')
mkdir "$filename"
cd "$filename"
unzip "../$filename.zip"
