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

@implementation Definitions(jfovcnvieiwejfklsdjfklsdjlkfjsdlkffdjskfjklsdjfkljjkjksdfjksdjj)
+ (void)enterWorkbenchMode
{
    [Definitions enterWorkbenchMode:1];
}
+ (void)enterWorkbenchMode:(int)scaling
{
    if (scaling < 1) {
        scaling = 1;
    }
    [Definitions setValue:nsfmt(@"%d", scaling) forEnvironmentVariable:@"ANAL_SCALING"];

    id windowManager = [Definitions windowManager];
    [windowManager setFocusDict:nil];
    [windowManager unparentAllWindows];

    char *backgroundCString =
"a\n"
;
    char *backgroundPalette =
"a #aaaaaa\n"
;
    [windowManager setBackgroundForCString:backgroundCString palette:backgroundPalette];

    id rootWindowObject = [@"RootWindow" asInstance];
    [windowManager setValue:rootWindowObject forKey:@"rootWindowObject"];
    [windowManager reparentAllWindows:@"Window"];
    id oldMenuBar = [windowManager valueForKey:@"menuBar"];
    [oldMenuBar setValue:@"1" forKey:@"shouldCloseWindow"];
    int h = 20*scaling;
    [windowManager setValue:nsfmt(@"%d", h) forKey:@"menuBarHeight"];
    id menuBar = [windowManager openWindowForObject:[@"MenuBar" asInstance] x:0 y:0 w:[windowManager intValueForKey:@"rootWindowWidth"] h:h];
    [windowManager setValue:menuBar forKey:@"menuBar"];
    [windowManager setFocusDict:nil];
}
@end

static char *hasFocusPalette =
"b #000000\n"
". #6688bb\n"
"X #aaaaaa\n"
"o #ffffff\n"
;
static char *noFocusPalette =
"b #000000\n"
". #aaaaaa\n"
"X #aaaaaa\n"
"o #ffffff\n"
;
static char *selectedPalette =
"o #000000\n"
". #aaaaaa\n"
"b #ffffff\n"
;
static char *activeTitleBarLeftPixels =
"oooooooooooooooooooo\n"
"oooooooooooooooooooo\n"
"o.................bo\n"
"o.................bo\n"
"o.................bo\n"
"o.................bo\n"
"o......bbbbb......bo\n"
"o......bbbbb......bo\n"
"o......booob......bo\n"
"o......booob......bo\n"
"o......booob......bo\n"
"o......booob......bo\n"
"o......booob......bo\n"
"o......booob......bo\n"
"o......bbbbb......bo\n"
"o......bbbbb......bo\n"
"o.................bo\n"
"o.................bo\n"
"o.................bo\n"
"o.................bo\n"
"obbbbbbbbbbbbbbbbbbb\n"
"obbbbbbbbbbbbbbbbbbb\n"
;
static char *activeTitleBarMiddlePixels =
"o\n"
"o\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
"b\n"
"b\n"
;
static char *activeTitleBarRightPixels =
"ooooooooooooooooooooooooooooooooooooooooooooooo\n"
"ooooooooooooooooooooooooooooooooooooooooooooooo\n"
"bo.....................bo.....................b\n"
"bo.....................bo.....................b\n"
"bo....bbbbbbbbbbbbb....bo...bbbbbbbbbbb.......b\n"
"bo....bbbbbbbbbbbbb....bo...bbbbbbbbbbb.......b\n"
"bo....bbooobb.....b....bo...bXXXXXXXXXb.......b\n"
"bo....bbooobb.....b....bo...bXXXXXXXXXb.......b\n"
"bo....bbooobb.....b....bo...bXXXbbbbbbbbbbb...b\n"
"bo....bbooobb.....b....bo...bXXXbbbbbbbbbbb...b\n"
"bo....bbbbbbb.....b....bo...bXXXbooooooooob...b\n"
"bo....bbbbbbb.....b....bo...bXXXbooooooooob...b\n"
"bo....b...........b....bo...bbbbbooooooooob...b\n"
"bo....b...........b....bo...bbbbbooooooooob...b\n"
"bo....b...........b....bo.......booooooooob...b\n"
"bo....b...........b....bo.......booooooooob...b\n"
"bo....bbbbbbbbbbbbb....bo.......bbbbbbbbbbb...b\n"
"bo....bbbbbbbbbbbbb....bo.......bbbbbbbbbbb...b\n"
"bo.....................bo.....................b\n"
"bo.....................bo.....................b\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
;
static char *leftBorderMiddlePixels =
"o..b\n"
;
static char *bottomBorderLeftPixels =
"o..b\n"
"o..b\n"
"o...\n"
"o...\n"
"obbb\n"
"obbb\n"
;
static char *bottomBorderMiddlePixels =
"o\n"
"o\n"
".\n"
".\n"
"b\n"
"b\n"
;
static char *bottomBorderRightPixels =
"o..b\n"
"o..b\n"
"...b\n"
"...b\n"
"bbbb\n"
"bbbb\n"
;
static char *rightBorderMiddlePixels =
"o..b\n"
;
static char *maximizeButtonDownPixels =
"bbbbbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbbbbb\n"
"b.....................o\n"
"b.....................o\n"
"b....bbbbbbbbbbbbb....o\n"
"b....bbbbbbbbbbbbb....o\n"
"b....bb...bbooooob....o\n"
"b....bb...bbooooob....o\n"
"b....bb...bbooooob....o\n"
"b....bb...bbooooob....o\n"
"b....bbbbbbbooooob....o\n"
"b....bbbbbbbooooob....o\n"
"b....booooooooooob....o\n"
"b....booooooooooob....o\n"
"b....booooooooooob....o\n"
"b....booooooooooob....o\n"
"b....bbbbbbbbbbbbb....o\n"
"b....bbbbbbbbbbbbb....o\n"
"b.....................o\n"
"b.....................o\n"
"ooooooooooooooooooooooo\n"
"ooooooooooooooooooooooo\n"
;
static char *lowerButtonDownPixels =
"bbbbbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbbbbb\n"
"b.....................o\n"
"b.....................o\n"
"b...bbbbbbbbbbb.......o\n"
"b...bbbbbbbbbbb.......o\n"
"b...bXXXXXXXXXb.......o\n"
"b...bXXXXXXXXXb.......o\n"
"b...bXXXbbbbbbbbbbb...o\n"
"b...bXXXbbbbbbbbbbb...o\n"
"b...bXXXbooooobooob...o\n"
"b...bXXXbooooobooob...o\n"
"b...bbbbbbbbbbbooob...o\n"
"b...bbbbbbbbbbbooob...o\n"
"b.......booooooooob...o\n"
"b.......booooooooob...o\n"
"b.......bbbbbbbbbbb...o\n"
"b.......bbbbbbbbbbb...o\n"
"b.....................o\n"
"b.....................o\n"
"ooooooooooooooooooooooo\n"
"ooooooooooooooooooooooo\n"
;
static char *closeButtonDownPixels =
"bbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbb\n"
"b.................o\n"
"b.................o\n"
"b.................o\n"
"b.................o\n"
"b......bbbbb......o\n"
"b......bbbbb......o\n"
"b......bXXXb......o\n"
"b......bXXXb......o\n"
"b......bXXXb......o\n"
"b......bXXXb......o\n"
"b......bXXXb......o\n"
"b......bXXXb......o\n"
"b......bbbbb......o\n"
"b......bbbbb......o\n"
"b.................o\n"
"b.................o\n"
"b.................o\n"
"b.................o\n"
"boooooooooooooooooo\n"
"boooooooooooooooooo\n"
;
static char *selectedTitleBarLeftPixels =
"oooooooooooooooooooo\n"
"oooooooooooooooooooo\n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"o.                  \n"
"ob                  \n"
"ob                  \n"
;
static char *selectedTitleBarMiddlePixels =
"o\n"
"o\n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
;
static char *selectedTitleBarRightPixels =
"ooooooooooooooooooooooooooooooooooooooooooooooo\n"
"ooooooooooooooooooooooooooooooooooooooooooooooo\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             .b\n"
"                                             bb\n"
"                                             bb\n"
;
static char *selectedLeftBorderMiddlePixels =
"o.  \n"
;
static char *selectedBottomBorderLeftPixels =
"o.  \n"
"o.  \n"
"o.  \n"
"o.  \n"
"obbb\n"
"obbb\n"
;
static char *selectedBottomBorderMiddlePixels =
" \n"
" \n"
" \n"
" \n"
"b\n"
"b\n"
;
static char *selectedBottomBorderRightPixels =
"  .b\n"
"  .b\n"
"  .b\n"
"  .b\n"
"bbbb\n"
"bbbb\n"
;
static char *selectedRightBorderMiddlePixels =
"  .b\n"
;

@interface Window : IvarObject
{
    int _leftBorder;
    int _rightBorder;
    int _topBorder;
    int _bottomBorder;

    char _buttonDown;
    char _buttonHover;
    int _buttonDownX;
    int _buttonDownY;
    Int4 _titleBarRect;
    Int4 _titleBarTextRect;
    Int4 _leftBorderRect;
    Int4 _rightBorderRect;
    Int4 _topBorderRect;
    Int4 _bottomBorderRect;
    Int4 _closeButtonRect;
    Int4 _maximizeButtonRect;
    Int4 _lowerButtonRect;
    Int4 _resizeButtonRect;

    // setPixelScale:
    int _pixelScaling;
    id _scaledFont;
    id _scaledActiveTitleBarLeftPixels;
    int _scaledActiveTitleBarLeftWidth;
    id _scaledActiveTitleBarMiddlePixels;
    int _scaledActiveTitleBarHeight;
    id _scaledActiveTitleBarRightPixels;
    int _scaledActiveTitleBarRightWidth;
    id _scaledLeftBorderMiddlePixels;
    id _scaledBottomBorderLeftPixels;
    id _scaledBottomBorderMiddlePixels;
    id _scaledBottomBorderRightPixels;
    id _scaledRightBorderMiddlePixels;
    id _scaledMaximizeButtonDownPixels;
    id _scaledLowerButtonDownPixels;
    id _scaledCloseButtonDownPixels;

    id _scaledSelectedTitleBarLeftPixels;
    id _scaledSelectedTitleBarMiddlePixels;
    id _scaledSelectedTitleBarRightPixels;
    id _scaledSelectedLeftBorderMiddlePixels;
    id _scaledSelectedBottomBorderLeftPixels;
    id _scaledSelectedBottomBorderMiddlePixels;
    id _scaledSelectedBottomBorderRightPixels;
    id _scaledSelectedRightBorderMiddlePixels;

}
@end
@implementation Window
- (id)init
{
    self = [super init];
    if (self) {
        int scaling = [[Definitions valueForEnvironmentVariable:@"ANAL_SCALING"] intValue];
        if (scaling < 1) {
            scaling = 1;
        }
        [self setPixelScaling:scaling];
    }
    return self;
}
- (void)setPixelScaling:(int)scaling
{
    _pixelScaling = scaling;

    _leftBorder = 4*scaling;
    _rightBorder = 4*scaling;
    _topBorder = 22*scaling;
    _bottomBorder = 6*scaling;

    id obj;
    obj = [Definitions scaleFont:scaling
                    :[Definitions arrayOfCStringsForTopazFont]
                    :[Definitions arrayOfWidthsForTopazFont]
                    :[Definitions arrayOfHeightsForTopazFont]
                    :[Definitions arrayOfXSpacingsForTopazFont]];
    [self setValue:obj forKey:@"scaledFont"];

    obj = [nsfmt(@"%s", activeTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarLeftPixels"];
    _scaledActiveTitleBarLeftWidth = [Definitions widthForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", activeTitleBarMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarMiddlePixels"];
    _scaledActiveTitleBarHeight = [Definitions heightForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", activeTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarRightPixels"];
    _scaledActiveTitleBarRightWidth = [Definitions widthForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", leftBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledLeftBorderMiddlePixels"];

    obj = [nsfmt(@"%s", bottomBorderLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderLeftPixels"];

    obj = [nsfmt(@"%s", bottomBorderMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderMiddlePixels"];

    obj = [nsfmt(@"%s", bottomBorderRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderRightPixels"];

    obj = [nsfmt(@"%s", rightBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledRightBorderMiddlePixels"];

    obj = [nsfmt(@"%s", maximizeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledMaximizeButtonDownPixels"];

    obj = [nsfmt(@"%s", lowerButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledLowerButtonDownPixels"];

    obj = [nsfmt(@"%s", closeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledCloseButtonDownPixels"];




    obj = [nsfmt(@"%s", selectedTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedTitleBarLeftPixels"];

    obj = [nsfmt(@"%s", selectedTitleBarMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedTitleBarMiddlePixels"];

    obj = [nsfmt(@"%s", selectedTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedTitleBarRightPixels"];

    obj = [nsfmt(@"%s", selectedLeftBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedLeftBorderMiddlePixels"];

    obj = [nsfmt(@"%s", selectedBottomBorderLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedBottomBorderLeftPixels"];

    obj = [nsfmt(@"%s", selectedBottomBorderMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedBottomBorderMiddlePixels"];

    obj = [nsfmt(@"%s", selectedBottomBorderRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedBottomBorderRightPixels"];

    obj = [nsfmt(@"%s", selectedRightBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledSelectedRightBorderMiddlePixels"];

}

- (void)calculateRects:(Int4)r
{
    _titleBarRect = [Definitions rectWithX:r.x y:r.y w:r.w h:_scaledActiveTitleBarHeight];
    _titleBarTextRect = _titleBarRect;
    _titleBarTextRect.x = _scaledActiveTitleBarLeftWidth+10*_pixelScaling;
    _titleBarTextRect.w -= _scaledActiveTitleBarLeftWidth+10*_pixelScaling;
    _titleBarTextRect.w -= _scaledActiveTitleBarRightWidth+4*_pixelScaling;

    _leftBorderRect = r;
    _leftBorderRect.y += _scaledActiveTitleBarHeight;
    _leftBorderRect.h -= _scaledActiveTitleBarHeight;
    _leftBorderRect.h -= _bottomBorder;
    _leftBorderRect.w = _leftBorder;

    _rightBorderRect = r;
    _rightBorderRect.x += r.w-_rightBorder;
    _rightBorderRect.y += _scaledActiveTitleBarHeight;
    _rightBorderRect.h -= _scaledActiveTitleBarHeight;
    _rightBorderRect.h -= _bottomBorder;
    _rightBorderRect.w = _rightBorder;

    _topBorderRect = _titleBarRect;
    _topBorderRect.h = 4*_pixelScaling;

    _bottomBorderRect = _titleBarRect;
    _bottomBorderRect.y += r.h-_bottomBorder;
    _bottomBorderRect.h = _bottomBorder;

    _closeButtonRect = _titleBarRect;
    _closeButtonRect.w = 19*_pixelScaling;
    _closeButtonRect.h = 22*_pixelScaling;

    _maximizeButtonRect = _titleBarRect;
    _maximizeButtonRect.x = _maximizeButtonRect.x+_maximizeButtonRect.w-(23+23)*_pixelScaling;
    _maximizeButtonRect.w = 23*_pixelScaling;
    _maximizeButtonRect.h = 22*_pixelScaling;

    _lowerButtonRect = _titleBarRect;
    _lowerButtonRect.x = _lowerButtonRect.x+_lowerButtonRect.w-(23)*_pixelScaling;
    _lowerButtonRect.w = 23*_pixelScaling;
    _lowerButtonRect.h = 22*_pixelScaling;
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [self drawInBitmap:bitmap rect:r context:nil];
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r context:(id)context
{
    if (_scaledFont) {
        [bitmap useFont:[[_scaledFont nth:0] bytes]
                    :[[_scaledFont nth:1] bytes]
                    :[[_scaledFont nth:2] bytes]
                    :[[_scaledFont nth:3] bytes]];
    }

    char *palette = hasFocusPalette;
    int hasFocus = [context intValueForKey:@"hasFocus"];
    if (!hasFocus) {
        palette = noFocusPalette;
    }

    [self calculateRects:r];
    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRect:r];
    {
        char *left = [_scaledActiveTitleBarLeftPixels UTF8String];
        char *middle = [_scaledActiveTitleBarMiddlePixels UTF8String];
        char *right = [_scaledActiveTitleBarRightPixels UTF8String];
        [Definitions drawInBitmap:bitmap left:left palette:palette middle:middle palette:palette right:right palette:palette x:_titleBarRect.x y:_titleBarRect.y w:_titleBarRect.w];
    }
    if (_titleBarTextRect.w > 0) {
        id text = [context valueForKey:@"name"];
        if (!text) {
            text = @"(no title)";
        }

        text = [[[bitmap fitBitmapString:text width:_titleBarTextRect.w] split:@"\n"] nth:0];
        if (text) {
            if (hasFocus) {
                [bitmap setColor:@"black"];
                [bitmap drawBitmapText:text x:_titleBarTextRect.x y:_titleBarTextRect.y+2*_pixelScaling];
            } else {
                [bitmap setColor:@"black"];
                [bitmap drawBitmapText:text x:_titleBarTextRect.x y:_titleBarTextRect.y+2*_pixelScaling];
            }
        }
    }

    {
        char *middle = [_scaledLeftBorderMiddlePixels UTF8String];
        [Definitions drawInBitmap:bitmap top:middle palette:palette middle:middle palette:palette bottom:middle palette:palette x:_leftBorderRect.x y:_leftBorderRect.y h:_leftBorderRect.h];
    }
    {
        char *middle = [_scaledRightBorderMiddlePixels UTF8String];
        [Definitions drawInBitmap:bitmap top:middle palette:palette middle:middle palette:palette bottom:middle palette:palette x:_rightBorderRect.x y:_rightBorderRect.y h:_rightBorderRect.h];
    }

    {
        Int4 r = _bottomBorderRect;
        char *left = [_scaledBottomBorderLeftPixels UTF8String];
        char *middle = [_scaledBottomBorderMiddlePixels UTF8String];
        char *right = [_scaledBottomBorderRightPixels UTF8String];
        [Definitions drawInBitmap:bitmap left:left middle:middle right:right x:r.x y:r.y w:r.w palette:palette];
    }

    if (hasFocus) {
        if ((_buttonDown == 'c') && (_buttonHover == 'c')) {
            char *closeButtonDown = [_scaledCloseButtonDownPixels UTF8String];
            [bitmap drawCString:closeButtonDown palette:palette x:_closeButtonRect.x y:_closeButtonRect.y];
        }
        if ((_buttonDown == 'm') && (_buttonHover == 'm')) {
            char *maximizeButtonDown = [_scaledMaximizeButtonDownPixels UTF8String];
            [bitmap drawCString:maximizeButtonDown palette:palette x:_maximizeButtonRect.x y:_maximizeButtonRect.y];
        }
        if ((_buttonDown == 'l') && (_buttonHover == 'l')) {
            char *lowerButtonDown = [_scaledLowerButtonDownPixels UTF8String];
            [bitmap drawCString:lowerButtonDown palette:palette x:_lowerButtonRect.x y:_lowerButtonRect.y];
        }
        if ((_buttonDown == 't') || ((_buttonDown >= '1') && (_buttonDown <= '9'))) {
            {
                char *left = [_scaledSelectedTitleBarLeftPixels UTF8String];
                char *middle = [_scaledSelectedTitleBarMiddlePixels UTF8String];
                char *right = [_scaledSelectedTitleBarRightPixels UTF8String];
                [Definitions drawInBitmap:bitmap left:left palette:selectedPalette middle:middle palette:selectedPalette right:right palette:selectedPalette x:_titleBarRect.x y:_titleBarRect.y w:_titleBarRect.w];
            }
            {
                char *middle = [_scaledSelectedLeftBorderMiddlePixels UTF8String];
                [Definitions drawInBitmap:bitmap top:middle palette:selectedPalette middle:middle palette:selectedPalette bottom:middle palette:selectedPalette x:_leftBorderRect.x y:_leftBorderRect.y h:_leftBorderRect.h];
            }
            {
                char *middle = [_scaledSelectedRightBorderMiddlePixels UTF8String];
                [Definitions drawInBitmap:bitmap top:middle palette:selectedPalette middle:middle palette:selectedPalette bottom:middle palette:selectedPalette x:_rightBorderRect.x y:_rightBorderRect.y h:_rightBorderRect.h];
            }

            {
                Int4 r = _bottomBorderRect;
                char *left = [_scaledSelectedBottomBorderLeftPixels UTF8String];
                char *middle = [_scaledSelectedBottomBorderMiddlePixels UTF8String];
                char *right = [_scaledSelectedBottomBorderRightPixels UTF8String];
                [Definitions drawInBitmap:bitmap left:left middle:middle right:right x:r.x y:r.y w:r.w palette:selectedPalette];
            }
        }
    }

}
- (char)borderForX:(int)x y:(int)y w:(int)w h:(int)h
{
    if ((y >= 0) && (y < 4*_pixelScaling)) {
        if ((x >= 0) && (x < 23*_pixelScaling)) {
            return '7';
        } else if ((x >= w-23*_pixelScaling) && (x < w)) {
            return '9';
        } else {
            return '8';
        }
    } else if ((y >= h-4*_pixelScaling) && (y < h)) {
        if ((x >= 0) && (x < 23*_pixelScaling)) {
            return '1';
        } else if ((x >= w-23*_pixelScaling) && (x < w)) {
            return '3';
        } else {
            return '2';
        }
    } else if ((x >= 0) && (x < 4*_pixelScaling)) {
        if ((y >= 0) && (y < 23*_pixelScaling)) {
            return '7';
        } else if ((y >= h-23*_pixelScaling) && (y < h)) {
            return '1';
        } else {
            return '4';
        }
    } else if ((x >= w-4*_pixelScaling) && (x < w)) {
        if ((y >= 0) && (y < 23*_pixelScaling)) {
            return '9';
        } else if ((y >= h-23*_pixelScaling) && (y < h)) {
            return '3';
        } else {
            return '6';
        }
    }
    return 0;
}
- (void)handleMouseDown:(id)event context:(id)x11dict
{
    id windowManager = [Definitions windowManager];
    [windowManager setFocusDict:x11dict];
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if ([Definitions isX:mouseX y:mouseY insideRect:_closeButtonRect]) {
        _buttonDown = 'c';
        _buttonHover = 'c';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_maximizeButtonRect]) {
        _buttonDown = 'm';
        _buttonHover = 'm';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_lowerButtonRect]) {
        _buttonDown = 'l';
        _buttonHover = 'l';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        return;
    }
    int x11W = [x11dict intValueForKey:@"w"];
    int x11H = [x11dict intValueForKey:@"h"];
    int border = [self borderForX:mouseX y:mouseY w:x11W h:x11H];
    if (border) {
        _buttonDown = border;
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_titleBarRect]) {
        _buttonDown = 't';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        return;
    }
}
- (void)handleMouseMoved:(id)event context:(id)x11dict
{
    if (_buttonDown == 'c') {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_closeButtonRect]) {
            _buttonHover = 'c';
        } else {
            _buttonHover = 0;
        }
        return;
    }
    if (_buttonDown == 'm') {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_maximizeButtonRect]) {
            _buttonHover = 'm';
        } else {
            _buttonHover = 0;
        }
        return;
    }
    if (_buttonDown == 'l') {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_lowerButtonRect]) {
            _buttonHover = 'l';
        } else {
            _buttonHover = 0;
        }
        return;
    }

    if (_buttonDown == 't') {
        id windowManager = [Definitions windowManager];
        int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
        int mouseRootX = [event intValueForKey:@"mouseRootX"];
        int mouseRootY = [event intValueForKey:@"mouseRootY"];

        int newX = mouseRootX - _buttonDownX;
        int newY = mouseRootY - _buttonDownY;

        if (newX < 0) {
            newX = 0;
        }
        if (newY < menuBarHeight) {
            newY = menuBarHeight;
        }

        [x11dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];

        return;
    }

    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    int x = [x11dict intValueForKey:@"x"];
    int y = [x11dict intValueForKey:@"y"];
    int w = [x11dict intValueForKey:@"w"];
    int h = [x11dict intValueForKey:@"h"];
    id windowManager = [Definitions windowManager];
    if (!_buttonDown) {
        int border = [self borderForX:mouseX y:mouseY w:w h:h];
        if (border) {
            [windowManager setX11Cursor:border];
        } else {
            [windowManager setX11Cursor:'5'];
        }
        return;
    }

    if (_buttonDown == '4') {
        if (mouseY < 0) {
            _buttonDown = '7';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseY > h) {
            _buttonDown = '1';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newX = mouseRootX;
            int newWidth = x+w - mouseRootX;
            if (newWidth < _leftBorder+_rightBorder) {
                newWidth = _leftBorder+_rightBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", newX, y) forKey:@"moveWindow"];
            [x11dict setValue:nsfmt(@"%d %d", newWidth, h) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '6') {
        if (mouseY < 0) {
            _buttonDown = '9';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseY > h) {
            _buttonDown = '3';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newWidth = mouseX;
            if (newWidth < _leftBorder+_rightBorder) {
                newWidth = _leftBorder+_rightBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", newWidth, h) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '2') {
        if (mouseX < 0) {
            _buttonDown = '1';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseX > w) {
            _buttonDown = '3';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newHeight = mouseY;
            if (newHeight < _topBorder+_bottomBorder) {
                newHeight = _topBorder+_bottomBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", w, newHeight) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '8') {
        if (mouseX < 0) {
            _buttonDown = '7';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseX > w) {
            _buttonDown = '9';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newY = mouseRootY;
            int newHeight = y+h - mouseRootY;
            if (newHeight < _topBorder+_bottomBorder) {
                newHeight = _topBorder+_bottomBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", x, newY) forKey:@"moveWindow"];
            [x11dict setValue:nsfmt(@"%d %d", w, newHeight) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '1') {
        int newX = mouseRootX;
        int newWidth = x+w - mouseRootX;
        int newHeight = mouseY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", newX, y) forKey:@"moveWindow"];
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
    if (_buttonDown == '3') {
        int newWidth = mouseX;
        int newHeight = mouseY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
    if (_buttonDown == '7') {
        int newX = mouseRootX;
        int newY = mouseRootY;
        int newWidth = x+w - mouseRootX;
        int newHeight = y+h - mouseRootY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
    if (_buttonDown == '9') {
        int newY = mouseRootY;
        int newWidth = mouseX;
        int newHeight = y+h - mouseRootY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", x, newY) forKey:@"moveWindow"];
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
}
- (void)handleMouseUp:(id)event context:(id)x11dict
{
    if ((_buttonDown == 'c') && (_buttonHover == 'c')) {
        [x11dict x11CloseWindow];
    }
    if ((_buttonDown == 'm') && (_buttonHover == 'm')) {
        [x11dict x11ToggleMaximizeWindow];
    }
    if ((_buttonDown == 'l') && (_buttonHover == 'l')) {
        [x11dict x11LowerWindow];
    }
    if (_buttonDown == 't') {
        /* this was added for Wine */
        [x11dict x11MoveChildWindowBackAndForthForWine];
    }

    _buttonDown = 0;
}
@end

