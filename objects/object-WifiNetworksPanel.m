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

#define MAX_RECT 640

@implementation Definitions(fjekwlmfkldsmfklsdfm)
+ (id)WifiNetworksPanel
{
    id obj = [@"WifiNetworksPanel" asInstance];
    id lines = nsarr();
    [lines addObject:@"panelHorizontalStripes"];
    [lines addObject:@"panelText:'Wireless Networks'"];
    [lines addObject:@"panelText:''"];
    [lines addObject:@"panelText:'Choose a network ESSID:'"];
    [lines addObject:@"panelText:''"];
    [lines addObject:@"panelText:'Scanning...'"];
    [obj setValue:lines forKey:@"array"];
    return obj;
}
@end


static void drawStripedBackgroundInBitmap_rect_(id bitmap, Int4 r)
{
    [bitmap setColorIntR:205 g:212 b:222 a:255];
    [bitmap fillRectangleAtX:r.x y:r.y w:r.w h:r.h];
    [bitmap setColorIntR:201 g:206 b:209 a:255];
    for (int i=6; i<r.w; i+=10) {
        [bitmap fillRectangleAtX:r.x+i y:r.y w:4 h:r.h];
    }
}


static unsigned char *button_top_left = 
"   b\n"
" bb.\n"
" b..\n"
;
static unsigned char *button_top_middle = 
"b\n"
".\n"
".\n"
;
static unsigned char *button_top_right = 
"b   \n"
".bb \n"
"..b \n"
;

static unsigned char *button_middle_left =
"b...\n"
;
static unsigned char *button_middle_middle =
".\n"
;
static unsigned char *button_middle_right =
"...b\n"
;

static unsigned char *button_bottom_left =
" b..\n"
" bb.\n"
"   b\n"
;
static unsigned char *button_bottom_middle =
".\n"
".\n"
"b\n"
;
static unsigned char *button_bottom_right =
"..b \n"
".bb \n"
"b   \n"
;

static unsigned char *button_top_left_squared = 
"bbbb\n"
"b...\n"
"b...\n"
;
static unsigned char *button_top_right_squared = 
"bbbb\n"
"...b\n"
"...b\n"
;

static unsigned char *button_bottom_left_squared =
"b...\n"
"b...\n"
"bbbb\n"
;
static unsigned char *button_bottom_right_squared =
"...b\n"
"...b\n"
"bbbb\n"
;


@interface WifiNetworksPanel : IvarObject
{
    id _lastLine;
    id _array;
    Int4 _rect[MAX_RECT];
    id _buttons;
    id _buttonDicts;
    char _buttonType[MAX_RECT];
    int _buttonDown;
    int _buttonHover;
    int _buttonDownX;
    int _buttonDownY;
    int _buttonDownOffsetX;
    int _buttonDownOffsetY;
    int _buttonDownMinKnobX;
    int _buttonDownMaxKnobX;
    double _buttonDownKnobPct;
    int _scrollY;

    id _bitmap;
    Int4 _r;
    int _cursorY;

    BOOL _standardInputEOF;
    id _standardInputData;
}
@end
@implementation WifiNetworksPanel
- (id)hoverObject
{
    if (_buttonHover) {
        return [_buttonDicts nth:_buttonHover-1];
    }
    return nil;
}
- (int)fileDescriptor
{
    if (_standardInputEOF) {
        return -1;
    }
    return 0;
}
- (void)handleFileDescriptor
{
    if (_standardInputEOF) {
        return;
    }
    if (!_standardInputData) {
        [self setValue:nsdata() forKey:@"standardInputData"];
    }
    char buf[4096];
    int n = read(0, buf, 4096);
    if (n <= 0) {
        _standardInputEOF = YES;
        id lines = [[_standardInputData asString] split:@"\n"];
        [self setValue:lines forKey:@"array"];
        return;
    }
    [_standardInputData appendBytes:buf length:n];
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRect:r];

    [self setValue:nsarr() forKey:@"buttons"];
    [self setValue:nsarr() forKey:@"buttonDicts"];

    _cursorY = -_scrollY + r.y + 5;
    _r = r;

    [self setValue:bitmap forKey:@"bitmap"];
    for (int i=0; i<[_array count]; i++) {
        if (_cursorY >= r.y + r.h) {
            break;
        }
        if ([_buttons count] >= MAX_RECT) {
            [self panelText:@"MAX_RECT reached"];
            break;
        }
        id elt = [_array nth:i];
        if ([elt hasPrefix:@"="]) {
            char *p = [elt UTF8String];
            p++;
            char *q = strchr(p, '=');
            if (q) {
                int len = q - p;
                if (len > 0) {
                    id key = nsfmt(@"%.*s", len, p);
                    id val = nsfmt(@"%s", q+1);
                    [val setAsValueForKey:key];
                }
            }
        } else {
            [self evaluateMessage:elt];
        }
    }
    [self setValue:nil forKey:@"bitmap"];
}
- (void)panelFillWithColor:(id)color
{
    [_bitmap setColor:color];
    [_bitmap fillRect:_r];
}
- (void)panelStripedBackground
{
    drawStripedBackgroundInBitmap_rect_(_bitmap, _r);
}

- (void)panelColor:(id)color
{
    [_bitmap setColor:color];
}

- (void)panelBlankSpace:(int)h
{
    _cursorY += h;
}
- (void)panelLine
{
    [self panelLine:1];
}

- (void)panelLine:(int)h
{
    if (h == 1) {
        [_bitmap drawHorizontalLineAtX:_r.x x:_r.x+_r.w-1 y:_cursorY];
    } else if (h > 1) {
        [_bitmap fillRectangleAtX:_r.x y:_cursorY w:_r.w h:h];
    }
    _cursorY += h;
}

- (void)panelText:(id)text color:(id)color backgroundColor:(id)backgroundColor
{
    text = [_bitmap fitBitmapString:text width:_r.w-20];
    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    [_bitmap setColor:backgroundColor];
    [_bitmap fillRectangleAtX:_r.x y:_cursorY w:_r.w h:textHeight];

    int x = _r.x;
    x += (_r.w - textWidth) / 2;
    if (color) {
        [_bitmap setColor:color];
    }
    [_bitmap drawBitmapText:text x:x y:_cursorY];
    _cursorY += textHeight;
}
- (void)panelText:(id)text color:(id)color
{
    text = [_bitmap fitBitmapString:text width:_r.w-20];
    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    int x = _r.x;
    x += (_r.w - textWidth) / 2;
    if (color) {
        [_bitmap setColor:color];
    }
    [_bitmap drawBitmapText:text x:x y:_cursorY];
    _cursorY += textHeight;
}
- (void)panelText:(id)text
{
    [self panelText:text color:@"black"];
}
- (void)panelTopButton:(id)origText message:(id)message
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];

    [self panelButton:text origText:origText message:message leftMargin:0 width:_r.w-20 :button_top_left :button_top_middle :button_top_right :button_bottom_left_squared :button_bottom_middle :button_bottom_right_squared];
}
- (void)panelMiddleButton:(id)origText message:(id)message
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];
    _cursorY -= 1;
    [self panelButton:text origText:origText message:message leftMargin:0 width:_r.w-20 :button_top_left_squared :button_top_middle :button_top_right_squared :button_bottom_left_squared :button_bottom_middle :button_bottom_right_squared];
}
- (void)panelBottomButton:(id)origText message:(id)message
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];
    _cursorY -= 1;
    [self panelButton:text origText:origText message:message leftMargin:0 width:_r.w-20 :button_top_left_squared :button_top_middle :button_top_right_squared :button_bottom_left :button_bottom_middle :button_bottom_right];
}
- (void)panelSingleButton:(id)origText message:(id)message
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];
    [self panelButton:text origText:origText message:message leftMargin:0 width:_r.w-20 :button_top_left :button_top_middle :button_top_right :button_bottom_left :button_bottom_middle :button_bottom_right];
}
- (void)panelButton:(id)origText message:(id)message
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];
    int textWidth = [_bitmap bitmapWidthForText:text];
    
    [self panelButton:text origText:origText message:message leftMargin:0 width:textWidth+20 :button_top_left :button_top_middle :button_top_right :button_bottom_left :button_bottom_middle :button_bottom_right];
}
- (void)panelButton:(id)text origText:(id)origText message:(id)message leftMargin:(int)leftMargin width:(int)width :(unsigned char *)top_left :(unsigned char *)top_middle :(unsigned char *)top_right :(unsigned char *)bottom_left :(unsigned char *)bottom_middle :(unsigned char *)bottom_right
{
    int buttonIndex = [_buttons count];
    [_buttons addObject:(message) ? message : @""];
    id buttonDict = nsdict();
    [buttonDict setValue:origText forKey:@"text"];
    [_buttonDicts addObject:buttonDict];
    _buttonType[buttonIndex] = 'b';

    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    Int4 r1;
    r1.x = _r.x;
    r1.y = _cursorY;
    r1.w = width;
    r1.h = textHeight + 10;
    r1.x += (_r.w - r1.w) / 2;
    _rect[buttonIndex] = r1;
    
    char *palette = "b #000000\n. #ffffff\n";
    id textColor = @"#000000";

    if (_buttonType[buttonIndex] == 'b') {
        if ((_buttonDown-1 == buttonIndex) && (_buttonDown == _buttonHover)) {
            palette = "b #000000\n. #0000ff\n";
            textColor = @"#ffffff";
        } else if (!_buttonDown && (_buttonHover-1 == buttonIndex)) {
            palette = "b #000000\n. #000000\n";
            textColor = @"#ffffff";
        }
    }

    [Definitions drawInBitmap:_bitmap left:top_left middle:top_middle right:top_right x:r1.x y:r1.y w:r1.w palette:palette];
    for (int buttonY=r1.y+3; buttonY<r1.y+r1.h-3; buttonY++) {
        [Definitions drawInBitmap:_bitmap left:button_middle_left middle:button_middle_middle right:button_middle_right x:r1.x y:buttonY w:r1.w palette:palette];
    }
    [Definitions drawInBitmap:_bitmap left:bottom_left middle:bottom_middle right:bottom_right x:r1.x y:r1.y+r1.h-3 w:r1.w palette:palette];
    [_bitmap setColor:textColor];
    [_bitmap drawBitmapText:text x:r1.x+10+leftMargin y:r1.y+5];

    _cursorY += r1.h;
}


- (void)handleMouseDown:(id)event
{
    int x = [event intValueForKey:@"mouseX"];
    int y = [event intValueForKey:@"mouseY"];
    for (int i=0; i<[_buttons count]; i++) {
        if ([Definitions isX:x y:y insideRect:_rect[i]]) {
            _buttonDown = i+1;
            return;
        }
    }
    _buttonDown = 0;
}
- (void)handleMouseMoved:(id)event
{
    int x = [event intValueForKey:@"mouseX"];
    int y = [event intValueForKey:@"mouseY"];
    for (int i=0; i<[_buttons count]; i++) {
        if ([Definitions isX:x y:y insideRect:_rect[i]]) {
            _buttonHover = i+1;
            return;
        }
    }
    _buttonHover = 0;
}

- (void)handleMouseUp:(id)event
{
    if (_buttonDown == 0) {
        return;
    }
    if (_buttonDown == _buttonHover) {
        id message = [_buttons nth:_buttonDown-1];
        if ([message length]) {
            [self evaluateMessage:message];
        }
    }
    _buttonDown = 0;
}
- (void)handleScrollWheel:(id)event
{
    _scrollY -= [event intValueForKey:@"deltaY"];
}
@end

