#!/bin/bash

ref_date='Thu Apr 19 17:07:39 CDT 2012'
#ref_sec=$(date -j -f '%a %b %d %T %Z %Y' "${ref_date}" +%s)
ref_sec=$(date +%s)

update_inc=1

#tput clear
#cat <<'EOF'
#
#
#            [|]     [|]
#         _-'''''''''''''-_
#        /                 \
#       |                   |
#       |                   |
#       |                   |
#        \                 /
#         '-_____________-'
#EOF

while :
do
  ((sec=$(date +%s) - ${ref_sec}))
  ((day=sec/86400))
  ((sec-=day*86400))
  ((hour=sec/3600))
  ((sec-=hour*3600))
  ((min=sec/60))
  ((sec-=min*60))
  #tput cup 6 14
  #tput cup 0 0
  printf "\r%.2id:%.2ih:%.2im:%.2is" ${day} ${hour} ${min} ${sec}
  sleep ${update_inc}
done

exit 0
