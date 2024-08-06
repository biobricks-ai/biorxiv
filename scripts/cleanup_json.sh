#! /usr/bin/bash

downloadpath="$(pwd)/download"

# get all the numerically-designated JSON files in the directory
function get_raw_files() {
  ls -la "$1" | awk '{print $9}' | awk '/^[0-9]+$/ {print $1; print $1 "_content_details.json"}' 
}

# rename them so they have a JSON extension (housekeeping)
function batch_rename() {
  get_raw_files "$downloadpath" | xargs -n2 mv
}

function get_dois() {
  find . -type f -name "^[0-9]+_content_details.json" -exec jq '.collection[] | select(.published != "NA") | {doi, abstract, license}' {} \;
}

echo "Renaming files"
batch_rename

echo "Filtering JSON"
get_dois
