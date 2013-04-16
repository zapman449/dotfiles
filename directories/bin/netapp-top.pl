#!/usr/bin/perl

# netapp-top - display current top NFS clients for a NetApp
# Copyright (C) 1998 Daniel Quinlan
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

$default_interval = 60;
$prog = $0;
$prog =~ s@.*/@@;

require "getopts.pl";
&Getopts("hi:");

if (defined $ENV{"LINES"} && $ENV{"LINES"} ne "") {
    $lines = $ENV{"LINES"};
}
else {
    $lines = 24;
}

if ($opt_h) {
    &usage;
    exit 0;
}
if ($opt_i && $opt_i > 0) {
    $interval = $opt_i;
}
else {
    $interval = $default_interval;
}

if ($ARGV[0]) {
    $host = $ARGV[0];
}
    else {
    &usage;
    exit 1;
}

sub usage {
    print <<EOF;
usage: $prog [options] filer
-h print this help
-i n report filer statistics every n seconds ($default_interval 
is default)

* "options nfs.per_client_stats.enable" should be "on".
* You should have "rsh" access to the filer.

EOF
}

sub print_top {
    my $total = 0;
    my $diff;
    my %recent;

    foreach $key (keys %nfs_ops_last) {
        $diff = $nfs_ops{$key} - $nfs_ops_last{$key};
    $recent{$key} = $diff;
    $total += $diff;
    }
    $total = int ($total / $interval);
    system("clear");
    printf "%6s\t%s\n", "NFS/s",
"total NFS/s = $total | interval = $interval";
    printf "%6s\t%s\n", "------", "----------------------------------------";
    $i = 0;
    foreach $key (sort {$recent{$b} <=> $recent{$a} } keys %recent) {
        printf "%6d\t%s\n", int ($recent{$key} / $interval + 0.5),
        $ip_name{$key};
        last if ($i++ > ($lines - 5));
    }
}

$first = 1;
for (;;) {
    $time_0 = time();
    #open(NFSSTAT, "rsh $host nfsstat -l|");
    open(NFSSTAT, "ssh $host nfsstat -l|");
    while (<NFSSTAT>) {
        @tmp = split;

        # ip_address = tmp[0]
        # ip_name = tmp[1]
        # nfs_ops = tmp[4]

        # if hostname is "<hostname unknown>", we have two words,...
        if($tmp[1] eq "<hostname") {
            $ip_name{$tmp[0]} = $tmp[0];
            $nfs_ops{$tmp[0]} = $tmp[5];
        }
        else {
            $ip_name{$tmp[0]} = $tmp[1];
            $nfs_ops{$tmp[0]} = $tmp[4];
        }
 
    }
    close(NFSSTAT);
    if (! $first) {
        &print_top;
    }
    else {
        $first = 0;
    }
    %nfs_ops_last = %nfs_ops;
    $time_1 = time();
    if((($time_1 - $time_0) > 1) && (($interval - ($time_1 - $time_0)) >= 0)) {
        sleep ($interval - ($time_1 - $time_0)); 
    }
    else {
        sleep ($interval);
    }
}
