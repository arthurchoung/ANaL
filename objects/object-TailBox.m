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

static unsigned char *buttonPalette =
"b #000000\n"
". #555555\n"
"X #AAAAAA\n"
"o #ffffff\n"
;

static unsigned char *buttonLeftPixels =
"oo\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"oX\n"
"o.\n"
"bb\n"
;
static unsigned char *buttonMiddlePixels =
"o\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
".\n"
"b\n"
;
static unsigned char *buttonRightPixelsWithArrow =
"ooooooooooooooooooob\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXbbbb.XXX.b\n"
"XXXXbbXXXXbXXXoXXX.b\n"
"XXXb..XXXXbXXXoXXX.b\n"
"XXb.X.bbbbbXXXoXXX.b\n"
"Xb.XXXXXXXXXXXoXXX.b\n"
"b.XXXXXXXXXXXXoXXX.b\n"
"XbXXXXXXXXXXXXoXXX.b\n"
"XXbXXooooooooooXXX.b\n"
"XXXbXoXXXXXXXXXXXX.b\n"
"XXXXboXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"XXXXXXXXXXXXXXXXXX.b\n"
"...................b\n"
"bbbbbbbbbbbbbbbbbbbb\n"
;
static unsigned char *buttonRightPixels =
"ob\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
".b\n"
"bb\n"
;
static unsigned char *buttonDownLeftPixels =
"bb\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"bo\n"
"oo\n"
;
static unsigned char *buttonDownMiddlePixels =
"b\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
"o\n"
;
static unsigned char *buttonDownRightPixelsWithArrow =
"bbbbbbbbbbbbbbbbbbo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"oooooooooobbbb.oooo\n"
"oooobbooooboooXoooo\n"
"ooob..ooooboooXoooo\n"
"oob.o.bbbbboooXoooo\n"
"ob.oooooooooooXoooo\n"
"b.ooooooooooooXoooo\n"
"obooooooooooooXoooo\n"
"oobooXXXXXXXXXXoooo\n"
"oooboXooooooooooooo\n"
"oooobXooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
"ooooooooooooooooooo\n"
;
static unsigned char *buttonDownRightPixels =
"bo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
"oo\n"
;

static void drawButtonInBitmap_rect_(id bitmap, Int4 r)
{
    unsigned char *left = buttonLeftPixels;
    unsigned char *middle = buttonMiddlePixels;
    unsigned char *right = buttonRightPixels;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:buttonPalette];
}
static void drawDefaultButtonInBitmap_rect_(id bitmap, Int4 r)
{
    unsigned char *left = buttonLeftPixels;
    unsigned char *middle = buttonMiddlePixels;
    unsigned char *right = buttonRightPixelsWithArrow;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:buttonPalette];
}
static void drawButtonDownInBitmap_rect_(id bitmap, Int4 r)
{
    unsigned char *left = buttonDownLeftPixels;
    unsigned char *middle = buttonDownMiddlePixels;
    unsigned char *right = buttonDownRightPixels;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:buttonPalette];
}
static void drawDefaultButtonDownInBitmap_rect_(id bitmap, Int4 r)
{
    unsigned char *left = buttonDownLeftPixels;
    unsigned char *middle = buttonDownMiddlePixels;
    unsigned char *right = buttonDownRightPixelsWithArrow;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:buttonPalette];
}




@implementation Definitions(fjejfksdljfklsdjfkkwlfmkldsmfkldsjflkfjdskfjksd)
+ (id)testTailBox:(id)filePath
{
    id obj = [@"TailBox" asInstance];
    [obj setValue:@"TITLE" forKey:@"text"];
    [obj setValue:filePath forKey:@"path"];
    [obj setValue:@"OK" forKey:@"okText"];
    return obj;
}
@end
@interface TailBox : IvarObject
{
    id _path;
    time_t _timestamp;
    id _text;
    id _fileText;
    Int4 _okRect;
    Int4 _cancelRect;
    id _okText;
    id _cancelText;
    char _buttonDown;
    char _buttonHover;
    int _dialogMode;
    int _returnKeyDown;
}
@end
@implementation TailBox
- (int)preferredWidth
{
    return 480;
}
- (int)preferredHeight
{
    if (!_text && !_fileText) {
        return 288;
    }
    id bitmap = [Definitions bitmapWithWidth:1 height:1];
    id text1 = [bitmap fitBitmapString:_text width:480-89-18];
    int textHeight1 = [bitmap bitmapHeightForText:text1];
    id text2 = [bitmap fitBitmapString:_fileText width:480-89-18];
    int textHeight2 = [bitmap bitmapHeightForText:text2];
    int textHeight = 24 + textHeight1 + 16 + textHeight2 + 21 + 28 + 21;
    if (textHeight > 288) {
        return textHeight;
    }
    return 288;
}
- (void)handleBackgroundUpdate:(id)event
{
    time_t timestamp = [_path fileModificationTimestamp];
    if (timestamp != _timestamp) {
        _timestamp = 0;
    }
}
- (void)beginIteration:(id)event rect:(Int4)r
{
    if (!_timestamp) {
        _timestamp = [_path fileModificationTimestamp];
        id text = [_path stringFromFile];
        [self setValue:text forKey:@"fileText"];
    }
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap useTopazFont];

    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRect:r];

    int x = 16;
    int y = 24;

    // text

    int textWidth = r.w - 32;
    if (_text) {
        id text = [bitmap fitBitmapString:_text width:textWidth];
        int textHeight = [bitmap bitmapHeightForText:text];
        [bitmap setColor:@"black"];
        [bitmap drawBitmapText:text x:x y:y];
        y += textHeight + 16;
    }

    if (_fileText) {
        id text = [bitmap fitBitmapString:_fileText width:textWidth];
        [bitmap drawBitmapText:text x:x y:y];
        int textHeight = [bitmap bitmapHeightForText:text];
        y += textHeight;
    }


    // ok button

    if (_okText) {
        _okRect = [Definitions rectWithX:r.w-78 y:r.h-8-27 w:70 h:27];
        Int4 innerRect = _okRect;
        innerRect.y += 2;
        innerRect.h -= 4;
        innerRect.x += 2;
        innerRect.w -= (2 + 20);
        if (_returnKeyDown || ((_buttonDown == 'o') && (_buttonHover == 'o'))) {
            drawDefaultButtonDownInBitmap_rect_(bitmap, _okRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:@"OK" centeredInRect:innerRect];
        } else {
            drawDefaultButtonInBitmap_rect_(bitmap, _okRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:@"OK" centeredInRect:innerRect];
        }
    } else {
        _okRect.x = 0;
        _okRect.y = 0;
        _okRect.w = 0;
        _okRect.h = 0;
    }

    // cancel button

    if (_cancelText) {
        _cancelRect = [Definitions rectWithX:_okRect.x-70-8 y:r.h-8-27 w:70 h:27];
        if ((_buttonDown == 'c') && (_buttonHover == 'c')) {
            drawButtonDownInBitmap_rect_(bitmap, _cancelRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:_cancelText centeredInRect:_cancelRect];
        } else {
            drawButtonInBitmap_rect_(bitmap, _cancelRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:_cancelText centeredInRect:_cancelRect];
        }
    } else {
        _cancelRect.x = 0;
        _cancelRect.y = 0;
        _cancelRect.w = 0;
        _cancelRect.h = 0;
    }



}
- (void)handleMouseDown:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if (_okText && [Definitions isX:mouseX y:mouseY insideRect:_okRect]) {
        _buttonDown = 'o';
        _buttonHover = 'o';
    } else if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _buttonDown = 'c';
        _buttonHover = 'c';
    } else {
        _buttonDown = 0;
        _buttonHover = 0;
    }
}
- (void)handleMouseMoved:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if (_okText && [Definitions isX:mouseX y:mouseY insideRect:_okRect]) {
        _buttonHover = 'o';
    } else if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _buttonHover = 'c';
    } else {
        _buttonHover = 0;
    }
}
- (void)handleMouseUp:(id)event
{
    if (_buttonDown == _buttonHover) {
        if (_buttonDown == 'o') {
            if (_dialogMode) {
                exit(0);
            }
            id x11dict = [event valueForKey:@"x11dict"];
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
        } else if (_buttonDown == 'c') {
            if (_dialogMode) {
                exit(1);
            }
            id x11dict = [event valueForKey:@"x11dict"];
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
        }
    }
    _buttonDown = 0;
    _buttonHover = 0;
}
- (void)handleKeyDown:(id)event
{
    id keyString = [event valueForKey:@"keyString"];
    if ([keyString isEqual:@"return"]) {
        _returnKeyDown = YES;
    }
}
- (void)handleKeyUp:(id)event
{
    id str = [event valueForKey:@"keyString"];
    if ([str isEqual:@"return"]) {
        if (_returnKeyDown) {
            if (_dialogMode) {
                exit(0);
            }
            id x11Dict = [event valueForKey:@"x11dict"];
            [x11Dict setValue:@"1" forKey:@"shouldCloseWindow"];
            _returnKeyDown = NO;
        }
    }
}
@end

