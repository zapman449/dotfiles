#!/bin/sh

let counter=0
let sum=0

while read line ; do
    let counter++
    let sum=$sum+$line
done

let result=$sum/$counter

echo $result
