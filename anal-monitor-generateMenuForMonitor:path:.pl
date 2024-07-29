#!/usr/bin/perl

$arg = shift @ARGV;
if (not $arg) {
    die('specify monitor name');
}

$path = shift @ARGV;
if (not $path) {
    die('specify path');
}


print <<EOF;
displayName,messageForClick
=arg=$arg
=stringFormat=#{arg}
==
=arg=$arg
=displayName=Portrait (left)
=messageForClick=NSArray|addObject:'anal-monitor-rotateMonitor:orientation:.pl'|addObject:arg|addObject:'left'|runCommandInBackground
==
=arg=$arg
=displayName=Portrait (right)
=messageForClick=NSArray|addObject:'anal-monitor-rotateMonitor:orientation:.pl'|addObject:arg|addObject:'right'|runCommandInBackground
==
=arg=$arg
=displayName=Landscape (normal)
=messageForClick=NSArray|addObject:'anal-monitor-rotateMonitor:orientation:.pl'|addObject:arg|addObject:'normal'|runCommandInBackground
==
=arg=$arg
=displayName=Landscape (inverted)
=messageForClick=NSArray|addObject:'anal-monitor-rotateMonitor:orientation:.pl'|addObject:arg|addObject:'inverted'|runCommandInBackground
==
==
EOF

@monitors = `cat $path`;
chomp @monitors;

$i = 0;
foreach $line (@monitors) {
    $i++;
    $name = '';
    if ($line !~ m/\boutput:([^\s]+)/) {
        next;
    }
    $name = $1;
    if ($name eq $arg) {
        print <<EOF;
=i=$i
=arg=$arg
=stringFormat=#{i}. #{arg}
==
EOF
    } else {
        print <<EOF;
=i=$i
=arg=$arg
=name=$name
=stringFormat=#{i}. Swap Monitor with #{name}
=messageForClick=NSArray|addObject:'anal-monitor-swapMonitors::.pl'|addObject:arg|addObject:name|runCommandInBackground
==
EOF
    }
}

print <<EOF;
==
EOF

$output = `xrandr`;
@lines = split "\n", $output;

$name = undef;
$refreshRates = undef;

foreach $line (@lines) {
    if ($line =~ m/ connected /) {
        $line =~ s/ connected / /;
        $line =~ s/ primary / /;
        if ($line =~ m/^([^\s]+)\s+(\d+)x(\d+)/) {
            $name = $1;
            next;
        }
    }
    if ($line =~ m/^\s+(\d+)x(\d+)\s+\d+/) {
        $width = $1;
        $height = $2;
        $current = '0';
        if ($line =~ m/\*/) {
            $current = '1';
            $refreshRates = $line;
            $refreshRates =~ s/^\s+(\d+)x(\d+)\s+//;
        }
        $preferred = '0';
        if ($line =~ m/\+/) {
            $preferred = '1';
        }
        if ($arg eq $name) {
            if ($current) {
                print <<EOF;
=width=$width
=height=$height
=stringFormat=#{width}x#{height}*
==
EOF
            } else {
                print <<EOF;
=width=$width
=height=$height
=stringFormat=#{width}x#{height}
==
EOF
            }
        }
    }

}

print <<EOF;
==
EOF

@refreshRates = split /\s+/, $refreshRates;
foreach $refreshRate (@refreshRates) {
    print <<EOF;
=refreshRate=$refreshRate
=stringFormat=#{refreshRate}
==
EOF
}

