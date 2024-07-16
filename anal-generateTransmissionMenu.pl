#!/usr/bin/perl

$pid = `pidof transmission-daemon`;
chomp $pid;
if ($pid) {
    print <<EOF;
=displayName=Open Web Interface
=messageForClick='chromium http://admin:password\@127.0.0.1:9091'|split|runCommandInBackground
==
==
=pid=$pid
=stringFormat=Stop Daemon (pid #{pid})
=messageForClick=NSArray|addObject:'kill'|addObject:pid|runCommandInBackground
==
EOF
    $clip = `xclip -o`;
    if ($clip) {
        if ($clip =~ m/^magnet:/) {
            print <<EOF;
==
=clip=$clip
=stringFormat=Add #{clip}
=messageForClick=NSArray|addObject:'transmission-remote'|addObject:'-n'|addObject:'admin:password'|addObject:'-a'|addObject:clip|runCommandAndReturnOutput|asString|showAlert
==
EOF
        }
    }
} else {
    print <<EOF;
=displayName=Start Daemon
=messageForClick='transmission-daemon -t -u admin -v password -p 9091 -a 127.0.0.1'|split|runCommandInBackground
==
EOF
}

