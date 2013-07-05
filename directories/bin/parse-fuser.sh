#!/bin/bash

# fuser -m produces very usefil output, but it's a right pain to parse usefully.
# This cleans up the output, takes away the character codes, and shows you the ps
# output for each process which is running against the given mountpoint

# cut removes the "<mount>:" stuff
# sed1 cuts the characters off of the pids produced by fuser
# sed2 kills all leading spaces
# sed3 removes all spaces, and replaces groups of them with a single |
# sed4 adds a leading '('
# sed5 adds a trailing ')'

if [ ! -d "$1" ]; then
    echo "USAGE: $0 <mountpoint>"
fi

pidlist=`fuser -m $1 2>&1 | cut -f 2- -d ":" | \
                                     sed -e 's/[cefFmr]//g' \
                                         -e 's/^  *//' \
                                         -e 's/  */|/g' \
                                         -e 's/^/(/' \
                                         -e 's/$/)/'`
ps -ef | egrep " $pidlist "
# The spaces around $pidlist ensure that process 2 doesn't match process 22, etc

