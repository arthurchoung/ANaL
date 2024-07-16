#!/usr/bin/perl

use strict;

#my $LIBOBJC = '/usr/lib/libobjc.a';
my $LIBOBJC = '/usr/lib64/libobjc.a';

my $libobjc2_cflags = '-DGC_DEBUG -DGNUSTEP -DNO_LEGACY -DTYPE_DEPENDENT_DISPATCH -D__OBJC_RUNTIME_INTERNAL__=1  -std=gnu99  -fexceptions -fPIC';
my $libobjc2_asmflags = '-fPIC -DGC_DEBUG -DGNUSTEP -DNO_LEGACY -DTYPE_DEPENDENT_DISPATCH -D__OBJC_RUNTIME_INTERNAL__=1  -fPIC';
my $libobjc2_mflags = '-DGC_DEBUG -DGNUSTEP -DNO_LEGACY -DTYPE_DEPENDENT_DISPATCH -D__OBJC_RUNTIME_INTERNAL__=1  -std=gnu99  -fexceptions -fPIC    -Wno-deprecated-objc-isa-usage -Wno-objc-root-class -fobjc-runtime=gnustep-1.7';

sub getExecPath
{
    my $path = __FILE__;
    for (;;) {
        my $dir = `dirname $path`;
        chomp $dir;
        if (-e "$dir/ANAL.h") {
            return $dir;
        }
        if (not -l $path) {
            last;
        }
        my $newpath = `readlink $path`;
        chomp $newpath;
        if (not $newpath) {
            last;
        }
        $path = $newpath;
    }
    print "Error: ANAL.h not found\n";
    exit(1);
}

my $execPath = getExecPath();
print "execPath: '$execPath'\n";

my $buildPath = "$execPath/Build";
print "buildPath: '$buildPath'\n";

my $objectsPath = "$buildPath/Objects";
my $logsPath = "$buildPath/Logs";

sub cflagsForFile
{
    my ($path) = @_;
    my $objcflags = <<EOF;
    -Werror=implicit-function-declaration
    -Werror=return-type
    -I$execPath
    -I$execPath/linux
    -I$execPath/lib
    -I$execPath/objects
    -I$execPath/misc
    -DBUILD_WITH_GNU_PRINTF
    -DBUILD_WITH_GNU_QSORT_R
    -DBUILD_WITH_BGRA_PIXEL_FORMAT
    -std=c99
    -fconstant-string-class=NSConstantString
EOF
    if ($path =~ m/\/external\/libobjc2\//) {
        if ($path =~ m/\.c$/) {
            return $libobjc2_cflags;
        } elsif ($path =~ m/\.m$/) {
            return $libobjc2_mflags;
        } elsif ($path =~ m/\.S$/) {
            return $libobjc2_asmflags;
        }
    }
    if ($path =~ m/\/external\/tidy-html5-5.6.0\//) {
        return "-I$execPath/external/tidy-html5-5.6.0/include -I$execPath/external/tidy-html5-5.6.0/src -Wno-implicit-function-declaration -Wno-int-conversion";
    }
    if ($path eq "$execPath/misc/lib-htmltidy.m") {
        return "$objcflags -I$execPath/external/tidy-html5-5.6.0/include";
    }
    if ($path eq "$execPath/misc/misc-gmime.m") {
        my $flags = `pkg-config --cflags gmime-3.0`;
        return "$objcflags $flags";
    }
    if ($path eq "$execPath/misc/misc-chipmunk.m") {
        return "$objcflags -I$execPath/external/chipmunk/include";
    }
    if ($path eq "$execPath/lib/lib-script.m") {
        return "$objcflags -Wno-incompatible-function-pointer-types";
    }
    if ($path =~ m/\.m$/) {
        return $objcflags;
    }
    return '';
}

sub ldflagsForFile
{
    my ($path) = @_;
    if ($path eq "$execPath/linux/linux-x11.m") {
        return '-lX11 -lXext';
    }
    if ($path eq "$execPath/linux/linux-opengl.m") {
        return '-lGL';
    }
    if ($path eq "$execPath/misc/misc-gmime.m") {
        return `pkg-config --libs gmime-3.0`;
    }
    if ($path eq "$execPath/misc/misc-pcre.m") {
        return '-lpcre';
    }
    if ($path eq "$execPath/misc/object-nes.m") {
        return '-ldl';
    }
    if ($path eq "$execPath/misc/misc-chipmunk.m") {
        return "$execPath/external/chipmunk/libchipmunk.a";
    }
    return '';
}

sub ldflagsForAllFiles
{
    my @files = @_;
    my @strs = map { ldflagsForFile($_) } @files;
    @strs = grep { $_ } @strs;
    return join ' ', @strs;
}




sub allSourceFiles
{
    my $cmd = <<EOF;
find -L
    $execPath/linux/
	$execPath/lib/
    $execPath/objects/
    $execPath/misc/
EOF
#    $execPath/external/libobjc2/abi_version.c
#    $execPath/external/libobjc2/alias_table.c
#    $execPath/external/libobjc2/block_to_imp.c
#    $execPath/external/libobjc2/caps.c
#    $execPath/external/libobjc2/category_loader.c
#    $execPath/external/libobjc2/class_table.c
#    $execPath/external/libobjc2/dtable.c
#    $execPath/external/libobjc2/eh_personality.c
#    $execPath/external/libobjc2/encoding2.c
#    $execPath/external/libobjc2/hooks.c
#    $execPath/external/libobjc2/ivar.c
#    $execPath/external/libobjc2/legacy_malloc.c
#    $execPath/external/libobjc2/loader.c
#    $execPath/external/libobjc2/mutation.m
#    $execPath/external/libobjc2/protocol.c
#    $execPath/external/libobjc2/runtime.c
#    $execPath/external/libobjc2/sarray2.c
#    $execPath/external/libobjc2/selector_table.c
#    $execPath/external/libobjc2/sendmsg2.c
#    $execPath/external/libobjc2/statics_loader.c
#    $execPath/external/libobjc2/block_trampolines.S
#    $execPath/external/libobjc2/objc_msgSend.S
#    $execPath/external/libobjc2/NSBlocks.m
#    $execPath/external/libobjc2/Protocol2.m
#    $execPath/external/libobjc2/arc.m
#    $execPath/external/libobjc2/associate.m
#    $execPath/external/libobjc2/blocks_runtime.m
#    $execPath/external/libobjc2/properties.m
#    $execPath/external/libobjc2/gc_none.c

#    $execPath/external/tidy-html5-5.6.0
    $cmd =~ s/\n/ /g;
    my @lines = `$cmd`;
    @lines = grep /\.(c|m|mm|cpp|S)$/, @lines;
    chomp(@lines);
    return @lines;
}

sub compileSourcePath
{
    my ($sourcePath) = @_;

    my $objectPath = objectPathForPath($sourcePath);
    my $logPath = logPathForPath($sourcePath);

    my $cflags = cflagsForFile($sourcePath);

#    -Werror=objc-method-access
#clang -c -O0 -g -pg
	my $cmd = <<EOF;
gcc -c -O3 
    $cflags
    -o $objectPath $sourcePath 2>>$logPath
EOF

    writeTextToFile("${cmd}\n---CUT HERE---\n", $logPath);

    $cmd =~ s/\n/ /g;
	system($cmd);
}

sub linkSourcePaths
{
    my @arr = @_;
    my $ldflags = ldflagsForAllFiles(@arr);
    @arr = map { objectPathForPath($_) } @arr;
    my $objectFiles = join ' ', @arr;
#    -pg
    my $cmd = <<EOF;
gcc -o $execPath/anal
    $objectFiles
    $LIBOBJC
    -lm
    $ldflags
EOF
    writeTextToFile($cmd, "$logsPath/LINK");
    $cmd =~ s/\n/ /g;
    system($cmd);
}

##########


sub writeTextToFile
{
    my ($text, $path) = @_;

    local *FH;
    open FH, ">$path";
    print FH $text;
    close FH;
}

sub makeDirectory
{
    my ($path) = @_;
    if (-e $path) {
        if (-d $path) {
            return;
        }
        die("already exists but is not a directory: '$path'");
    }
    mkdir $path, 0755 or die("unable to make directory '$path'");
}

sub nameForPath
{
    my ($path) = @_;
    my @comps = split '/', $path;
    my $str = $comps[-1];
    my @arr = split '\.', $str;
    return $arr[0];
}

sub modificationDateForPath
{
    my ($path) = @_;
    return (stat ($path))[9];
}

sub objectPathForPath
{
    my ($sourcePath) = @_;
    my $name = nameForPath($sourcePath);

    if ($sourcePath =~ m/\/external\/libobjc2\//) {
        $name = 'external-libobjc2-' . $name;
    }

    my $objectPath = $objectsPath . "/" . $name . ".o";
    return $objectPath;
}
 
sub logPathForPath
{
    my ($sourcePath) = @_;
    my $name = nameForPath($sourcePath);
    my $logPath = $logsPath . "/" . $name . ".log";
    return $logPath;
}
sub statusForPath
{
    my ($sourcePath) = @_;
    my $objectPath = objectPathForPath($sourcePath);
    my $logPath = logPathForPath($sourcePath);
    my $dateForSource = modificationDateForPath($sourcePath);
    my $dateForObject = modificationDateForPath($objectPath);
    my $dateForLog = modificationDateForPath($logPath);
    if (not -e $sourcePath) {
        return "*sourceDoesNotExist";
    }
    if (-e $objectPath) {
        if ($dateForSource > $dateForObject) {
            # needToCompile
        } else {
            return "ok";
        }
    } else {
        # needToCompile
    }
    if (not -e $logPath) {
        return "*needToCompile";
    }
    if ($dateForSource > $dateForLog) {
        return "*needToCompile";
    }
    return "*compileError";
}


makeDirectory($buildPath);
makeDirectory($objectsPath);
makeDirectory($logsPath);

my @lines = allSourceFiles();
foreach my $line (@lines) {
    my $status = statusForPath($line);
    if ($status eq 'ok') {
        next;
    }

    print "Compiling " . nameForPath($line) . "\n";
    compileSourcePath($line);
    $status = statusForPath($line);


    if ($status eq 'ok') {
        print nameForPath($line) . ": " . "$status\n";
        next;
    }
    my $logPath = logPathForPath($line);
    print `cat $logPath`;
    print nameForPath($line) . ": $status\n";
    exit(0);
}

print "Linking\n";
linkSourcePaths(@lines);

