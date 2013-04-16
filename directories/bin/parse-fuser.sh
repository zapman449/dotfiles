#!/bin/bash

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
                                     sed -e 's/[cefFrm]//g' \
                                         -e 's/^  *//' \
                                         -e 's/  */|/g' \
                                         -e 's/^/(/' \
                                         -e 's/$/)/'`
ps -ef | egrep " $pidlist "

