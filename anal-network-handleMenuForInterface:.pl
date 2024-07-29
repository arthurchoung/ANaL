#!/usr/bin/perl

$arg = shift @ARGV;
if (not $arg) {
    die('specify interface');
}

if ($arg eq 'lo') {
    exit 0;
}

@lines = `anal-listNetworkInterfaces.pl`;
chomp @lines;

foreach $line (@lines) {
    $interface = '';
    if ($line =~ m/\binterface:([a-z0-9]+)/) {
        $interface = $1;
        $interface =~ s/\'//g;
    }
    if ($interface ne $arg) {
        next;
    }

    if ($line =~ m/\btype:([^\s]+)/) {
        $type = $1;
        $type =~ s/\'//g;
    }
    if ($line =~ m/\bup:([^\s]+)/) {
        $up = $1;
        $up =~ s/\'//g;
    }
    if ($line =~ m/\blowerUp:([^\s]+)/) {
        $lowerUp = $1;
        $lowerUp =~ s/\'//g;
    }
    if ($line =~ m/\boperstate:([^\s]+)/) {
        $operstate = $1;
        $operstate =~ s/\'//g;
    }
    if ($line =~ m/\baddress:([^\s]+)/) {
        $address = $1;
        $address =~ s/\'//g;
    }
    $dhcpcd = `pgrep -f 'dhcpcd.*$interface'`;
    chomp $dhcpcd;
    if ($dhcpcd =~ m/^(\d+)/) {
        $dhcpcd = $1;
    }

    $wireless = 0;
    open(FH, "iwconfig $interface |") or die('unable to run iwconfig');
    while ($line = <FH>) {
        if ($line =~ m/^$interface/) {
            if ($line =~ m/ESSID:/) {
                $wireless = 1;
            }
        }
    }
    close(FH);

    $text = "What to do with $interface?";
    $text =~ s/\\/\\\\/g;
    $text =~ s/"/\\"/g;
    $dhcpcdcmd = qq{dhcpcd 0 "dhcpcd $interface"};
    if ($dhcpcd) {
        $dhcpcdcmd = qq{killdhcpcd 0 "kill dhcpcd (kill -9 $dhcpcd)"}
    }
    $cmd = sprintf('anal radio OK Cancel %s %s %s %s %s',
        qq{"$text"},
        'nothing 1 "Do Nothing"',
        $dhcpcdcmd,
        qq{ifconfigup 0 "ifconfig $interface up"},
        qq{ifconfigdown 0 "ifconfig $interface down"});
    $result = `$cmd`;
    chomp $result;
    if ($result eq 'dhcpcd') {
        system('anal-connectNetworkInterface.pl', $interface);
    } elsif ($result eq 'killdhcpcd') {
        system('sudo', '-A', 'kill', '-9', $dhcpcd);
    } elsif ($result eq 'ifconfigup') {
        system('sudo', '-A', 'ifconfig', $interface, 'up');
    } elsif ($result eq 'ifconfigdown') {
        system('sudo', '-A', 'ifconfig', $interface, 'down');
    }
}

