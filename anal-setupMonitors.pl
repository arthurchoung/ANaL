#!/usr/bin/perl

$baseDir = `anal configDir`;
chomp $baseDir;
chdir $baseDir;

system('cat Temp/monitors.txt | anal-generateSetupMonitorsScriptFromMonitorsFile.pl | sh');
if (not -d 'Temp') {
    system('mkdir', 'Temp');
    system('chmod', '1777', 'Temp');
}

system('anal-listMonitors.pl >Temp/listMonitors.txt');

