#!/usr/bin/perl

$path = shift @ARGV;
if (not $path) {
    die('specify file');
}

system
    'mpv',
    '--hwdec=auto',
    '--force-window=yes',
    '--volume-max=200',
    $path;

