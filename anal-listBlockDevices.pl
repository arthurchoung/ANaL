#!/usr/bin/perl

#$output = `blkid`;
#@lines = split "\n", $output;
#foreach $line (@lines) {
#    $device = undef;
#    if ($line =~ m/^([^:]+):/) {
#        $device = $1;
#    }
#    $type = undef;
#    if ($line =~ m/TYPE=\"([^\"]+)\"/) {
#        $type = $1;
#    }
#    $label = undef;
#    if ($line =~ m/LABEL=\"([^\"]+)\"/) {
#        $label = $1;
#    }
#    print "device:$device type:$type label:$label\n";
#}

use JSON;

@keys = ('type', 'fstype', 'size', 'mountpoint', 'label', 'vendor', 'model');

$output = `lsblk --json -l -p -o PATH,TYPE,FSTYPE,SIZE,MOUNTPOINT,LABEL,VENDOR,MODEL`;
$result = decode_json($output);
$blockdevices = $result->{'blockdevices'};
foreach $elt (@$blockdevices) {
    $path = $elt->{'path'};
    $path =~ s/([%\s])/sprintf '%%%02x', ord $1/eg;
    @arr = map {
        $key = $_;
        $val = $elt->{$key};
        $val =~ s/([%\s])/sprintf '%%%02x', ord $1/eg;
        "$key:$val"
    } @keys;
    $str = join ' ', @arr;
    print "device:$elt->{path} $str\n";
}
