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

static int qsort_fileType(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);

    id aFileType = [a valueForKey:@"fileType"];
    id bFileType = [b valueForKey:@"fileType"];
    BOOL aIsDirectory = [aFileType isEqual:@"directory"];
    BOOL bIsDirectory = [bFileType isEqual:@"directory"];
    if (aIsDirectory && !bIsDirectory) {
        return -1;
    }
    if (!aIsDirectory && bIsDirectory) {
        return 1;
    }
    id aDisplayName = [a valueForKey:@"displayName"];
    id bDisplayName = [b valueForKey:@"displayName"];
    return [aDisplayName compare:bDisplayName];
}

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

@implementation Definitions(fjkdlsjfklsdjfklsdfjdksjfkdsfjdskfjksdljfj)
+ (id)Dir
{
    id obj = [@"Dir" asInstance];
    [obj setValue:@"configDir:'Config/dirMenu.csv'|parseCSVFile|asMenu" forKey:@"navigationRightMouseDownMessage"];
    [obj setValue:[@"." asRealPath] forKey:@"currentDirectory"];
    [obj updateArrayAndTimestamp];
    id nav = [Definitions navigationStack];
    [nav pushObject:obj];
    return nav;
}
@end


@interface Dir : IvarObject
{
    id _currentDirectory;
    time_t _timestamp;
    int _seconds;
    id _array;
    Int4 _rect[MAX_RECT];
    int _buttonDown;
    int _buttonHover;
    int _buttonDownX;
    int _buttonDownY;
    int _buttonDownOffsetX;
    int _buttonDownOffsetY;
    int _scrollY;

    id _bitmap;
    Int4 _r;
    int _cursorY;

    id _navigationRightMouseDownMessage;
}
@end
@implementation Dir
- (id)hoverObject
{
    if (_buttonHover) {
        return [_array nth:_buttonHover-1];
    }
    return nil;
}
- (void)handleBackgroundUpdate:(id)event
{
    time_t timestamp = [_currentDirectory fileModificationTimestamp];
    if (timestamp == _timestamp) {
        _seconds++;
        return;
    }
    [self updateArray];
    _timestamp = timestamp;
    _seconds = 0;
}
- (id)generateArray
{
    id arr = [_currentDirectory contentsOfDirectory];
    arr = [arr asFileArray];
    arr = [arr asArraySortedWithFunction:qsort_fileType argument:0];
    return arr;
}
- (void)updateArray
{
    id arr = [self generateArray];
    [self setValue:arr forKey:@"array"];
}
- (void)updateArrayAndTimestamp
{
    time_t timestamp = [_currentDirectory fileModificationTimestamp];
    id arr = [self generateArray];
    [self setValue:arr forKey:@"array"];
    _timestamp = timestamp;
}
- (void)handleClick:(int)index
{
    id elt = [_array nth:index];
    if (!elt) {
        return;
    }
    id filePath = [elt valueForKey:@"filePath"];
    id fileType = [elt valueForKey:@"fileType"];
    if ([fileType isEqual:@"directory"]) {
        [filePath changeDirectory];
        id obj = [Definitions Dir];
        id nav = [Definitions navigationStack];
        [nav pushObject:obj];
        return;
    }

    id cmd = nsarr();
    [cmd addObject:@"anal-open:.pl"];
    [cmd addObject:filePath];
    [cmd runCommandInBackground];
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{


    _cursorY = -_scrollY + r.y + 5;
    _r = r;

    [self setValue:bitmap forKey:@"bitmap"];
    [self panelStripedBackground];
    int count = [_array count];
    for (int i=0; i<count; i++) {
        if (_cursorY >= r.y + r.h) {
            break;
        }
        if (i >= MAX_RECT) {
            [self panelText:@"MAX_RECT reached"];
            break;
        }
        id elt = [_array nth:i];
        id displayName = [elt valueForKey:@"displayName"];
        if (i == 0) {
            [self panelTopButton:displayName index:i];
        } else if (i == count-1) {
            [self panelBottomButton:displayName index:i];
        } else {
            [self panelMiddleButton:displayName index:i];
        }
        if ((_buttonDown-1 == index) && (_buttonDown == _buttonHover)) {
            [bitmap setColor:@"white"];
        } else if (!_buttonDown && (_buttonHover-1 == index)) {
            [bitmap setColor:@"white"];
        } else {
            [bitmap setColor:@"black"];
        }
        id fileType = [elt valueForKey:@"fileType"];
        if ([fileType isEqual:@"directory"]) {
            Int4 chevronRect = _rect[i];
            chevronRect.y -= 1;
            [bitmap drawBitmapText:@">" rightAlignedInRect:chevronRect];
        }
    }
    [self setValue:nil forKey:@"bitmap"];
}
- (void)panelStripedBackground
{
    drawStripedBackgroundInBitmap_rect_(_bitmap, _r);
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
- (void)panelTopButton:(id)origText index:(int)index
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];

    [self panelButton:text index:index origText:origText leftMargin:0 width:_r.w-20 :button_top_left :button_top_middle :button_top_right :button_bottom_left_squared :button_bottom_middle :button_bottom_right_squared];
}
- (void)panelMiddleButton:(id)origText index:(int)index
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];
    _cursorY -= 1;
    [self panelButton:text index:index origText:origText leftMargin:0 width:_r.w-20 :button_top_left_squared :button_top_middle :button_top_right_squared :button_bottom_left_squared :button_bottom_middle :button_bottom_right_squared];
}
- (void)panelBottomButton:(id)origText index:(int)index
{
    id text = [_bitmap fitBitmapString:origText width:_r.w-40];
    _cursorY -= 1;
    [self panelButton:text index:index origText:origText leftMargin:0 width:_r.w-20 :button_top_left_squared :button_top_middle :button_top_right_squared :button_bottom_left :button_bottom_middle :button_bottom_right];
}
- (void)panelButton:(id)text index:(int)index origText:(id)origText leftMargin:(int)leftMargin width:(int)width :(unsigned char *)top_left :(unsigned char *)top_middle :(unsigned char *)top_right :(unsigned char *)bottom_left :(unsigned char *)bottom_middle :(unsigned char *)bottom_right
{
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
    _rect[index] = r1;
    
    char *palette = "b #000000\n. #ffffff\n";
    id textColor = @"#000000";

    if ((_buttonDown-1 == index) && (_buttonDown == _buttonHover)) {
        palette = "b #000000\n. #0000ff\n";
        textColor = @"#ffffff";
    } else if (!_buttonDown && (_buttonHover-1 == index)) {
        palette = "b #000000\n. #000000\n";
        textColor = @"#ffffff";
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
    for (int i=0; i<[_array count]; i++) {
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
    for (int i=0; i<[_array count]; i++) {
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
        [self handleClick:_buttonDown-1];
    }
    _buttonDown = 0;
}
- (void)handleScrollWheel:(id)event
{
    _scrollY -= [event intValueForKey:@"deltaY"];
}
- (void)handleRightMouseDown:(id)event
{
    if (_buttonHover) {
        id windowManager = [event valueForKey:@"windowManager"];
        int mouseRootX = [event intValueForKey:@"mouseRootX"];
        int mouseRootY = [event intValueForKey:@"mouseRootY"];

        id obj = [[[Definitions configDir:@"Config/fileMenu.csv"] parseCSVFile] asMenu];
        if (obj) {
            [obj setValue:self forKey:@"contextualObject"];
            [windowManager openButtonDownMenuForObject:obj x:mouseRootX y:mouseRootY w:0 h:0];
        }
    }
}
@end


