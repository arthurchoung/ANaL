#!/usr/bin/perl

print <<EOF;
xrandr --auto
EOF

$prevName = undef;
while ($line = <STDIN>) {
    chomp $line;
    $name = '';
    if ($line !~ m/\boutput:([^\s]+)/) {
        next;
    }
    $name = $1;
    $rotate = '';
    if ($line =~ m/\brotate:([a-zA-Z]+)/) {
        $rotate = $1;
    }

    @arr = ();
    push @arr, 'xrandr';
    push @arr, '--output';
    push @arr, $name;
    push @arr, '--auto';
    if ($prevName) {
        push @arr, '--right-of';
        push @arr, $prevName;
    }
    if ($rotate) {
        push @arr, '--rotate';
        push @arr, $rotate;
    }
    $str = join ' ', @arr;
    print <<EOF;
$str
EOF
    $prevName = $name;
}

