#! /usr/bin/awk

$9 ~ /^[0-9]+$/ {print "download/" $9; print "download/" $9 "_content_details.json"}