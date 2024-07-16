#!/usr/bin/perl

$path = shift @ARGV;
if (not $path) {
    die('specify path');
}

$homeDir = $ENV{'HOME'};
if (not $homeDir) {
    $homeDir = '/tmp';
}

$trashDir = $homeDir . '/Trash';
if (not -e $trashDir) {
    mkdir $trashDir;
}
if (not -d $trashDir) {
    $str = "Error, '$trashDir' is not a directory.";
    system('anal', 'alert', $str);
}

$newName = $path;
$newName =~ s/\//_/g;

$newPath = $trashDir . '/' . $newName;
if (-e $newPath) {
    $i = 0;
    for(;;) {
        $testPath = $newPath . '.' . $i;
        if (not -e $testPath) {
            $newPath = $testPath;
            last;
        }
        $i++;
    }
}

if (system('mv', '-n', $path, $newPath) != 0) {
    $str = "Unable to move '$path' to '$newPath'.";
    system('anal', 'alert', $str);
}

