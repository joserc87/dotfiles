#!/usr/bin/env bash

# Downloads a DynamoDB item by ID, deletes it from DDB and does a put_item

# Usage: ./re-inject-ddb-item.sh <table_name> <id>

set -e

download_item() {
	local table_name=$1
	local id=$2

	# Download the item from DynamoDB
	aws dynamodb get-item \
		--table-name "$table_name" \
		--key "{\"id\": {\"S\": \"$id\"}}" \
		--output json | jq .Item > $id.json
}

delete_item() {
	local table_name=$1
	local id=$2

	# Delete the item from DynamoDB
	aws dynamodb delete-item \
		--table-name "$table_name" \
		--key "{\"id\": {\"S\": \"$id\"}}"
}

put_item() {
	local table_name=$1
	local id=$2

	# Put the item back into DynamoDB
	aws dynamodb put-item \
		--table-name "$table_name" \
		--item file://$id.json
}

main() {
	if [ "$#" -ne 2 ]; then
		echo "Usage: $0 <table_name> <id>"
		exit 1
	fi

	local table_name=$1
	local id=$2

	download_item "$table_name" "$id"
	delete_item "$table_name" "$id"
	put_item "$table_name" "$id"

	# Clean up the downloaded file
	rm -f $id.json
}

main "$@"
