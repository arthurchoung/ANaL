#!/usr/bin/perl

$realpath = `realpath .`;
chomp $realpath;
if ($realpath eq '/') {
    $output = `anal-getDiskUsage.pl`;
    chomp $output;
    if ($output =~ m/\bused:([0-9]+)/) {
        print "total:$1\n";
    } else {
        print "total:\n";
    }
    exit 0;
}

$total = undef;

$output = `du -ksc .`;

if ($output =~ m/([0-9]+)\s+total/) {
    $total = $1;
}

print "total:$total\n";

