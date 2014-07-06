#!/bin/bash

# This script will tell you, in a roundabout way,
# whether your OS is named after a cat.

os_dot_version=$(sw_vers -productVersion | awk -F. '{print $2}')

if [ "$os_dot_version" -gt 8 ]; then
    echo "I don't like cats."
else
    echo "I don't go outside much."
    echo "Maybe I should get a cat."
fi
