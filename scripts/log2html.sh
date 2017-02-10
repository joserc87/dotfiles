year=`ls -t -d ~/Documents/Work/log/*/ | head -1`
month=`ls -t $year | head -1`
lineLastRecord=`sed -n '{ /^# /=;}' $year$month | tail -1`
tail -n +$lineLastRecord $year$month | /usr/local/bin/markdown_py
