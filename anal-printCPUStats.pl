#!/usr/bin/perl

$|=1;

use strict;

my %savedCPUStats = ();

sub get_stats
{
    my $output = `cat /proc/stat`;
    my @lines = split '\n', $output;

    my @results = ();

    my $line;
    foreach $line (@lines) {
        if ($line =~ m/^cpu\d/) {
            my @tokens = split /\s/, $line;
            my $key = $tokens[0];
            my %curr = ();
            $curr{'user'} = $tokens[1];
            $curr{'nice'} = $tokens[2];
            $curr{'system'} = $tokens[3];
            $curr{'idle'} = $tokens[4];
            $curr{'iowait'} = $tokens[5];
            $curr{'irq'} = $tokens[6];
            $curr{'softirq'} = $tokens[7];
            $curr{'steal'} = $tokens[8];
            $curr{'guest'} = $tokens[9];
            $curr{'guestNice'} = $tokens[10];
            if (not $savedCPUStats{$key}) {
                $savedCPUStats{$key} = {};
            }
            my %prev = %{ $savedCPUStats{$key} };

            my $prevIdle = $prev{'idle'} + $prev{'iowait'};
            my $idle = $curr{'idle'} + $curr{'iowait'};
            my $prevNonIdle = $prev{'user'} + $prev{'nice'} + $prev{'system'} + $prev{'irq'} + $prev{'softirq'} + $prev{'steal'};
            my $nonIdle = $curr{'user'} + $curr{'nice'} + $curr{'system'} + $curr{'irq'} + $curr{'softirq'} + $curr{'steal'};
            my $prevTotal = $prevIdle + $prevNonIdle;
            my $total = $idle + $nonIdle;
            my $deltaTotal = $total - $prevTotal;
            my $deltaIdle = $idle - $prevIdle;
            my $pct = ($deltaTotal - $deltaIdle) / $deltaTotal;
            push @results, $pct;
            $savedCPUStats{$key} = \%curr;
        }
    }
    return @results;
}

sub print_bar_chart
{
    my @pcts = @_;

    my $barHeight = 16;
    my $spacing = 1;
    my $barWidth = 5;

    my @heights = map { int ($_ * $barHeight) + 1 } @pcts;

    print "\npixels\n";

    my $y;
    for ($y=18; $y>0; $y--) {
        my @arr = ();
        my $height;
        foreach $height (@heights) {
            if ($height >= $y) {
                push @arr, "x" x $barWidth;
            } else {
                push @arr, " " x $barWidth;
            }
        }
        my $str = join " " x $spacing, @arr;
        print "$str\n";
    }

    print "\n";
}

print <<EOF;
palette
x #000000

highlightedPalette
x #ffffff

EOF

for(;;) {
    my @pcts = get_stats();
    print_bar_chart(@pcts);
    sleep 1;
}

