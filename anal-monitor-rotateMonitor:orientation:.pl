#!/usr/bin/perl

$matchName = shift @ARGV;
$orientation = shift @ARGV;
if (not $matchName or not $orientation) {
    die('specify matchName and orientation');
}

$baseDir = __FILE__;
$baseDir =~ s/[^\/]*$//g;
if ($baseDir) {
    chdir $baseDir;
}

system("cat Temp/listMonitors.txt | anal-monitor-modifyToRotateMonitor:orientation:.pl $matchName $orientation >Temp/monitors.txt");

system('anal-monitor-setupMonitors.pl');

