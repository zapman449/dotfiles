#!/usr/bin/python

#import fileinput
import sys

prerx = None
pretx = None

if len(sys.argv) > 1 :
    if sys.argv[1] == 'b' :
        divide_by = 1
        name = 'bytes'
    elif sys.argv[1] == 'k' :
        divide_by = 1024
        name = 'kbytes'
    else :
        divide_by = 1024 * 1024
        name = 'mbytes'
else :
    divide_by = 1024 * 1024
    name = 'mbytes'

while 1:
    try :
        line = sys.stdin.readline()
    except  KeyboardInterrupt:
        break
    if not line :
        continue
    #print line
    rx, tx = line.strip().split()
    #print rx, tx
    if prerx == None :
        prerx = rx
        pretx = tx
        continue
    drx = ((int(rx) - int(prerx))) / divide_by
    dtx = ((int(tx) - int(pretx))) / divide_by
    prerx = rx
    pretx = tx
    print 'received %s/sec %d transmit %s/sec %d' % (name, drx, name, dtx)
