#!/usr/bin/perl

use JSON;

sub asQuotedString
{
    my ($str) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\"/\\\"/g;
    return '"' . $str . '"';
}

sub dhcpcdIsRunning
{
    my ($arg) = @_;
    return `pgrep -f 'dhcpcd.*$arg'`;
}

$output = `ip -j -p address`;
$result = decode_json($output);
foreach $elt (@$result) {
    if (grep /^UP$/, @{$elt->{'flags'}}) {
        $elt->{'up'} = '1';
    } else {
        $elt->{'up'} = '0';
    }
    if (grep /^LOWER_UP$/, @{$elt->{'flags'}}) {
        $elt->{'lowerUp'} = '1';
    } else {
        $elt->{'lowerUp'} = '0';
    }
    $address = '';
    foreach $addrelt (@{$elt->{'addr_info'}}) {
        if ($addrelt->{'family'} eq 'inet') {
            $address = $addrelt->{'local'};
            last;
        }
    }
    $elt->{'dhcpcdIsRunning'} = '0';
    if ($elt->{'ifname'}) {
        if (dhcpcdIsRunning($elt->{'ifname'})) {
            $elt->{'dhcpcdIsRunning'} = '1';
        }
    }
    print "interface:$elt->{'ifname'} type:$elt->{'link_type'} up:$elt->{'up'} lowerUp:$elt->{'lowerUp'} operstate:$elt->{'operstate'} address:$address dhcpIsRunning:$elt->{'dhcpcdIsRunning'}\n";
}

