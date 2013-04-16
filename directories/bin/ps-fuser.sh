#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

if [ ! -d "$1" ]; then
    echo "USAGE: $0 <mountpoint>"
    exit
fi

ps -ef | egrep $( fuser -m $1 2>&1 | \
                        sed -e "s/^[^ ][^ ]*  *//" \
                            -e 's/[mce]//g' \
                            -e "s/  */|/g" )

# the first sed regexp kills the "/mountpoint:      " that preceeds the numbers.
# the second sed regexp kills the characters that may come after each number.
# the third sed regexp replaces 1 or more space with '|' to be the regexp delimiter
#     passed to egrep.

