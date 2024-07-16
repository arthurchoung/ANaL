#!/usr/bin/perl

$w = 0;
$h = 0;
$monitorX = 0;
$monitorWidth = 0;
$monitorHeight = 0;
$focusX = 0;
$focusY = 0;
$focusMonitorX = 0;
$focusMonitorY = 0;
$focusMonitorWidth = 0;
$focusMonitorHeight = 0;

foreach $arg (@ARGV) {
    if ($arg =~ m/^([a-zA-Z]+):([0-9]+)/) {
        $key = $1;
        $val = $2;
        if (defined($$key)) {
            $$key = int($val);
        }
    }
}

# cascade from focus window
#$newX = $focusX + 20;
#$newY = $focusY + 40;
#if ($newX + $w < $focusMonitorX + $focusMonitorWidth) {
#    if ($newY + $h < $focusMonitorY + $focusMonitorHeight - 20) {
#        print "x:$newX y:$newY\n";
#        exit 0;
#    }
#}

# random placement
if ($w && $h && ($monitorWidth > $w) && ($monitorHeight - 20 > $h)) {
    $rangeX = $monitorWidth - $w;
    $rangeY = $monitorHeight - 20 - $h;

    $x = $monitorX + int(rand($rangeX));
    $y = 20 + int(rand($rangeY));
    print "x:$x y:$y\n";
    exit 0;
}

# centered
#if ($w && $h && ($monitorWidth > $w) && ($monitorHeight - 20 > $h)) {
#    $rangeX = $monitorWidth - $w;
#    $rangeY = $monitorHeight - 20 - $h;
#
#    $x = $monitorX + int($rangeX/2);
#    $y = 20 + int($rangeY/2);
#    print "x:$x y:$y\n";
#    exit 0;
#}

# top left corner
print "x:$monitorX y:0\n";

