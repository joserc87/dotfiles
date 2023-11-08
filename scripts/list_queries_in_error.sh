#!/bin/bash
# List all queries in error status since a specified date

API_URL=https://dumpy-api.prod.nvirginia.delivery.ravenpack.com
DATE_START=2023-10-01

curl -X 'GET' \
  "$API_URL/datafiles?status=ERROR&updated_start=${DATE_START}T00%3A00%3A00" \
  -H 'accept: application/json' \
  -H "api_key: $RP_API_KEY" \
  | jq -r '.datafiles[] | (.id + "\t" + .owner + "\t" + .status + "\t" + .lastModified + "\t" + .lastMessage + "\t" + .product)'
