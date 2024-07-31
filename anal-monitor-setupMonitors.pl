#!/usr/bin/perl

$baseDir = __FILE__;
$baseDir =~ s/[^\/]*$//g;
if ($baseDir) {
    chdir $baseDir;
}

system('cat Temp/monitors.txt | anal-monitor-generateScriptFromFile.pl | sh');
if (not -d 'Temp') {
    system('mkdir', 'Temp');
    system('chmod', '1777', 'Temp');
}

system('anal-monitor-listMonitors.pl >Temp/listMonitors.txt');

