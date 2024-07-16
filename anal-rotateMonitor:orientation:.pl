#!/usr/bin/perl

$matchName = shift @ARGV;
$orientation = shift @ARGV;
if (not $matchName or not $orientation) {
    die('specify matchName and orientation');
}

$baseDir = `anal configDir`;
chomp $baseDir;
chdir $baseDir;

system("cat Temp/listMonitors.txt | anal-modifyToRotateMonitor:orientation:.pl $matchName $orientation >Temp/monitors.txt");

system('anal-setupMonitors.pl');

