#!/bin/bash

# This returns a numbered list of fruits

# multiline list
fruits="apple
banana
cantaloupe
durian"

# start the count at zero
count=0

# loop over each fruit in the list
for fruit in $fruits; do
  # increment the count
  (( count++ ))
  #return the curent count and the current fruit
  echo "${count}: $fruit"
done
