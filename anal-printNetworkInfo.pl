#!/usr/bin/perl

$|=1;

for(;;) {

    $output = `ifconfig`;
    @lines = split '\n', $output;

    $name = undef;
    $addr = undef;

    foreach $line (@lines) {
        if ($line !~ m/^ /) {
            if ($line =~ m/:/) {
                @tokens = split ':', $line;
                $name = $tokens[0];
                if ($name =~ m/^lo/) {
                    $name = undef;
                }
            }
            next;
        }

        if ($name && ($name ne 'lo') && ($line =~ m/ inet /)) {
            @tokens = split /\s+/, $line;
            $addr = $name . ' ' . $tokens[2];
            next;
        }
    }

    if ($addr) {
        print "$addr\n";
    } else {
        print "ifconfig\n";
    }

    sleep 10;
}
