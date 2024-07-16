#!/usr/bin/perl

$output = `iwlist scan`;
@lines = split "\n", $output;

$interface = undef;
$quality1 = undef;
$quality2 = undef;
$encryption = undef;
$essid = undef;

foreach $line (@lines) {
    if ($line =~ m/^([a-z0-9]+)\s+Scan completed/) {
        $interface = $1;
        next;
    }
    if ($line =~ m/^\s+Cell (\d+)/) {
        $quality1 = undef;
        $quality2 = undef;
        $encryption = undef;
        $essid = undef;
        next;
    }
    if ($line =~ m/^\s+Quality=(\d+)\/(\d+)/) {
        $quality1 = $1;
        $quality2 = $2;
    }
    if ($line =~ m/^\s+Encryption key:([a-zA-Z]+)/) {
        $encryption = $1;
    }
    if ($line =~ m/^\s+ESSID:\"([^\"]+)\"/) {
        $essid = $1;
        $essid =~ s/([%\s])/sprintf '%%%02x', ord $1/eg;
        $essid =~ s/([^[:print:]])/sprintf '%%%02x', ord $1/eg;
        print "interface:$interface quality:$quality1 encryption:$encryption essid:$essid\n";
        $quality1 = undef;
        $quality2 = undef;
        $encryption = undef;
        $essid = undef;
    }
}

