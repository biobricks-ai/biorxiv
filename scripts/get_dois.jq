#! /usr/bin/jq

.collection[] | select(.published != "NA") | {doi, abstract, license}