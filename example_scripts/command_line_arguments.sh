#!/bin/bash

arguments="$*"

count=0
for item in $arguments; do
  (( count++ ))
  echo "$count: $item"
done
if [ "$count" -eq 0 ]; then
  echo "$count"
fi
