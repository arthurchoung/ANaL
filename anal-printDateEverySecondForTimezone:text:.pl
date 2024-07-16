#!/usr/bin/perl

$|=1;

$timezone = shift @ARGV;
$text = shift @ARGV;
if (not $timezone or not $text) {
    print "Usage: $0 <timezone> <text>\n";
    print "Example: $0 America/Los_Angeles LA\n";
    exit 1;
}

for(;;) {
    $output = `TZ="$timezone" date "+%a %b %d %I:%M:%S %p"`;
    chomp $output;
    print "$text $output\n";
    sleep 1;
}

