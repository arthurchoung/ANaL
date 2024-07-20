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

#define BUFSIZE 16384

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



@implementation Definitions(fjekwlfmkldsmfkldsjflfjdskfjkdsk)
+ (id)testPrgBox:(id)cmd
{
    id process = [cmd runCommandAndReturnProcessWithError];
    id obj = [@"PrgBox" asInstance];
    [obj setValue:cmd forKey:@"command"];
    [obj setValue:process forKey:@"process"];
    [obj setValue:@"TITLE" forKey:@"text"];
    [obj setValue:@"OK" forKey:@"okText"];
    return obj;
}
@end

@interface PrgBox : IvarObject
{
    id _command;
    id _process;
    char _separator;
    id _text;
    int _returnKeyDown;
    Int4 _okRect;
    id _okText;
    char _buttonDown;
    char _buttonHover;
    int _dialogMode;
}
@end
@implementation PrgBox
- (int)preferredWidth
{
    return 640;
}
- (int)preferredHeight
{
    return 400;
}
- (int *)fileDescriptors
{
    if ([_process respondsToSelector:@selector(fileDescriptors)]) {
        return [_process fileDescriptors];
    }
    return 0;
}
- (void)handleFileDescriptor:(int)fd
{
    if (_process) {
        [_process handleFileDescriptor:fd];
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

    // text

    [bitmap setColor:@"black"];

    int y = r.y+16;

    {
        id status = [_process valueForKey:@"status"];
        if (!status) {
            int pid = [_process intValueForKey:@"pid"];
            if (pid) {
                status = nsfmt(@"Running (PID %d)", pid);
            } else {
                status = @"Not Running";
            }
        }
        id text = nsfmt(@"Status: %@\nCommand: %@", status, [_command join:@" "]);
        text = [bitmap fitBitmapString:text width:r.w-16*2];
        [bitmap drawBitmapText:text x:r.x+16 y:y];
        int textHeight = [bitmap bitmapHeightForText:text];
        y += textHeight + 16;
    }

    if (_text) {
        id text = [bitmap fitBitmapString:_text width:r.w-16*2];
        [bitmap drawBitmapText:text x:r.x+16 y:y];
        int textHeight = [bitmap bitmapHeightForText:text];
        y += textHeight + 16;
    }

    if (_process) {
        id outtext = [[_process valueForKey:@"data"] asString];
        if (!outtext) {
            outtext = @"";
        }
        id errtext = [[_process valueForKey:@"errdata"] asString];
        if (!errtext) {
            errtext = @"";
        }
        id text = nsfmt(@"%@\n%@", outtext, errtext);
        text = [bitmap fitBitmapString:text width:r.w-16*2];
        [bitmap drawBitmapText:text x:r.x+16 y:y];
        y += 32;
    }

    // ok button

    _okRect.x = 0;
    _okRect.y = 0;
    _okRect.w = 0;
    _okRect.h = 0;
    if (_okText) {
        id okText = _okText;
        if (![_process valueForKey:@"status"]) {
            okText = @"Stop";
        }

        int textWidth = [bitmap bitmapWidthForText:okText];
        int innerWidth = 50;
        if (textWidth > innerWidth) {
            innerWidth = textWidth;
        }
        _okRect.x = r.x+r.w-10-(innerWidth+16);
        _okRect.y = r.y+r.h-40;
        _okRect.w = innerWidth+16;
        _okRect.h = 27;
        Int4 innerRect = _okRect;
        innerRect.y += 2;
        innerRect.h -= 4;
        innerRect.x += 2;
        innerRect.w -= (2 + 20);
        if (_returnKeyDown || ((_buttonDown == 'o') && (_buttonHover == 'o'))) {
            drawDefaultButtonDownInBitmap_rect_(bitmap, _okRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:okText centeredInRect:innerRect];
        } else {
            drawDefaultButtonInBitmap_rect_(bitmap, _okRect);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:okText centeredInRect:innerRect];
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
            id status = [_process valueForKey:@"status"];
            if (!status) {
                [_process sendSignal:SIGTERM];
            } else {
                if (_dialogMode) {
                    exit(0);
                }
                id x11dict = [event valueForKey:@"x11dict"];
                [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
            }
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
            id x11dict = [event valueForKey:@"x11dict"];
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
            _returnKeyDown = NO;
        }
    }
}
@end

