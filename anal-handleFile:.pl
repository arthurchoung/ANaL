#!/usr/bin/perl

$path = shift @ARGV;
if (not $path) {
    die('specify file');
}

system('anal', 'alert', "Supposed to open the file '$path'");

