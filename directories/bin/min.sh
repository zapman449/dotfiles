#!/bin/bash

let counter=0
#min=

while read line ; do
    if [ -z "$min" ]; then
        let min=$line
    else
        if [ "$line" -lt "$min" ]; then
            let min=$line
        fi
    fi
done

echo $min
