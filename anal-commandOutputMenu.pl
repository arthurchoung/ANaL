#!/usr/bin/perl

if (not scalar @ARGV) {
    die('specify command');
}

$cmd = join ' ', @ARGV;

@output = `$cmd`;
chomp @output;

foreach $elt (@output) {
    $elt =~ s/\t/ /g;
    $elt =~ s/[^[:ascii:]]//g;
    if (not $elt) {
        $elt = ' ';
    }
    print <<EOF;
=cmd=$cmd
=displayName=$elt
=messageForClick=NSArray|addObject:'anal-handleCommandOutputMenu:line:.pl'|addObject:cmd|addObject:displayName|runCommandInBackground
==
EOF
}

