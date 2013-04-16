#!/usr/bin/python

import fileinput

for line in fileinput.input() :
    uline = line.strip()
    counter = 0
    a = []
    for c in uline :
        if counter == 2 :
            counter = 0
            a.append(':')
        a.append(c)
        counter += 1
    print ''.join(a)
