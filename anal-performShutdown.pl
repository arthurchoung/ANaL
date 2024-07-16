#!/usr/bin/perl

$result = `anal confirm Shutdown Cancel 'Shutdown?'`;
chomp $result;

if ($result eq 'Shutdown') {
    system("sudo -A poweroff");
}

