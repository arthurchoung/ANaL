#!/usr/bin/perl

$interface = shift @ARGV;
$essid = shift @ARGV;
$password = shift @ARGV;
if (not $interface or not $essid or not $password) {
    die('specify interface, essid, and password');
}

$essid =~ s/\n//g;
$essid =~ s/\\/\\\\/g;
$essid =~ s/"/\\"/g;

$password =~ s/\n//g;
$password =~ s/\\/\\\\/g;
$password =~ s/"/\\"/g;

$baseDir = `anal configDir`;
chomp $baseDir;
chdir $baseDir;

$configFile = "Temp/wpa_supplicant.conf";
open FH, ">$configFile" or die('unable to write file $configFile');

print FH <<EOF;
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=root

network={
    ssid="$essid"
    psk="$password"
}
EOF

close FH;

system('anal', 'prgbox', 'sudo', '-A', 'wpa_supplicant', '-i', $interface, '-c', $configFile);

