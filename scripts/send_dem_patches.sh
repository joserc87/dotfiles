#!/bin/bash

# Does a git diff --patch on the files passed as argument, and composes
# the command to apply this patch (with git apply), copying it to the clipboard


read -r -d '' PATCH <<EOP
$(git diff --patch $@)
EOP

echo "cat << END_OF_PATCH |
$PATCH
END_OF_PATCH
git apply" | xclip -in -selection clipboard

