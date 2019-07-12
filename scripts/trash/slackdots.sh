for i in {1..100}
do
slack-cli chat update "`printf '.%.0s' {1..$i}`" 1541765257.001200 @slackbot
sleep 1
done
