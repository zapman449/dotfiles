#!/bin/sh

let counter=0
let sum=0

while read line ; do
    let counter++
    let sum=$sum+$line
done

if [ "${1:-x}" = "x" ]; then
    echo $sum
elif [ "${1}" = "T" ]; then
    let result=$sum/1024/1024/1024/1024
    echo $result
elif [ "${1}" = "G" ]; then
    let result=$sum/1024/1024/1024
    echo $result
elif [ "${1}" = "M" ]; then
    let result=$sum/1024/1024
    echo $result
fi
