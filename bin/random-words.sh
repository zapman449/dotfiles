#!/bin/bash

set -euo pipefail

function USAGE {
    echo "usage: random-words.sh [words-per-line<=100] [lines<=50]" >&2
    exit 1
}

count="${1:-5}"
lines="${2:-1}"

wordfile="${WORDFILE:-/usr/share/dict/words}"

if ! [[ "$count" =~ ^[0-9]+$ ]] || (( count < 1 || count > 100 )); then
    USAGE
elif ! [[ "$lines" =~ ^[0-9]+$ ]] || (( lines < 1 || lines > 50 )); then
    USAGE
fi

pool=$(LC_ALL=C grep -xE '[a-z]{4,16}' "$wordfile")
[[ -n "$pool" ]] || { echo "no usable words in $wordfile" >&2; exit 1; }

# note: this relies on gnu-shuf, bsd-shuf doesn't have --random-source
for _ in $(seq 1 "$lines"); do
    printf '%s\n' "$pool" \
        | shuf --random-source=/dev/urandom -n "$count" \
        | paste -sd' ' -
done
