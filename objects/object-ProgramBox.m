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




#define BUFSIZE 16384

@implementation Definitions(fjekwlfmkldsmfkldsjflkfjdskfjksd)
+ (id)testProgramBox
{
    id obj = [@"ProgramBox" asInstance];
    [obj setValue:@"TITLE" forKey:@"text"];
    [obj setValue:@"OK" forKey:@"okText"];
    return obj;
}
@end

@interface ProgramBox : IvarObject
{
    char _separator;
    BOOL _eof;
    id _text;
    id _line;
    int _returnKeyDown;
    Int4 _okRect;
    id _okText;
    char _buttonDown;
    char _buttonHover;
    int _dialogMode;
    id _partialLine;
}
@end
@implementation ProgramBox
- (int)preferredWidth
{
    return 640;
}
- (int)preferredHeight
{
    return 400;
}
- (int)fileDescriptor
{
    if (_eof) {
        return -1;
    }
    return 0;
}
- (void)handleFileDescriptorOld
{
    if (_eof) {
        return;
    }
    char buf[BUFSIZE];
    int n = read(0, buf, BUFSIZE-1);
    if (n < 0) {
        // error, actually
        _eof = YES;
        return;
    }
    if (n == 0) {
        _eof = YES;
        return;
    }
    int sep = (_separator) ? _separator : '\r';
    buf[n] = 0;
    char *p = &buf[0];
    for (int i=n-1; i>=0; i--) {
        if (buf[i] == sep) {
            if (buf[i+1]) {
                p = &buf[i+1];
                break;
            }
            buf[i] = 0;
        }
    }
    id line = nsfmt(@"%s", p);
    [self setValue:line forKey:@"line"];
}
- (void)handleFileDescriptor
{
    if (_eof) {
        return;
    }
    char buf[BUFSIZE];
    int n = read(0, buf, BUFSIZE-1);
    if (n < 0) {
        // error, actually
        _eof = YES;
        return;
    }
    if (n == 0) {
        _eof = YES;
        return;
    }
    int sep = (_separator) ? _separator : '\r';
    buf[n] = 0;
    char *p = &buf[0];
    for(;;) {
        char *q = strchr(p, sep);
        if (q) {
            id line = nscstrn(p, q-p);
            q++;
            if (_partialLine) {
                line = nsfmt(@"%@%@", _partialLine, line);
                [self setValue:line forKey:@"line"];
                [self setValue:nil forKey:@"partialLine"];
            } else {
                [self setValue:line forKey:@"line"];
            }
            p = q;
        } else {
            if (*p) {
                id line = nsfmt(@"%s", p);
                if (_partialLine) {
                    line = nsfmt(@"%@%@", _partialLine, line);
                    [self setValue:line forKey:@"partialLine"];
                } else {
                    [self setValue:line forKey:@"partialLine"];
                }
            }
            break;
        }
    }

}
- (void)endIteration:(id)event
{
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

    if (_line) {
        id text = [bitmap fitBitmapString:_line width:textWidth];
        [bitmap drawBitmapText:text x:x y:y];
        y += 32;
    }

    // ok button

    _okRect.x = 0;
    _okRect.y = 0;
    _okRect.w = 0;
    _okRect.h = 0;
    if (_okText) {
        if (_eof) {
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
            id text = @"Please wait...";
            int textWidth = [bitmap bitmapWidthForText:text];
            [bitmap setColor:@"black"];
            Int4 textRect = [Definitions rectWithX:r.w-8-textWidth y:r.h-8-27 w:70 h:27];
            [bitmap drawBitmapText:text centeredInRect:textRect];
        }
    }

}
- (void)handleMouseDown:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if (_okText && [Definitions isX:mouseX y:mouseY insideRect:_okRect]) {
        _buttonDown = 'o';
        _buttonHover = 'o';
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
    id keyString = [event valueForKey:@"keyString"];
    if ([keyString isEqual:@"return"]) {
        if (_returnKeyDown) {
            if (_eof) {
                if (_dialogMode) {
                    exit(0);
                }
                id x11dict = [event valueForKey:@"x11dict"];
                [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
            }
            _returnKeyDown = NO;
        }
    }
}
@end
