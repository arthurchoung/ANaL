#!/usr/bin/perl

$HOME = $ENV{'HOME'};

$selectedNum = '';
$selectedName = '';

$asoundrc = `cat "$HOME/.asoundrc"`;
if ($asoundrc =~ m/^#ANaL hw:(\d+)/) {
    $selectedNum = $1;
}

$output = `cat /proc/asound/cards`;
@lines = split "\n", $output;
$count = 0;
foreach $line (@lines) {
    if ($line =~ m/^\s*(\d+)[^:]+: (.+)/) {
        $num = $1;
        $id = "hw:$1";
        $name = $2;
        if ($selectedNum eq $num) {
            $selectedName = $name;
            $name = "* $name";
        } else {
            $name = "  $name";
        }
        print <<EOF;
=id=$id
=name=$name
=stringFormat=#{name} (#{id})
=messageForClick=NSArray|addObject:'anal-alsa-selectDevice.pl'|addObject:'$num'|runCommandInBackground
==
EOF
        $count++;
    }
}

if ($selectedNum =~ m/^\d+$/) {
    print <<EOF;
==
=id=hw:$selectedNum
=name=$selectedName
=displayName=Open Mixer...
=messageForClick=NSArray|addObject:'anal'|addObject:'ALSAPanel::'|addObject:id|addObject:name|runCommandInBackground
==
EOF
}

