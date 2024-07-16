#!/usr/bin/perl

my $matchKey = shift @ARGV;
if (not $matchKey) {
    die("no key specified");
}

while ($line = <STDIN>) {
    chomp $line;
    @elts = split /\s+/, $line;
    foreach $elt (@elts) {
        ($key, $val) = split ':', $elt;
        if ($key eq $matchKey) {
            print "$val\n";
        }
    }
}

