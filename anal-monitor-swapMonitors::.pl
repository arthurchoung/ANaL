#!/usr/bin/perl

$matchName1 = shift @ARGV;
$matchName2 = shift @ARGV;
if (not $matchName1 or not $matchName2) {
    die('specify matchName1 and matchName2');
}

if ($matchName1 eq $matchName2) {
    die('matchName1 and matchName2 are the same');
}

$baseDir = __FILE__;
$baseDir =~ s/[^\/]*$//g;
if ($baseDir) {
    chdir $baseDir;
}

system("cat Temp/listMonitors.txt | anal-monitor-modifyToSwapMonitors::.pl $matchName1 $matchName2 >Temp/monitors.txt");

system('anal-monitor-setupMonitors.pl');

