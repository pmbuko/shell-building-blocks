#!/bin/bash

####################
# This script is a simple mad lib generator. It can run
# interactively -- in which case it will prompt for a name,
# a number, and a body part -- or you can supply a name,
# a number, and a body part as three arguments when running
# the script from the command line.
####################

# Check if arguments were supplied at the command line
# If four were supplied, save them as named variables
if [ "$#" -eq 4 ]; then
  name=$1
  number=$2
  color=$3
  part=$4

# if something other than three were supplied, give help.
elif [ "$#" -gt 0 ]; then
  echo "You must supply exactly four arguments:"
  echo "  1: your name"
  echo "  2: a number (in digit form)"
  echo "  3: a color"
  echo "  4: a body part (singular)"
  exit 1

# if no arguments were supplied, run interactively
else
  clear
  echo ""
  echo "Welcome to Silly MadLib Generator!"
  echo "----------------------------------"
  echo ""
  
  # prompt for a name and save user input as $name
  echo -n "Please supply your name: "
  read name
  
  # prompt for a number
  echo -n "Please supply a number (digit form): "
  read number

  # prompt for body part
  echo -n "Please supply a color: "
  read color

  # prompt for body part
  echo -n "Please supply a body part (singular form): "
  read part
fi

# pluralize the body part if the user-supplied number is not 1.
if [ "$number" != 1 ]; then
  part="${part}s"
fi

# Generate the silly sentence.
echo ""
echo "Hello. My name is ${name}. I have ${number} ${color} ${part}, but I hope someday to have more."
echo ""
