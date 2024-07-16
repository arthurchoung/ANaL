#!/usr/bin/perl

$|=1;

$seconds = shift @ARGV;
if (not $seconds) {
    $seconds = 1;
}
$count = 0;
for(;;) {
    print "$count\n";    
    sleep $seconds;
    $count++;
}

