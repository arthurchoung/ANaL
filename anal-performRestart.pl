#!/usr/bin/perl

$result = `anal confirm Restart Cancel 'Restart?'`;
chomp $result;

if ($result eq 'Restart') {
    system("sudo -A reboot");
}

