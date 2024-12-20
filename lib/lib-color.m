/*

 ANaL

 Copyright (c) 2024 Arthur Choung. All rights reserved.

 Email: arthur -at- fmamp.com

 This file is part of ANaL.

 ANaL is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */

#import "ANAL.h"

@implementation NSString(fjipewjfidsjkfjksdfjk)
- (id)doubleAs8BitHex
{
    double dval = [self doubleValue];
    int ival = (int)(dval * 255.0);
    return [nsfmt(@"%d", ival) intAs8BitHex];
}
- (id)intAs8BitHex
{
    int val = [self intValue];
    if (val < 0) {
        val = 0;
    }
    if (val > 255) {
        val = 255;
    }
    char *alphabet = "0123456789abcdef";
    char c1 = alphabet[val/16];
    char c2 = alphabet[val%16];
    return nsfmt(@"%c%c", c1, c2);
}

@end


@implementation NSString(fjksdjfklsdjklfjskldf)
- (id)asRGBColor
{
    id color = [self asColor];
    return [color stringToIndex:7];
}
- (id)asColor
{
    if ([self hasPrefix:@"#"]) {
        return [self lowercaseString];
    }

    id tokens = [self split];
    int count = [tokens count];
    if ((count == 3) || (count == 4)) {
        BOOL isDouble = ([[tokens nth:0] containsString:@"."]) ? YES : NO;
        if (isDouble) {
            id mapArr = nsarr();
            for (int i=0; i<[tokens count]; i++) {
                id elt = [tokens nth:i];
                [mapArr addObject:[elt doubleAs8BitHex]];
            }
            tokens = mapArr;
        } else {
            id mapArr = nsarr();
            for (int i=0; i<[tokens count]; i++) {
                id elt = [tokens nth:i];
                [mapArr addObject:[elt intAs8BitHex]];
            }
            tokens = mapArr;
        }
        return nsfmt(@"#%@", [tokens join:@""]);
    }

    id str = [self lowercaseString];
    if ([str isEqual:@"black"]) { return @"#000000ff"; }
    if ([str isEqual:@"white"]) { return @"#ffffffff"; }
    if ([str isEqual:@"red"]) { return @"#ff0000ff"; }
    if ([str isEqual:@"yellow"]) { return @"#ffff00ff"; }
    if ([str isEqual:@"blue"]) { return @"#0000ffff"; }
    if ([str isEqual:@"green"]) { return @"#00ff00ff"; }
    if ([str isEqual:@"purple"]) { return @"#7f007fff"; }
    if ([str isEqual:@"cyan"]) { return @"#00ffffff"; }
    if ([str isEqual:@"darkgreen"]) { return @"#013220ff"; }
    if ([str isEqual:@"orange"]) { return @"#ffa500ff"; }
    if ([str isEqual:@"clear"]) { return @"#00000000"; }
    if ([str isEqual:@"magenta"]) { return @"#ff00ffff"; }
    return @"#ffffffff";
}
- (double)redDouble
{
    return (double)[self redInt] / 255.0;
}
- (double)greenDouble
{
    return (double)[self greenInt] / 255.0;
}
- (double)blueDouble
{
    return (double)[self blueInt] / 255.0;
}
- (double)alphaDouble
{
    return (double)[self alphaInt] / 255.0;
}
- (int)redInt
{
    if (!_contents) {
        return 255;
    }
    if (_length < 3) {
        return 255;
    }    
    int c1 = _contents[1];
    int c2 = _contents[2];
    int n1 = 0;
    if (isdigit(c1)) { n1 = (c1 - '0'); }
    else if (islower(c1)) { n1 = (c1 - 'a' + 10); }
    else if (isupper(c1)) { n1 = (c1 - 'A' + 10); }
    int n2 = 0;
    if (isdigit(c2)) { n2 = (c2 - '0'); }
    else if (islower(c2)) { n2 = (c2 - 'a' + 10); }
    else if (isupper(c2)) { n2 = (c2 - 'A' + 10); }
    if ((n1 < 0) || (n1 > 15)) {
        return 255;
    }
    if ((n2 < 0) || (n2 > 15)) {
        return 255;
    }
    return n1*16 + n2;
}
- (int)greenInt
{
    if (!_contents) {
        return 255;
    }
    if (_length < 5) {
        return 255;
    }
    int c1 = _contents[3];
    int c2 = _contents[4];
    int n1 = 0;
    if (isdigit(c1)) { n1 = (c1 - '0'); }
    else if (islower(c1)) { n1 = (c1 - 'a' + 10); }
    else if (isupper(c1)) { n1 = (c1 - 'A' + 10); }
    int n2 = 0;
    if (isdigit(c2)) { n2 = (c2 - '0'); }
    else if (islower(c2)) { n2 = (c2 - 'a' + 10); }
    else if (isupper(c2)) { n2 = (c2 - 'A' + 10); }
    if ((n1 < 0) || (n1 > 15)) {
        return 255;
    }
    if ((n2 < 0) || (n2 > 15)) {
        return 255;
    }
    return n1*16 + n2;
}
- (int)blueInt
{
    if (!_contents) {
        return 255;
    }
    if (_length < 7) {
        return 255;
    }
    int c1 = _contents[5];
    int c2 = _contents[6];
    int n1 = 0;
    if (isdigit(c1)) { n1 = (c1 - '0'); }
    else if (islower(c1)) { n1 = (c1 - 'a' + 10); }
    else if (isupper(c1)) { n1 = (c1 - 'A' + 10); }
    int n2 = 0;
    if (isdigit(c2)) { n2 = (c2 - '0'); }
    else if (islower(c2)) { n2 = (c2 - 'a' + 10); }
    else if (isupper(c2)) { n2 = (c2 - 'A' + 10); }
    if ((n1 < 0) || (n1 > 15)) {
        return 255;
    }
    if ((n2 < 0) || (n2 > 15)) {
        return 255;
    }
    return n1*16 + n2;
}
- (int)alphaInt
{
    if (!_contents) {
        return 255;
    }
    if (_length < 9) {
        return 255;
    }
    int c1 = _contents[7];
    int c2 = _contents[8];
    int n1 = 0;
    if (isdigit(c1)) { n1 = (c1 - '0'); }
    else if (islower(c1)) { n1 = (c1 - 'a' + 10); }
    else if (isupper(c1)) { n1 = (c1 - 'A' + 10); }
    int n2 = 0;
    if (isdigit(c2)) { n2 = (c2 - '0'); }
    else if (islower(c2)) { n2 = (c2 - 'a' + 10); }
    else if (isupper(c2)) { n2 = (c2 - 'A' + 10); }
    if ((n1 < 0) || (n1 > 15)) {
        return 255;
    }
    if ((n2 < 0) || (n2 > 15)) {
        return 255;
    }
    return n1*16 + n2;
}

@end

