#!/usr/bin/perl

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

sleep 1;

system(qq{import "$path"});
if ($? != 0) {
    system('anal', 'alert', "Unable to take screen shot: $?");
    exit 1;
}

system('anal', 'alert', "Screen shot is located at '$path'");

