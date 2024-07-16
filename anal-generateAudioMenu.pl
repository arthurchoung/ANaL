#!/usr/bin/perl

$output = `cat /proc/asound/cards`;
@lines = split "\n", $output;
$count = 0;
foreach $line (@lines) {
    if ($line =~ m/^\s*(\d+)[^:]+: (.+)/) {
        $id = "hw:$1";
        $name = $2;
        print <<EOF;
=id=$id
=name=$name
=stringFormat=#{name} (#{id})
=messageForClick=NSArray|addObject:'anal-openALSAPanel.sh'|addObject:id|addObject:name|runCommandInBackground
==
EOF
        $count++;
    }
}

