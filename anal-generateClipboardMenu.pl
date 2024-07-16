#!/usr/bin/perl

print <<EOF;
displayName,stringFormat,messageForClick
,"#{NSArray|addObject:'xclip'|addObject:'-o'|runCommandAndReturnOutput|asString}"
"Test showAlert",,"NSArray|addObject:'anal'|addObject:'alert'|addObject:(NSArray|addObject:'xclip'|addObject:'-o'|runCommandAndReturnOutput|asString)|runCommandInBackground"
,,
EOF

$clip = `xclip -o`;

if ($clip =~ m/([0-9\.\-\+]+)/) {
    $num = $1;
    $inchToCM = $num * 2.54;
    $mileToKM = $num * 1.6;
    $lbToKG = $num * 0.45;
    $cmToInch = $num * 0.39;
    $mToInch = int($num * 39.37);
    $mToInch_feet = $mToInch / 12;
    $mToInch_inch = $mToInch % 12;
    $kmToMile = $num * 0.6;
    $kgToPound = $num * 2.2;
    $celsiusToFahrenheit = (9.0/5.0)*$num + 32.0;
    $fahrenheitToCelsius = (5.0/9.0)*($num - 32);
    print <<EOF;
,"$num in =~ $inchToCM cm",
,"$num cm =~ $cmToInch in",
,"$num m =~ $mToInch_feet ft $mToInch_inch in",
,"$num mile =~ $mileToKM km",
,"$num km =~ $kmToMile mile",
,"$num lb =~ $lbToKG kg",
,"$num kg =~ $kgToPound lb",
,"$num celsius =~ $celsiusToFahrenheit fahrenheit",
,"$num fahrenheit =~ $fahrenheitToCelsius celsius",
EOF
}

