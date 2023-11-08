#!/bin/bash
# List all queries in error status since a specified date

API_URL=https://dumpy-api.prod.nvirginia.delivery.ravenpack.com

if [ -z "$1" ]
then
  echo "Usage: $0 <datafile_id>"
  exit 1
fi

curl -X 'PUT' \
  "https://dumpy-api.prod.nvirginia.delivery.ravenpack.com/datafiles/$1/status" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H "api_key: $RP_API_KEY" \
  -d '{"status": "ENQUEUED"}'
