#!/bin/bash

if [ -n "$2" ]; then
    #echo 'x'
    IFACE=$1
    SIZE=$2
elif [ -n "$1"]; then
    IFACE=$1
    SIZE='m'
else
    #echo 'z'
    IFACE='eth0'
    SIZE='m'
fi

if [ -z "$IFACE" ]; then
    IFACE='eth0'
fi

while true ; do 
    ifconfig $IFACE | grep bytes | sed 's/:/ /g' | awk '{print $3, $8}'
    sleep 1
done | python ./get_traffic.py $SIZE
#done
