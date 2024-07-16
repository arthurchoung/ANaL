#!/usr/bin/perl

$|=1;

$path = "$ENV{'HOME'}/SerialTasks";

sub asQuotedString
{
    my ($str) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\"/\\\"/g;
    return '"' . $str . '"';
}

$count = 1;
for (;;) {
    $files = `ls -tr $path 2>/dev/null`;
    @files = split '\n', $files;
    $file = shift @files;
    if (not $file) {
        print "$path waiting $count...\n";
        sleep 1;
        $count++;
        next;
    }
    $file = "$path/$file";
    $quotedFile = asQuotedString($file);
    system("sh $quotedFile");
    unlink $file;
    $count = 1;
}

