#!/usr/bin/perl

$matchName1 = shift @ARGV;
$matchName2 = shift @ARGV;
if (not $matchName1 or not $matchName2) {
    while ($line = <STDIN>) {
        print $line;
    }
    exit 0;
}

if ($matchName1 eq $matchName2) {
    while ($line = <STDIN>) {
        print $line;
    }
    exit 0;
}

@lines = <STDIN>;
chomp @lines;

$matchLine1 = undef;
$matchLine2 = undef;

foreach $line (@lines) {
    $name = undef;
    next if ($line !~ m/\boutput:([^\s]+)/);
    $name = $1;
    if ($name eq $matchName1) {
        $matchLine1 = $line;
    }
    if ($name eq $matchName2) {
        $matchLine2 = $line;
    }
}

if ($matchLine1 and $matchLine2) {
    foreach $line (@lines) {
        if ($line eq $matchLine1) {
            print <<EOF;
$matchLine2
EOF
        } elsif ($line eq $matchLine2) {
            print <<EOF;
$matchLine1
EOF
        } else {
            print <<EOF;
$line
EOF
        }
    }
} else {
    foreach $line (@lines) {
        print <<EOF;
$line
EOF
    }
    if (not $matchLine1) {
        print <<EOF;
output:$matchName1 rotate:normal
EOF
    }
    if (not $matchLine2) {
        print <<EOF;
output:$matchName2 rotate:normal
EOF
    }
}

