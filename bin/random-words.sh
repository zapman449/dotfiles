#!/bin/bash

set -euo pipefail

WORDFILE=/usr/share/dict/words
lines=$(cat $WORDFILE  | wc -l)

for x in 1 2 3 4 5 ; do
    # seed random from /dev/urandom
    RANDOM=$(od -vAn -N4 -t u4 < /dev/urandom)
    rnum=$((RANDOM*RANDOM%$lines+1))
    w=$(sed -n "$rnum p" $WORDFILE)
    echo -n "${w} "
done

echo
