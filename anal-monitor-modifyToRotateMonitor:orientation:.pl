#!/usr/bin/perl

$matchName = shift @ARGV;
$orientation = shift @ARGV;
if (not $matchName or not $orientation) {
    while ($line = <STDIN>) {
        print $line;
    }
    exit 0;
}

$found = 0;

while ($line = <STDIN>) {
    chomp $line;
    $name = undef;
    next if ($line !~ m/\boutput:([^\s]+)/);
    $name = $1;
    if ($name eq $matchName) {
        $found = 1;
        print <<EOF;
output:$name rotate:$orientation
EOF
    } else {
        print <<EOF;
$line
EOF
    }
}

if (not $found) {
    print <<EOF;
output:$matchName rotate:$orientation
EOF
}

