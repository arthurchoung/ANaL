#!/usr/bin/perl

$NDKROOT = $ENV{'HOME'} . '/Android/android-ndk-r20b';
#$CC = "clang -target armv7a-linux-androideabi21";
$CC = "$NDKROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi21-clang";

$cflags = '-DGC_DEBUG -DGNUSTEP -DNO_LEGACY -DTYPE_DEPENDENT_DISPATCH -D__OBJC_RUNTIME_INTERNAL__=1  -std=gnu99  -fexceptions -fPIC';
$asmflags = '-fPIC -DGC_DEBUG -DGNUSTEP -DNO_LEGACY -DTYPE_DEPENDENT_DISPATCH -D__OBJC_RUNTIME_INTERNAL__=1  -fPIC';
$mflags = '-DGC_DEBUG -DGNUSTEP -DNO_LEGACY -DTYPE_DEPENDENT_DISPATCH -D__OBJC_RUNTIME_INTERNAL__=1  -std=gnu99  -fexceptions -fPIC    -Wno-deprecated-objc-isa-usage -Wno-objc-root-class -fobjc-runtime=gnustep-1.7';

$files = <<EOF;
abi_version.c
alias_table.c
block_to_imp.c
caps.c
category_loader.c
class_table.c
dtable.c
eh_personality.c
encoding2.c
hooks.c
ivar.c
legacy_malloc.c
loader.c
mutation.m
protocol.c
runtime.c
sarray2.c
selector_table.c
sendmsg2.c
statics_loader.c
block_trampolines.S
objc_msgSend.S
NSBlocks.m
Protocol2.m
arc.m
associate.m
blocks_runtime.m
properties.m
gc_none.c
EOF
#hash_table.c
#toydispatch.c

@files = split '\n', $files;

foreach $file (@files) {
    $flags = '';
    if ($file =~ m/\.c$/) {
        $flags = $cflags;
    } elsif ($file =~ m/\.S$/) {
        $flags = $asmflags;
    } elsif ($file =~ m/\.m$/) {
        $flags = $mflags;
    }
    print "$CC $flags -o $file.o -c ../$file\n";
}

