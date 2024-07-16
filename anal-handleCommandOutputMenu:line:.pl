#!/usr/bin/perl

$cmd = shift @ARGV;
if (not $cmd) {
    die('specify cmd');
}

$line = shift @ARGV;
if (not $line) {
    die('specify line');
}

#linux
if ($cmd =~ m/^lsblk\b/) {
    if ($line =~ m/^[\|\`]\-([a-z0-9]+)/) {
        system('anal-handleDriveMenuForDevice:.pl', '/dev/'.$1);
        exit 0;
    }
}

#freebsd
if ($cmd =~ m/^anal-generateDiskMenu/) {
    if ($line =~ m/^  ([a-z0-9]+)/) {
        system('anal-handleDiskMenuForDevice:.pl', '/dev/'.$1);
        exit 0;
    }
}

if ($cmd =~ m/^ifconfig\b/) {
    if ($line =~ m/^([a-z0-9]+):/) {
        system('anal-handleNetworkMenuForInterface:.pl', $1);
        exit 0;
    }
    $text = <<EOF;
Select a line that starts with the network interface name.
EOF
    system('anal', 'alert', $text);
    exit 0;
}

if ($cmd =~ m/^ps\b/) {
    if ($line =~ m/^[a-z][-a-z0-9]*\s+(\d+)/) {
        $pid = $1;
        $text = $line;
        $text =~ s/\\/\\\\/g;
        $text =~ s/"/\\"/g;
        $cmd = sprintf('anal radio OK Cancel %s %s %s %s',
            qq{"$text"},
            'nothing 1 "Do Nothing"',
            qq{kill 0 "kill $pid"},
            qq{kill9 0 "kill -9 $pid"});
        $result = `$cmd`;
        chomp $result;
        if ($result eq 'kill') {
            if (system('sudo', '-A', 'kill', $pid) == 0) {
                $text = "Kill signal sent to $pid";
                system('anal', 'alert', $text);
            } else {
                $text = "Unable to send kill signal to $pid";
                system('anal', 'alert', $text);
            }
        } elsif ($result eq 'kill9') {
            if (system('sudo', '-A', 'kill', '-9', $pid) == 0) {
                $text = "Kill -9 signal sent to $pid";
                system('anal', 'alert', $text);
            } else {
                $text = "Unable to send kill -9 signal to $pid";
                system('anal', 'alert', $text);
            }
        }
        exit 0;
    }
}

if ($cmd =~ m/^xset\b/) {
    if ($line =~ m/\bDPMS is Disabled\b/) {
        $text = "Enable DPMS?";
        $cmd = qq{anal confirm OK Cancel "$text"};
        $output = `$cmd`;
        chomp $output;
        if ($output eq 'OK') {
            system('xset', '+dpms');
        }
        exit 0;
    }
    if ($line =~ m/\bDPMS is Enabled\b/) {
        $text = "Disable DPMS?";
        $cmd = qq{anal confirm OK Cancel "$text"};
        $output = `$cmd`;
        chomp $output;
        if ($output eq 'OK') {
            system('xset', '-dpms');
        }
        exit 0;
    }
}

if ($cmd =~ m/^xinput\b/) {
    $name = $line;
    if ($name =~ s/\bid=(\d+)\[slave.*//) {
        $id = $1;
        $name =~ s/^\s*//;
        $name =~ s/\s*$//;
        $cmd = "xinput --list-props $id";
        $output = `$cmd`;
        if ($output =~ m/\n\t*Device Enabled[ \(\)0-9]*:\s+([01])/) {
            $status = $1;
            if ($status) {
                $cmd = qq{anal confirm Disable Cancel "Disable $name (id=$id)?"};
                $output = `$cmd`;
                chomp $output;
                if ($output eq 'Disable') {
                    system('xinput', '--disable', $id);
                }
            } else {
                $cmd = qq{anal confirm Enable Cancel "Enable $name (id=$id)?"};
                $output = `$cmd`;
                chomp $output;
                if ($output eq 'Enable') {
                    system('xinput', '--enable', $id);
                }
            }
            exit 0;
        }
    }
}

if ($cmd =~ m/^iwconfig\b/) {
    if ($line =~ m/^([a-z0-9]+)/) {
        system('anal-selectWifiNetwork.pl', $1);
        exit 0;
    }
    $text = <<EOF;
Select a line that starts with the network interface name.
EOF
    system('anal', 'alert', $text);
    exit 0;
}


system('anal', 'alert', $cmd, $line);

