#!/usr/bin/perl

while ($line = <STDIN>) {
    chomp $line;
    $line =~ s/([%\s])/sprintf '%%%02x', ord $1/eg;
    print "$line\n";
}

