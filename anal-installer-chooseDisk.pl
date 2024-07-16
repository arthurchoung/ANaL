#!/usr/bin/perl

$output = `anal-listBlockDevices.pl`;
@lines = split "\n", $output;

@results = ();
$count = 0;

$disk = '';
$disksize = '';
$diskvendor = '';
$diskmodel = '';
$firstPartition = '';
$firstPartitionFSType = 'unknown filesystem';
$firstPartitionSize = '';

foreach $line (@lines) {
    $type = '';
    if ($line =~ m/\btype:([a-z]+)/) {
        $type = $1;
    }

    $device = '';
    if ($line =~ m/\bdevice:([^\s]+)/) {
        $device = $1;
    }

    $fstype = '';
    if ($line =~ m/\bfstype:([^\s]+)/) {
        $fstype = $1;
    }

    $size = '';
    if ($line =~ m/\bsize:([^\s]+)/) {
        $size = $1;
    }

    $mountpoint = '';
    if ($line =~ m/\bmountpoint:([^\s]+)/) {
        $mountpoint = $1;
    }

    $label = '';
    if ($line =~ m/\blabel:([^\s]+)/) {
        $label = $1;
        $label =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/eg;
    }

    $vendor = '';
    if ($line =~ m/\bvendor:([^\s]+)/) {
        $vendor = $1;
        $vendor =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/eg;
    }

    $model = '';
    if ($line =~ m/\bmodel:([^\s]+)/) {
        $model = $1;
        $model =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/eg;
    }

    if ($type eq 'disk') {
        $disk = $device;
        $disksize = $size;
        $disklabel = $label;
        $diskvendor = $vendor;
        $diskmodel = $model;
        $firstPartition = '';
    } elsif ($type eq 'part') {
        if ($disk) {
            if (not $firstPartition) {
                $firstPartition = $device;
                $firstPartitionFSType = $fstype;
                $firstPartitionSize = $size;
                $firstPartitionLabel = $label;
                if (not $firstPartitionFSType) {
                    $firstPartitionFSType = 'unknown filesystem';
                }
            } else {
                if (not $mountpoint) {
                    push @results, "$disk $firstPartition $device";
                    $str = <<EOF;
Install to $device ($fstype) $size
Label: $label

Disk: $disk ($diskvendor $diskmodel) $disksize
Disk Label: $disklabel
Bootloader: $firstPartition ($firstPartitionFSType) $firstPartitionSize
Bootloader Label: $firstPartitionLabel
EOF
                    push @results, $str;
                    $count++;
                }
            }
        }
    }
}

if (not $count) {
    @cmd = ();
    push @cmd, 'dialog';
    push @cmd, '--msgbox';
    push @cmd, 'Error, unable to find a suitable device for installation.';
    push @cmd, '16';
    push @cmd, '68';
    system(@cmd);
    exit 1;
}

@cmd = ();
push @cmd, 'dialog';
push @cmd, '--stdout';
push @cmd, '--menu';
push @cmd, "Select the disk where you want to install ANaL:";
push @cmd, '14';
push @cmd, '72';
push @cmd, "$count";
push @cmd, @results;

system(@cmd);

exit 0;

