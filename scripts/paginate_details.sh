#! /usr/bin/bash

set -euo pipefail

echo "Getting pagination data from content details."

# get the cursor value and total so
# the loop can be run for all the papers
metadata=$(jq -r '.messages[]? | { cursor, total }' "$(pwd)/raw/content_details.json")

declare -A meta_values=()

# see https://github.com/jqlang/jq/issues/1271 for context on this approach
while IFS= read -r -d '' key && IFS= read -r -d '' value; do
  meta_values[$key]=$value
done < <(jq -j 'to_entries[] | (.key, "\u0000", .value, "\u0000")' <<<"$metadata")

echo "Cursor positioned at: ${meta_values[cursor]}; total: ${meta_values[total]}"

cursor=${meta_values[cursor]}

total=${meta_values[total]}

base_url="https://api.biorxiv.org/details/biorxiv"

while [ "$cursor" -lt "$total" ]
do
  date="2013-11-01/$(date -I)"
  if [[ $((cursor % 1000)) == 0 ]]; then echo "Cursor at $cursor of $total"; fi
  printf  "%s/%s/%s\n" "$base_url" "$date" "$cursor" >> "$(pwd)/raw/urls.txt"
  cursor=$((cursor + 100))
done
