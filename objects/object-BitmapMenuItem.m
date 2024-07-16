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

static char *redPotionPalette =
". #E09C20\n"
"X #B03020\n"
"o #F8FCF8\n"
"O #ffffff\n"
"b #000000\n"
;
static char *redPotionPixels =
"                \n"
"      bbbb      \n"
"     b....b     \n"
"      bXXb      \n"
"     boooob     \n"
"     boXXob     \n"
"     bobbob     \n"
"     bobbob     \n"
"    boobboob    \n"
"   bobbbbbbob   \n"
"   bobbbbbbob   \n"
"   boXXXXXXob   \n"
"   boXXXXX.ob   \n"
"   boX.XXXXob   \n"
"   boXXX.XXob   \n"
"   booXXXXoob   \n"
"   boooooooob   \n"
"    boooooob    \n"
"     bbbbbb     \n"
;
@implementation Definitions(fnmjkdfsjkfsdjkeklwfmklsdmfksdkfmdfjkjkfjdksjf)
+ (id)RedPotionMenuItem
{
    id pixels = nsfmt(@"%s", redPotionPixels);
    id palette = nsfmt(@"%s", redPotionPalette);
    id highlightedPalette = palette;

    id obj = [@"BitmapMenuItem" asInstance];
    [obj setValue:pixels forKey:@"pixels"];
    [obj setValue:palette forKey:@"palette"];
    [obj setValue:highlightedPalette forKey:@"highlightedPalette"];
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

