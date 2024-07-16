#!/usr/bin/perl

$|=1;

use strict;

sub get_monitors
{
    my $output = `xrandr`;
    my @lines = split "\n", $output;

    my @results = ();

    foreach my $line (@lines) {
        if ($line =~ m/ connected /) {
            $line =~ s/ connected / /;
            $line =~ s/ primary / /;
            my %elt = ();
            if ($line =~ m/^([^\s]+)\s+(\d+)x(\d+)\+(\d+)\+(\d+)\s([^\(]*)\(/) {
                $elt{'output'} = $1;
                $elt{'width'} = $2;
                $elt{'height'} = $3;
                $elt{'x'} = $4;
                $elt{'y'} = $5;
                $elt{'rotate'} = $6;
                if (not $elt{'rotate'}) {
                    $elt{'rotate'} = 'normal';
                }
            } elsif ($line =~ m/^([^\s]+)\s/) {
                $elt{'output'} = $1;
            }
            push @results, \%elt;
        }
    }

    @results = sort {
        if ($a->{'x'} eq '') {
            return 1;
        }
        if ($b->{'x'} eq '') {
            return 1;
        }
        return $a->{'x'} <=> $b->{'x'};
    } @results;

    return @results;
}

my @results = get_monitors();

my @keys = ('output', 'width', 'height', 'x', 'y', 'rotate');

foreach my $elt (@results) {
    my @vals = map { $_ . ':' . $elt->{$_} } @keys;
    my $str = join ' ', @vals;
    print "$str\n";
}

