#!/usr/bin/perl

$baseDir = __FILE__;
$baseDir =~ s/[^\/]*$//g;
if ($baseDir) {
    chdir $baseDir;
}

$timezone = `cat Prefs/timezone.txt`;
chomp $timezone;

$|=1;

for(;;) {
    $output = `TZ="$timezone" date "+%a %b %d %I:%M:%S %p"`;
    chomp $output;
    print "$output\n";
    sleep 1;
}

