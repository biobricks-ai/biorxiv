#!/usr/bin/env bash

# causes script to fail on any
# command returning non-zero exit (-e)
# or undefined variables (-u)
set -euxo pipefail

# 1. get summary statistics from bioxriv API
# curl https://bioxriv.org/sum/m -w "%{json}" 
summary_stats=$(curl https://api.biorxiv.org/sum/m -w "%{json}" |
  jq '[."bioRxiv content statistics"[]?.new_papers_cumulative] | add' | head -n1) 
cat << EOF
 BioRxiv summary stats:
 New articles: $summary_stats 
EOF
# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Create the download directory
export downloadpath="$localpath/download"
echo "Download path: $downloadpath"
if [[ ! -d $downloadpath ]]; then mkdir -p "$downloadpath"; fi
# cd "$downloadpath";

