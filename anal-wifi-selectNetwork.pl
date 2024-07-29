#!/usr/bin/perl

$baseDir = `anal configDir`;
chomp $baseDir;
chdir $baseDir;

$interface = shift @ARGV;
if (not $interface) {
    die('specify interface');
}

system('sudo', '-A', 'ifconfig', $interface, 'up');

$choice = `anal-wifi-generatePanel.pl | anal show WifiNetworksPanel`;
chomp $choice;
if (not $choice) {
exit 0;
}

if ($choice !~ m/\bessid:(\S+)/) {
    die('essid not found');
}
$essid = $1;
$essid =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/eg;

if ($choice =~ m/\bencryption:on/) {
    $password = '';
    $passwordFile = 'Temp/wifiPasswords.txt';
    if (-e $passwordFile) {
        @arr = ('anal', 'radio', 'OK', 'Cancel', qq{"What's the password?"});
        @lines = `cat $passwordFile`;
        chomp @lines;
        $default = '1';
        $key = '';
        $val = '';
        $match = 0;
        $count = scalar @lines;
        for ($i=0; $i<$count; $i++) {
            $elt = $lines[$i];
            if ($elt =~ m/^=([^=]+)=(.+)/) {
                $key = $1;
                $val = $2;
            } else {
                next;
            }
            if ($key eq 'essid') {
                if ($val eq $essid) {
                    $match = 1;
                } else {
                    $match = 0;
                }
            } elsif ($key eq 'password') {
                if ($match) {
                    $val =~ s/([\"\\])/\\$1/g;
                    push @arr, $i, $default, qq{"$val"};
                    $default = '0';
                }
            }
        }
        if ($default ne '1') {
            push @arr, 'new', $default, '"Enter New Password"';
            $cmd = join ' ', @arr;
            $result = `$cmd`;
            chomp $result;
            if ($result eq 'new') {
            } elsif ($result > 0) {
                if ($lines[$result] =~ m/^=([^=]+)=(.+)/) {
                    $password = $2;
                }
            } else {
                exit 0;
            }
        }
    }
    if ($password eq '') {
        $password = `anal input OK Cancel 'Enter wifi password:'`;
        chomp $password;
        if ($password ne '') {
            if (open(FH, ">>$passwordFile")) {
                print FH "=essid=$essid\n";
                print FH "=password=$password\n";
                close(FH);
            }
        }
    }
    if ($password ne '') {
        system('anal-wifi-runWPASupplicantForInterface:essid:password:.pl', $interface, $essid, $password);
    }
} else {
    system('sudo', '-A', 'iwconfig', $interface, 'essid', $essid);
}

