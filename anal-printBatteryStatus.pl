#!/usr/bin/perl

$|=1;

for (;;) {
    $chargeFullDesign = `cat /sys/class/power_supply/BAT0/charge_full_design 2>/dev/null`;
    #$chargeFullDesign = `cat /sys/class/power_supply/BAT0/energy_full_design 2>/dev/null`;
    chomp $chargeFullDesign;
    $chargeFull = `cat /sys/class/power_supply/BAT0/charge_full 2>/dev/null`;
    #$chargeFull = `cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null`;
    chomp $chargeFull;
    $chargeNow = `cat /sys/class/power_supply/BAT0/charge_now 2>/dev/null`;
    #$chargeNow = `cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null`;
    chomp $chargeNow;
    $status = `cat /sys/class/power_supply/BAT0/status 2>/dev/null`;
    chomp $status;

    $str = 'No battery';

    if ($status && $chargeNow && $chargeFullDesign) {
        $str = sprintf("%s: %.0f%%", $status, ($chargeNow / $chargeFullDesign) * 100.0);
    } elsif ($status) {
        $str = $status;
    }

    print "$str\n";

    sleep 5;
}

