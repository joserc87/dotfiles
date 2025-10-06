#!/usr/bin/bash

REPO=~/git/python/smart-topics
REPORT=/tmp/mrs.txt

cd $REPO

rm -f "$REPORT"
function list_issues {
  assignee=$1
  echo "--------- MRs from $assignee --------" >> "$REPORT"
  # Filter out lines starting with "^Showing" and "^No merge requests match"
  glab mr list --not-label tase,we,px,briefs,content-experience --assignee="$assignee" --all \
    | grep -vE '^(Showing|No merge requests match)' \
    >> "$REPORT"
  echo "" >> "$REPORT"
}
list_issues prubio4
list_issues jcano5
list_issues pmunnelly
list_issues amarquez7442902
list_issues gnazarko
list_issues kklimaszewska


nvim "$REPORT"

# list_issues outputs like:
# !2220	ravenpack/development/bigdata.com/backend!2220	Tase 511 expose sdk quota consumption for cs of ravenpack	(master) ← (TASE-511-Expose-SDK-quota-consumption-for-CS-of-RavenPack-)

# Let's get only the MR numbers (!2220) and set the label
cat "$REPORT" | \
  grep '^!' | \
  cut -f1 -d$'\t' | while read -r mr; do
	echo "Setting label 'tase' to $mr"
	glab mr update "$mr" --label "tase"
  done
