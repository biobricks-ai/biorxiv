#! /usr/bin/bash

set -euxo pipefail

# define base URL of endpoint
base_url="https://api.biorxiv.org/details"

# define path params
# [server] -- biorxiv (maybe others)
# [interval] -- dates formatted YYYY-MM-DD and separated by /
# [cursor] -- integer (defaults to 0) of where to start in pagination

server="biorxiv"
interval="2013-11-01/$(date -I)" # all the papers from 2013 to today

# make sure directory for json outputs exists
if [[ ! -d "$(pwd)/raw" ]]; then
  echo "Making output directory for raw data at: $(pwd)/raw"
  mkdir "$(pwd)/raw"; 
fi

echo "Sending request to bioRxiv content details API endpoint."
curl "$base_url/$server/$interval" -w "%{json}" --progress-bar | jq '.' > "$(pwd)/raw/content_details.json"
