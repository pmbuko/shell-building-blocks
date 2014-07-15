#!/bin/bash

# This script returns all arguments passed to it
# from the command line as a numbered list.

arguments="$*"

count=0
for item in $arguments; do
  (( count++ ))
  echo "$count: $item"
done
if [ "$count" -eq 0 ]; then
  echo "$count"
fi
