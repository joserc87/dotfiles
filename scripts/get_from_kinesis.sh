#!/usr/bin/bash

# Read the message from the stdin
# set to red:
if [ $# -eq 0 ]; then
	OPTIONS=("quotas" "auth-webhook")
	select opt in "${OPTIONS[@]}"; do
		case $opt in
		"quotas")
			STREAM_NAME="user-quota-events"
			break
			;;
		"auth-webhook")
			STREAM_NAME="AuthWebhookNotificationsStream"
			break
			;;
		*)
			echo "Invalid option $REPLY"
			exit 1
			;;
		esac
	done
else
	STREAM_NAME="$1"
fi
echo -e "Enter the message from the DLQ (\033[31mCtrl+D\033[0m to end input):"
read -r message
SHARD_ID=$(echo "$message" | jq -r '.KinesisBatchInfo.shardId')
START_SEQUENCE_NUMBER=$(echo "$message" | jq -r '.KinesisBatchInfo.startSequenceNumber')
SHARD_ITERATOR=$(aws kinesis get-shard-iterator \
  --stream-name "$STREAM_NAME" \
  --shard-id "$SHARD_ID" \
  --shard-iterator-type AT_SEQUENCE_NUMBER \
  --starting-sequence-number "$START_SEQUENCE_NUMBER" | jq -r '.ShardIterator')

# Get the records using the shard iterator
while true; do
	RESPONSE=$(aws kinesis get-records --shard-iterator "$SHARD_ITERATOR")
	RECORDS=$(echo "$RESPONSE" | jq -r '.Records[].Data')
	for record in $RECORDS; do
		echo "$record" | base64 --decode | jq
	done
	SHARD_ITERATOR=$(echo "$RESPONSE" | jq -r '.NextShardIterator')
	if [ -z "$SHARD_ITERATOR" ]; then
		break
	fi
	sleep 1
done
