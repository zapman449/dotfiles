#!/bin/bash

let counter=0
#max=

while read line ; do
    if [ -z "$max" ]; then
        let max=$line
    else
        if [ "$line" -gt "$max" ]; then
            let max=$line
        fi
    fi
done

echo $max
