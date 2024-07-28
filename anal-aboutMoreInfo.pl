#!/usr/bin/perl

$output = `sudo -A dmidecode --type 17`;
@lines = split "\n", $output;

@results = ();

$dict = undef;

foreach $line (@lines) {
    if ($line =~ m/^Memory Device/) {
        if ($dict) {
            push @results, $dict;
        }
        $dict = {};
    } elsif ($line =~ m/^\s+Size: (.+)/) {
        $dict->{'size'} = $1;
    } elsif ($line =~ m/^\s+Form Factor: (.+)/) {
        $dict->{'formFactor'} = $1;
    } elsif ($line =~ m/^\s+Locator: (.+)/) {
        $dict->{'locator'} = $1;
    } elsif ($line =~ m/^\s+Type: (.+)/) {
        $dict->{'type'} = $1;
    } elsif ($line =~ m/^\s+Type Detail: (.+)/) {
        $dict->{'typeDetail'} = $1;
    } elsif ($line =~ m/^\s+Speed: (.+)/) {
        $dict->{'speed'} = $1;
    } elsif ($line =~ m/^\s+Manufacturer: (.+)/) {
        $dict->{'manufacturer'} = $1;
    } elsif ($line =~ m/^\s+Serial Number: (.+)/) {
        $dict->{'serialNumber'} = $1;
    } elsif ($line =~ m/^\s+Asset Tag: (.+)/) {
        $dict->{'assetTag'} = $1;
    } elsif ($line =~ m/^\s+Part Number: (.+)/) {
        $partNumber = $1;
        $partNumber =~ s/\s+$//;
        $dict->{'partNumber'} = $partNumber;
    } elsif ($line =~ m/^\s+Configured Memory Speed: (.+)/) {
        $dict->{'configuredMemorySpeed'} = $1;
    }
}

push @results, $dict;

print <<EOF;
Memory:

EOF

@results = sort { $a->{'locator'} cmp $b->{'locator'} } @results;
foreach $elt (@results) {
    print <<EOF;
Slot: $elt->{'locator'}
    Size: $elt->{'size'}
    Type: $elt->{'type'}
    Speed: $elt->{'speed'}
    Manufacturer: $elt->{'manufacturer'}
    Asset Tag: $elt->{'assetTag'}
    Part Number: $elt->{'partNumber'}

EOF
}

