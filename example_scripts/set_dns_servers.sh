#!/bin/bash

# This script will change the dns servers on the primary network interface
# to those supplied on the command line.

mainInt=$(networksetup -listnetworkserviceorder | awk -F'\\) ' '/\(1\)/ {print $2}')

# The $* built-in variable is a list of all supplied arguments
dns_servers="$*"

# note that I am *not* quoting $dns_servers since I want them
# to be passed as separate arguments
networksetup -setdnsservers "$mainInt" $dns_servers
