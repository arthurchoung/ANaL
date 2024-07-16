#!/usr/bin/perl

$arg = shift @ARGV;
if (not $arg) {
    die("specify window id");
}

$date = `date "+%Y-%m-%d %H:%M"`;
chomp $date;

$base = "$ENV{'HOME'}/Screenshot $date";
$path = "$base.png";
for ($i=0;;$i++) {
    if (-e $path) {
        $path = "$base-$i.png";
        next;
    }
    last;
}

system(qq{import -frame -window "$arg" "$path"});
if ($? != 0) {
    system('anal', 'alert', 'Unable to take screen shot');
    exit 0;
}

system('anal', 'alert', "Screen shot is located at '$path'");

