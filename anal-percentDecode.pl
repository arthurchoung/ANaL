#!/usr/bin/perl

while ($line = <STDIN>) {
    chomp $line;
    $line =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/eg;
    print "$line\n";
}

