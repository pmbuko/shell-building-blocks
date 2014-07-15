#!/bin/bash

####################
# This script will delete all local home directories and
# associated users *except* for those specified in the
# KEEPERS array. The "dangerous" commands are commented out,
# so uncomment lines 32 and 33 after testing.
#
# In this version, the keepers array is populated from the command line
####################

# Check if running as root
if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

# define users to keep in an array, with spaces between items
KEEPERS=( $@ )

# iterate through list of folders in /Users
for folder in /Users/*; do
    # remove the "/Users/" portion of the path for easier testing
    user=$(basename "${folder}")
    # compare folder name against the array items
    if [[ "${KEEPERS[*]}" =~ ${user} ]]; then
        # skip if folder is in the skip array
        echo "Skipping ${user}..."
    else
        # proceed with removal
        echo "Removing ${user}..."
        #dscl . -delete "/Users/${user}"
        #rm -rf "/Users/${user}"
    fi
done
