#!/usr/bin/perl

$key = shift @ARGV;
if (not $key) {
    die("specify key");
}

@lines = <STDIN>;

@lines = sort {
    $vala = 0.0;
    if ($a =~ m/\b$key:([\-\d\.]+)/) {
        $vala = $1;
    }
    $valb = 0.0;
    if ($b =~ m/\b$key:([\-\d\.]+)/) {
        $valb = $1;
    }
    $valb <=> $vala;
} @lines;

foreach $elt (@lines) {
    print $elt;
}

