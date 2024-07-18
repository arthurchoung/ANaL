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

static id amigaCheckmarkPalette =
@"b #000022\n"
@". #FF8800\n"
@"X #0055AA\n"
@"o #ffffff\n"
;
static id amigaCheckmarkPixels =
@"                    \n"
@"                    \n"
@"                    \n"
@"             bbb bbb\n"
@"             b.b b.b\n"
@"            b.b b.b \n"
@"            b.b b.b \n"
@"           b.b b.b  \n"
@"           b.b b.b  \n"
@"bbb bbb   b.b b.b   \n"
@"bXb bXb   b.b b.b   \n"
@" bXb bXb b.b b.b    \n"
@" bXb bXb b.b b.b    \n"
@"  bXb bXb.b b.b     \n"
@"  bXb bXb.b b.b     \n"
@"   bXb b.b.b.b      \n"
@"   bXb b.b.b.b      \n"
@"    bbbbbbbbb       \n"
@"                    \n"
;
@implementation Definitions(fnmjkdfsjkfsdjkeklwfmklsdmfksdkfmdfjkjkfjdksjf)
+ (id)AmigaCheckmarkMenuItem
{
    id obj = [@"BitmapMenuItem" asInstance];
    [obj setValue:amigaCheckmarkPixels forKey:@"pixels"];
    [obj setValue:amigaCheckmarkPalette forKey:@"palette"];
    [obj setValue:amigaCheckmarkPalette forKey:@"highlightedPalette"];
    return obj;
}
@end


@interface BitmapMenuItem : IvarObject
{
    id _pixels;
    id _palette;
    id _highlightedPalette;
}
@end

@implementation BitmapMenuItem
@end

