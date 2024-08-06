#! /usr/bin/bash

set -euxo pipefail

downloadpath="$(pwd)/download"

# get all the numerically-designated JSON files in the directory
function get_raw_files() {
  ls -la "$1" | awk -f "$(pwd)/download/change_filenames.awk"
}

# rename them so they have a JSON extension (housekeeping)
function batch_rename() {
  get_raw_files "$downloadpath" | xargs -n2 mv
}

function get_dois() {
  find . -type f -name "*.json" \
    -exec jq -c -f "$(pwd)/download/get_dois.jq" {} \; >> dois.jsonl
}

echo "Renaming files"
batch_rename

echo "Filtering JSON"
get_dois
