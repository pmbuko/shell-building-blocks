#!/bin/bash

####################
# This script shows how you might use the select and case bash functions
# to create a program with a menu or multiple-choice options. This is one
# way to avoid having to verify user input because you're only providing
# valid options for them to choose from.
####################

# Print the question that you need answered.
echo "Are you sure you want to answer this question? (choose a number)"

# Use select to capture their choice in a variable
select yn in "Yes" "No" "Not sure"; do
  # Use case to specify what action(s) to take for each option.
  case $yn in
    Yes )        echo "I knew you were ready."
                 # add more code here
                 break # exits the select loop
                 ;; # each case option is terminated by double semicolons
    No )         echo "And to think I believed in you."
                 # add more code here
                 break
                 ;;
    "Not sure" ) echo "Of course you're not."
                 # add more code here
                 break
                 ;;
    *)           echo "That's not a valid option, you nitwit."
                 # no break here, since I want the select prompt to return
                 ;;
  esac
done

# code that you want to run regardless of above choices would go here
