#!/usr/bin/python

"""
Program to write out a histagram-ish thing of IO.  Think top for IO consumption.
0) trap ctrl-C, cleanup then exit
1) record state of /proc/sys/vm/block_dump
2) set it to 1 if it's zero
3) loop over 'dmesg -c' every n seconds (command line arg?)
    a) procdesc(pid): READ|WRITE block|inode #### on <device>
    b) aggregate into pid key'ed dictionary with values of 
       procdesc, read, write, devlist
    c) print sorted list by total of read-write
4) revert state of /proc/sys/vm/block_dump
"""

import sys
import subprocess
import time

config = {}

def parse_cli() :
    #if len(sys.argv) == 1 :
    config['interval'] = 5

#bash(17460): READ block 37623320 on dm-0
#oracle(8619): READ block 4736840 on VxVM3822
#oracle(8619): WRITE block 137547 on VxVM3822
#bash(17460): READ block 39159936 on dm-0
#bash(17460): READ block 27536080 on dm-0

def proccompare(p1, p2) :
    if p1[1][2] == p2[1][2] :
        return 0
    if p1[1][2] > p2[1][2] :
        return 1
    if p1[1][2] < p2[1][2] :
        return -1

def main() :
    """ main controll loop"""
    while True :
        data = {}
        dmesg = subprocess.Popen(["dmesg", "-c"], stdout=subprocess.PIPE)
        output = dmesg.communicate()[0]
        for l in output.splitlines() :
            words = l.split()
            if len(words) >= 2 and words[1] in ('READ', 'WRITE') :
                # words[0] looks like 'bash(12345):'. Rip out the last 2 chars,
                # replace the '(' with a space, resplit, and put in place of
                # words[0].
                # now words[0:1] is ['bash', '12345']
                words[0:1] = words[0][:-2].replace('(', ' ').split()
                procdesc = words[0]
                pid = words[1]
                RW = words[2]
                dev = words[6]
                data.setdefault(pid, [procdesc, pid, 0, 0, 0, []])
                data[pid][2] += 1   # set total + 1
                if RW == 'READ' :
                    data[pid][3] += 1   #set read + 1
                else :
                    data[pid][4] += 1   # set write + 1
                if dev not in data[pid][5] :
                    data[pid][5].append(dev)
        #print results:
        max_lines=20
        counter = 0
        print "%-15s %-5s %-7s %-7s %-7s %s" % ('TASK', 'PID', 'TOTAL', 
                                                'READ', 'WRITE', "DEVICES")
        for proc in sorted(data.iteritems(), cmp=proccompare, reverse=True) :
            counter += 1
            if counter >= max_lines :
                break
            if len(proc[1]) != 6 :
                print 'DEBUG', repr(proc[1])
                continue
            resu = "%-15s %-5s %-7s %-7s %-7s" % ( proc[1][0], proc[1][1],
                                                   proc[1][2], proc[1][3],
                                                   proc[1][4] )
            for d in proc[1][5] :
                resu += d + ' '
            print resu
        print 
        time.sleep(config['interval'])

if __name__ == "__main__" :
    parse_cli()
    bd = open('/proc/sys/vm/block_dump', 'r')
    orig_dump = bd.readline().strip()
    bd.close()
    if orig_dump == '0' :
        bd = open('/proc/sys/vm/block_dump', 'w')
        bd.write('1\n')
        bd.close()
    try :
        main()
    except :
        if orig_dump == '0' :
            bd = open('/proc/sys/vm/block_dump', 'w')
            bd.write(orig_dump + '\n')
            bd.close()
    sys.exit()
