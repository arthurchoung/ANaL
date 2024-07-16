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

static unsigned char *checkboxPixels =
"oooooooooooooob\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"oXXXXXXXXXXXX.b\n"
"o.............b\n"
"bbbbbbbbbbbbbbb\n"
;
static unsigned char *checkboxSelectedPixels =
"               \n"
"               \n"
"           o   \n"
"          ob   \n"
"         ob.   \n"
"   ob   ob.    \n"
"   ob  ob.     \n"
"   ob.ob.      \n"
"   o.ob.       \n"
"   oob.        \n"
"   ob.         \n"
"   b.          \n"
"               \n"
"               \n"
"               \n"
;
static unsigned char *checkboxDownPixels =
"bbbbbbbbbbbbbbo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"boooooooooooooo\n"
"ooooooooooooooo\n"
;

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





#define MAX_CHECKBOXES 20

@implementation Definitions(fjewmfnkdslnfsdjflfjdskfjksldjfkk)
+ (id)Checklist
{
    id lines = [Definitions linesFromStandardInput];
    id obj = [@"Checklist" asInstance];
    [obj setValue:@"jfkdlsjflkdsjfkljdsklf" forKey:@"text"];
    [obj setValue:lines forKey:@"array"];
    [obj setValue:@"OK" forKey:@"okText"];
    [obj setValue:@"Cancel" forKey:@"cancelText"];
    [obj setValue:@"1" forKey:@"dialogMode"];
    return obj;
}
@end

@interface Checklist : IvarObject
{
    int _dialogMode;
    id _text;
    id _array;
    BOOL _checked[MAX_CHECKBOXES];
    Int4 _rect[MAX_CHECKBOXES];
    char _down;
    char _hover;
    Int4 _okRect;
    Int4 _cancelRect;
    id _okText;
    id _cancelText;
    int _returnKeyDown;
}
@end
@implementation Checklist
- (BOOL)getCheckedForIndex:(int)index
{
    if ((index >= 0) && (index < MAX_CHECKBOXES)) {
        return _checked[index];
    }
    return NO;
}
- (void)setChecked:(BOOL)checked forIndex:(int)index
{
    if ((index >= 0) && (index < MAX_CHECKBOXES)) {
        _checked[index] = checked;
    }
}
- (int)preferredWidth
{
    return 640;
}
- (int)preferredHeight
{
    id bitmap = [Definitions bitmapWithWidth:1 height:1];
    int lineHeight = [bitmap bitmapHeightForText:@"X"];
    int checkboxWidth = [Definitions widthForCString:checkboxPixels];
    int h = 24;
    int w = 640;
    {
        id text = [bitmap fitBitmapString:_text width:w-32];
        h += [bitmap bitmapHeightForText:text] + lineHeight;
    }
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id text = [elt valueForKey:@"text"];
        if (!text) {
            text = elt;
        }
        text = [bitmap fitBitmapString:text width:w-checkboxWidth-10-lineHeight];
        h += [bitmap bitmapHeightForText:text] + lineHeight/2;
    }
    h += 16 + 27 + 8;
    return h;
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap useTopazFont];

    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRect:r];

    int x = 16;
    int y = 24;

    int lineHeight = [bitmap bitmapHeightForText:@"X"];

    // text

    {
        int textWidth = r.w - x - 16;
        id text = [bitmap fitBitmapString:_text width:textWidth];
        int textHeight = [bitmap bitmapHeightForText:text];
        [bitmap setColor:@"black"];
        [bitmap drawBitmapText:text x:x y:y];
        y += textHeight + lineHeight;
    }

    // buttons

    int checkboxWidth = [Definitions widthForCString:checkboxPixels];
    int checkboxHeight = [Definitions heightForCString:checkboxPixels];
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id text = [elt valueForKey:@"text"];
        if (!text) {
            text = elt;
        }
        _rect[i].x = x;
        _rect[i].y = y;
        text = [bitmap fitBitmapString:text width:r.w-checkboxWidth-10-(x-r.x)-20];
        int textWidth = [bitmap bitmapWidthForText:text];
        int textHeight = [bitmap bitmapHeightForText:text];
        _rect[i].w = checkboxWidth+10+textWidth;
        _rect[i].h = textHeight;
        BOOL isCheckboxDown = NO;
        if ((_down==i+1) && (_hover==i+1)) {
            isCheckboxDown = YES;
        }
        if (isCheckboxDown) {
            [bitmap drawCString:checkboxDownPixels palette:buttonPalette x:x y:y];
        } else {
            [bitmap drawCString:checkboxPixels palette:buttonPalette x:x y:y];
        }
        if ([self getCheckedForIndex:i]) {
            [bitmap drawCString:checkboxSelectedPixels palette:buttonPalette x:x y:y];
        }
        [bitmap drawBitmapText:text x:x+checkboxWidth+10 y:y+1];
        y += textHeight + lineHeight/2;
    }

    // ok button

    if (_okText) {
        _okRect = [Definitions rectWithX:r.w-78 y:r.h-8-27 w:70 h:27];
        Int4 innerRect = _okRect;
        innerRect.y += 2;
        innerRect.h -= 4;
        innerRect.x += 2;
        innerRect.w -= (2 + 20);
        if (_returnKeyDown || ((_down == 'o') && (_hover == 'o'))) {
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
        if ((_down == 'c') && (_hover == 'c')) {
            drawButtonDownInBitmap_rect_(bitmap, _cancelRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:_cancelText centeredInRect:innerRect];
        } else {
            drawButtonInBitmap_rect_(bitmap, _cancelRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:_cancelText centeredInRect:innerRect];
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
        _down = 'o';
        _hover = 'o';
        return;
    }
    if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _down = 'c';
        _hover = 'c';
        return;
    }
    for (int i=0; i<[_array count]; i++) {
        if ([Definitions isX:mouseX y:mouseY insideRect:_rect[i]]) {
            _down = i+1;
            _hover = i+1;
            return;
        }
    }
    _down = 0;
    _hover = 0;
}
- (void)handleMouseMoved:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if (_okText && [Definitions isX:mouseX y:mouseY insideRect:_okRect]) {
        _hover = 'o';
        return;
    }
    if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _hover = 'c';
        return;
    }
    for (int i=0; i<[_array count]; i++) {
        if ([Definitions isX:mouseX y:mouseY insideRect:_rect[i]]) {
            _hover = i+1;
            return;
        }
    }
    _hover = 0;
}
- (void)handleMouseUp:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];

    if (_down && (_down == _hover)) {
        if (_down == 'o') {
            if (_dialogMode) {
                [self exitWithDialogMode];
            }
        } else if (_down == 'c') {
            if (_dialogMode) {
                exit(1);
            }
        } else {
            if ([self getCheckedForIndex:_down-1]) {
                [self setChecked:NO forIndex:_down-1];
            } else {
                [self setChecked:YES forIndex:_down-1];
            }
        }
    }
    _down = 0;
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
                [self exitWithDialogMode];
            }
            id x11Dict = [event valueForKey:@"x11dict"];
            [x11Dict setValue:@"1" forKey:@"shouldCloseWindow"];
            _returnKeyDown = NO;
        }
    }
}
- (void)exitWithDialogMode
{
    BOOL first = YES;
    for (int i=0; i<[_array count]; i++) {
        if ([self getCheckedForIndex:i]) {
            id elt = [_array nth:i];
            id tag = [elt valueForKey:@"tag"];
            if (first) {
                first = NO;
            } else {
                if (_dialogMode == 1) {
                    NSOut(@" ");
                } else {
                    NSErr(@" ");
                }
            }
            if (_dialogMode == 1) {
                NSOut(@"%@", (tag) ? tag : elt);
            } else {
                NSErr(@"%@", (tag) ? tag : elt);
            }
        }
    }
    exit(0);
}
@end

