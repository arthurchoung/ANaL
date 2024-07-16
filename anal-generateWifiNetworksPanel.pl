#!/usr/bin/perl

@lines = `sudo -A anal-scanNetworks.pl | anal-reverseNumericSortForKey:.pl quality`;
chomp @lines;

print <<EOF;
panelStripedBackground
panelText:'Wireless Networks'
panelText:''
panelText:'Choose a network ESSID:'
panelText:''
EOF

$count = scalar @lines;
for ($i=0; $i<$count; $i++) {
    $line = $lines[$i];
    $essid = '';
    $quality = '';
    $encryption = '';
    if ($line =~ m/\bessid:([^\s]+)/) {
        $essid = $1;
#$essid = "'$essid'";
        $essid =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/eg;
        $essid =~ s/\\/\\\\/g;
        $essid =~ s/'/\\'/g;
    }
    if ($line =~ m/\bquality:([^\s]+)/) {
        $quality = $1;
    }
    if ($line =~ m/\bencryption:([a-zA-Z]+)/) {
	$encryption = $1;
    }
    $button = 'panelMiddleButton';
    if ($i == 0) {
	    $button = 'panelTopButton';
	} elsif ($i == $count-1) {
		$button = 'panelBottomButton';
	}
    $outputline = $line;
    $outputline =~ s/(['])/sprintf '%%%02x', ord $1/eg;
    print <<EOF;
$button:'$essid [$quality/70] encryption:$encryption' message:['$outputline'|writeToStandardOutput;exit:0]
EOF
}

