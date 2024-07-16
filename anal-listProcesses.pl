#!/usr/bin/perl

@lines = `ps auxw`;
chomp @lines;

$line = shift @lines;
@keys = split /\s+/, $line;
$numKeys = scalar @keys;

if (not $numKeys) {
    die('unable to parse header');
}

foreach $key (@keys) {
    $key =~ s/\%/PCT/g;
    $key = lc $key;
    $key =~ s/[^a-z]//g;
}

foreach $line (@lines) {
    @vals = split /\s+/, $line, $numKeys;
    @arr = ();
    for ($i=0; $i<$numKeys; $i++) {
        $val = $vals[$i];
        $val =~ s/([%\s])/sprintf '%%%02x', ord $1/eg;
        push @arr, $keys[$i] . ':' . $val;
    }
    $str = join ' ', @arr;
    print "$str\n";
}

