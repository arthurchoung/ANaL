#!/usr/bin/perl

$configDir = `anal configDir`;
$timezone = `cat "$configDir/Prefs/timezone.txt"`;
chomp $timezone;

$|=1;

for(;;) {
    $output = `TZ="$timezone" date "+%a %b %d %I:%M:%S %p"`;
    chomp $output;
    print "$output\n";
    sleep 1;
}

