#!/bin/bash

# Lab-iMac-xy hostname generator, demonstrating nested for loops

# iterate through rows first
for x in 1 2 3; do
  # iterate through letters next
  for y in A B C D E F; do
    # print hostnames
    echo "Lab-iMac-${x}${y}"
  done
done

