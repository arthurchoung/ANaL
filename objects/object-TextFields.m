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

static unsigned char *textFieldLeftPixels =
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bX\n"
"oo\n"
;
static unsigned char *textFieldMiddlePixels =
"b\n"
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
"X\n"
"o\n"
;
static unsigned char *textFieldRightPixels =
"bb\n"
"bo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"Xo\n"
"oo\n"
;

static void drawTextFieldInBitmap_rect_(id bitmap, Int4 r)
{
    unsigned char *left = textFieldLeftPixels;
    unsigned char *middle = textFieldMiddlePixels;
    unsigned char *right = textFieldRightPixels;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:buttonPalette];
}



@implementation Definitions(fjdksljfklsdjfdsjkfljdsklfjkfjdskfjksdf)
+ (id)testTextFields
{
    id obj = [@"TextFields" asInstance];
    id fields = [@"field1:field2:field3:field4:field5:" splitTerminator:@":"];
    [obj setValue:@"JDLFKSJLKDFJKLDSJFKL" forKey:@"text"];
    [obj setValue:fields forKey:@"fields"];
    [obj setValue:@"OK" forKey:@"okText"];
    [obj setValue:@"Cancel" forKey:@"cancelText"];
//    [obj setValue:@"1" forKey:@"hidden"];
    return obj;
}
@end

@interface TextFields : IvarObject
{
    id _text;
    id _fields;
    id _buffers;
    id _readonly;
    int _cursorBlink;
    int _cursorPos;
    int _currentField;
    int _returnKeyDown;

    Int4 _okRect;
    Int4 _cancelRect;
    id _okText;
    id _cancelText;
    char _buttonDown;
    char _buttonHover;
    int _dialogMode;
    int _hidden;
}
@end
@implementation TextFields
- (int)preferredWidth
{
    return 640;
}
- (int)preferredHeight
{
    id bitmap = [Definitions bitmapWithWidth:1 height:1];
    int lineHeight = [bitmap bitmapHeightForText:@"X"];
    int h = 24;
    int w = 640-32;
    {
        id text = [bitmap fitBitmapString:_text width:w];
        h += [bitmap bitmapHeightForText:text] + lineHeight;
    }
    h += [_fields count]*(28+8);
    h += 16+27+8;
    return h;
}

- (void)handleBackgroundUpdate:(id)event
{
    _cursorBlink--;
    if (_cursorBlink < 0) {
        _cursorBlink = 1;
    }
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap useTopazFont];

    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRect:r];

    int lineHeight = [bitmap bitmapHeightForText:@"X"];

    // text

    int y = 24;

    {
        int textWidth = r.w - 32;
        id text = [bitmap fitBitmapString:_text width:textWidth];
        int textHeight = [bitmap bitmapHeightForText:text];
        [bitmap setColor:@"black"];
        [bitmap drawBitmapText:text x:16 y:y];
        y += textHeight + lineHeight;
    }

    int fieldWidth = 0;
    for (int i=0; i<[_fields count]; i++) {
        int w = [bitmap bitmapWidthForText:[_fields nth:i]];
        if (w > fieldWidth) {
            fieldWidth = w;
        }
    }

    {
        for (int i=0; i<[_fields count]; i++) {
            id field = [_fields nth:i];
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:field x:10+fieldWidth-[bitmap bitmapWidthForText:field] y:y+6+1];

            int x = 10 + fieldWidth + 10;
            Int4 fieldRect;
            fieldRect.x = x;
            fieldRect.y = y;
            fieldRect.w = r.w-x-18;
            fieldRect.h = 28;
            drawTextFieldInBitmap_rect_(bitmap, fieldRect);

            id str = [_buffers nth:i];
            if (!str) {
                str = @"";
            }
            if (_hidden) {
                str = [[[str mutableCopy] autorelease] destructiveReplaceCharactersNotInString:@"" withChar:'*'];
            }

            if (_currentField == i) {
                id left = [str stringToIndex:_cursorPos];
                id right = [str stringFromIndex:_cursorPos];
                if ([left length]) {
                    [bitmap setColor:@"black"];
                    [bitmap drawBitmapText:left x:x+8 y:y+6+1];
                    x += [bitmap bitmapWidthForText:left]+2;
                }
                if (_cursorBlink) {
                    [bitmap setColor:@"black"];
                    [bitmap drawVerticalLineAtX:x-1+8 y:y+4 y:y+23];
                }
                if ([right length]) {
                    [bitmap setColor:@"black"];
                    [bitmap drawBitmapText:right x:x+8 y:y+6+1];
                }
            } else {
                [bitmap setColor:@"black"];
                [bitmap drawBitmapText:str x:x+8 y:y+6+1];
            }

            y += 28+8;
        }
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
        Int4 innerRect = _cancelRect;
        innerRect.y += 2;
        innerRect.h -= 4;
        innerRect.x += 2;
        innerRect.w -= 4;
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

- (void)handleKeyDown:(id)event
{
    if (!_buffers) {
        id arr = nsarr();
        for (int i=0; i<[_fields count]; i++) {
            id elt = [_fields nth:i];
            [arr addObject:@""];
        }
        [self setValue:arr forKey:@"buffers"];
    }
    id buf = [_buffers nth:_currentField];
    id str = [event valueForKey:@"keyString"];
    if ([str isEqual:@"space"]) {
        str = @" ";
    }
    if ([str length] == 1) {
        if (![buf length]) {
            [_buffers replaceObjectAtIndex:_currentField withObject:str];
            _cursorPos = 1;
            _cursorBlink = 1;
        } else {
            id left = [buf stringToIndex:_cursorPos];
            id right = [buf stringFromIndex:_cursorPos];
            id newBuf = nsfmt(@"%@%@%@", left, str, right);
            [_buffers replaceObjectAtIndex:_currentField withObject:newBuf];
            _cursorPos++;
            _cursorBlink = 1;
        }
    } else if ([str isEqual:@"left"]) {
        if (_cursorPos - 1 >= 0) {
            _cursorPos--;
        }
        _cursorBlink = 1;
    } else if ([str isEqual:@"right"]) {
        if (_cursorPos + 1 <= [buf length]) {
            _cursorPos++;
        }
        _cursorBlink = 1;
    } else if ([str isEqual:@"backspace"]) {
        if (_cursorPos >= 1) {
            id left = (_cursorPos > 1) ? [buf stringToIndex:_cursorPos-1] : @"";
            id right = [buf stringFromIndex:_cursorPos];
            id newBuf = nsfmt(@"%@%@", left, right);
            [_buffers replaceObjectAtIndex:_currentField withObject:newBuf];
            _cursorPos--;
        }
        _cursorBlink = 1;
    } else if ([str isEqual:@"return"]) {
        _returnKeyDown = YES;
    } else if ([str isEqual:@"tab"]) {
        if ([_fields count] > 1) {
            _currentField++;
            if (_currentField >= [_fields count]) {
                _currentField = 0;
            }
            _cursorPos = [[_buffers nth:_currentField] length];
            _cursorBlink = 2;
        }
    } else if ([str isEqual:@"shifttab"]) {
        if ([_fields count] > 1) {
            _currentField--;
            if (_currentField < 0) {
                _currentField = [_fields count]-1;
            }
            _cursorPos = [[_buffers nth:_currentField] length];
            _cursorBlink = 2;
        }
    }
}
- (void)handleKeyUp:(id)event
{
    id str = [event valueForKey:@"keyString"];
    if ([str isEqual:@"return"]) {
        if (_returnKeyDown) {
            if (_dialogMode) {
                [self exitWithDialogMode];
            }
            id x11Dict = [event valueForKey:@"x11dict"];
            [x11Dict setValue:@"1" forKey:@"shouldCloseWindow"];
            _returnKeyDown = NO;
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
                [self exitWithDialogMode];
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
- (void)exitWithDialogMode
{
    for (int i=0; i<[_fields count]; i++) {
        id readonly = [_readonly nth:i];
        if (![readonly intValue]) {
            id field = [_fields nth:i];
            id buffer = [_buffers nth:i];
            if (_dialogMode == 1) {
                NSOut(@"%@\n", buffer);
            } else {
                NSErr(@"%@\n", buffer);
            }
        }
    }
    exit(0);
}
@end

