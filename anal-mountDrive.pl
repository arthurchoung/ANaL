#!/usr/bin/perl

$baseDir = `anal configDir`;
chomp $baseDir;
chdir $baseDir;

$device = shift @ARGV;
if (not $device) {
    die('specify device');
}

for(;;) {
loop:
    # FIXME
    @mountlist = `anal-listBlockDevices.pl | anal-valueForKey:.pl mountpoint | sed '/^\$/d'`;
    chomp @mountlist;
    $mountlist = join ' ', @mountlist;

    $mountpointsFile = 'Temp/mountpoints.txt';
    if (-e $mountpointsFile) {
        @lines = `cat $mountpointsFile`;
        @lines = sort @lines;
        chomp @lines;
        if (scalar @lines) {
            @arr = ('anal', 'radio', 'OK', 'Cancel', qq{"Enter mount point for $device:"});
            $default = '1';
            $i = 1;
            foreach $line (@lines) {
                $line =~ s/([\"\\])/\\$1/g;
                $found = 0;
                foreach $elt (@mountlist) {
                    if ($elt eq $line) {
                        $found = 1;
                        last;
                    }
                }
                if (not $found) {
                    push @arr, $i, $default, qq{"$line"};
                    $default = '0';
                }
                $i++;
            }
            if (not $default) {
                push @arr, 'new', '0', qq{"Enter New Mount Point"};
                $cmd = join ' ', @arr;
                $result = `$cmd`;
                chomp $result;
                if ($result eq 'new') {
                } elsif ($result > 0) {
                    $mountpoint = $lines[$result-1];
                    system('sudo', '-A', 'mount', $device, $mountpoint);
                    if ($? != 0) {
                        system('anal', 'alert', "Unable to mount $device at $mountpoint");
                        exit 1;
                    }
                    chdir $mountpoint;
                    system('anal');
                    exit 0;
                } else {
                    exit 0;
                }
            }
        }
    }

    $text = <<EOF;
Enter mount point for $device:
(mount points that are already in use: $mountlist)
EOF

    $mountpoint = `anal input OK Cancel "$text" 'Mount point:'`;
    chomp $mountpoint;
    if ($? != 0) {
        exit 1;
    }
    if (not $mountpoint) {
        exit 0;
    }
    $output = `anal-listBlockDevices.pl`;
    @lines = split "\n", $output;
    foreach $line (@lines) {
        if ($line =~ m/\bmountpoint:([^\s]+)/) {
            $str = $1;
            $str =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/eg;
            if ($mountpoint eq $str) {
                # FIXME: should sanitize $mountpoint
                system('anal', 'alert', "$mountpoint is already in use");
                goto loop;
            }
        }
    }

    if (open(FH, ">>$mountpointsFile")) {
        print FH "$mountpoint\n";
        close(FH);
    }

    system('sudo', '-A', 'mount', $device, $mountpoint);
    if ($? != 0) {
        system('anal', 'alert', "Unable to mount $device at $mountpoint");
        exit 1;
    }

    chdir $mountpoint;
    system('anal');

    exit 0;
}


