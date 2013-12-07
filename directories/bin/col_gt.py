#!/usr/bin/python

"""
Look for column named similar to sys.argv[1].  Filter that column based on
metric of 10, or sys.argv[2] if defined.
Tuned for SAR output, but probably is generic enough for others as well.
"""

import fileinput
import sys

if len(sys.argv) == 2 :
    colname = sys.argv[1]
    metric = 10
    del(sys.argv[1])
elif len(sys.argv) == 3 :
    colname = sys.argv[1]
    metric = float(sys.argv[2])
    del(sys.argv[2])
    del(sys.argv[1])
else :
    print "USAGE: \n %s <column_heading> [test value]" % sys.argv[0]
    sys.exit(1)

first_header = True
for line in fileinput.input() :
    if len(line) < 5 :
        continue
    uline = line.strip()
    words = uline.split()
    #print 'debug: words:', repr(words)
    if colname in line :
        if first_header :
            print uline
            first_header = False
        idx = -1
        for index,val in enumerate(words) :
            #print 'debug index is', index, 'val is', val, 'colname is', colname
	    if colname in val :
	        idx = index
                break
	if idx < 0 :
	    print 'error: keyword not found'
	    sys.exit(1)
        continue
    try :
        num = float(words[idx])
    except IndexError :
        continue
    except NameError :
        continue # idx isn't defined yet. continue
    if num > metric :
        print uline
