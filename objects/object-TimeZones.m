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

static int qsort_TZ2(void *aptr, void *bptr, void *arg)
{
    id a = *((id *)aptr);
    id b = *((id *)bptr);

    id aTZ2 = [a valueForKey:@"TZ2"];
    id bTZ2 = [b valueForKey:@"TZ2"];
    return [aTZ2 compare:bTZ2];
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

@implementation NSString(jfksldjflksdjkfljskf)
- (id)currentDateTimeForTimeZoneWithFormat:(id)format
{
    id results = nsarr(); 

    char *oldTZ = getenv("TZ");
    if (oldTZ) {
        oldTZ = strdup(oldTZ);
        setenv("TZ", [self UTF8String], 1);
    } else {
        setenv("TZ", [self UTF8String], 0);
    }
    
    time_t timestamp = time(NULL);
    struct tm *tmptr;
    tmptr = localtime(&timestamp);
    if (tmptr) {
        char buf[256];
        if (strftime(buf, 255, [format UTF8String], tmptr)) {
            [results addObject:nscstr(buf)];
        }
    }

    if (oldTZ) {
        setenv("TZ", oldTZ, 1);
        free(oldTZ);
    } else {
        unsetenv("TZ");
    }
    return [results join:@"\n"];
}
@end


@implementation Definitions(fjkdlsjfklsdjfklsdfjdksjfkdsfjdskfjksdljfjjfdksjfksd)
+ (id)WorldClock
{
    return [Definitions WorldClock:nil];
}
+ (id)WorldClock:(id)region
{
    id obj = [@"WorldClock" asInstance];
    [obj setValue:region forKey:@"region"];
    [obj updateArrayAndTimestamp];
    id nav = [Definitions navigationStack];
    [nav pushObject:obj];
    return nav;
}
@end


@interface WorldClock : IvarObject
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

    id _region;
}
@end
@implementation WorldClock
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
- (id)loadTimeZones
{
    id str = [@"/usr/share/zoneinfo/zone1970.tab" stringFromFile];
    id lines = [str split:@"\n"];
    id results = nsarr();
    for (int i=0; i<[lines count]; i++) {
        id line = [lines nth:i];
        if ([line hasPrefix:@"#"]) {
            continue;
        }
        id fields = [line split:@"\t"];
        id tz = [fields nth:2];
        id tokens = [tz split:@"/"];
        id tz1 = tz;
        id tz2 = nil;
        if ([tokens count] > 1) {
            tz1 = [tokens nth:0];
            tz2 = [[tokens subarrayFromIndex:1] join:@"/"];
        }
        id dict = nsdict();
        [dict setValue:[fields nth:0] forKey:@"codes"];
        [dict setValue:[fields nth:1] forKey:@"coordinates"];
        [dict setValue:tz forKey:@"TZ"];
        [dict setValue:[fields nth:3] forKey:@"fields"];
        [dict setValue:tz1 forKey:@"TZ1"];
        [dict setValue:tz2 forKey:@"TZ2"];
        [results addObject:dict];
    }

    return results;
}
- (id)generateArray
{
    id timeZones = [self loadTimeZones];
    if (_region) {
        id results = nsarr();
        for (int i=0; i<[timeZones count]; i++) {
            id timeZone = [timeZones nth:i];
            id tz1 = [timeZone valueForKey:@"TZ1"];
            if ([tz1 isEqual:_region]) {
                [results addObject:timeZone];
            }
        }
        results = [results asArraySortedWithFunction:qsort_TZ2 argument:0];
        return results;
    } else {
        id results = nsdict();
        for (int i=0; i<[timeZones count]; i++) {
            id timeZone = [timeZones nth:i];
            id tz1 = [timeZone valueForKey:@"TZ1"];
            [results setValue:tz1 forKey:tz1];
        }
        id keys = [results allKeys];
        keys = [keys asSortedArray];
        return keys;
    }
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
    id obj = [Definitions WorldClock:elt];
    id nav = [Definitions navigationStack];
    [nav pushObject:obj];
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{


    _cursorY = -_scrollY + r.y + 5;
    _r = r;

    [self setValue:bitmap forKey:@"bitmap"];
    [self panelStripedBackground];
    if (_region) {
        [self panelText:@""];
        [self panelText:nsfmt(@"World Clock: %@", _region)];
        [self panelText:@""];
    } else {
        [self panelText:@""];
        [self panelText:@"World Clock"];
        [self panelText:@""];
        [self panelText:@"Choose a region:"];
        [self panelText:@""];
    }
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
        id tz2 = [elt valueForKey:@"TZ2"];
        id text = nil;
        if (_region) {
            text = tz2;
        } else {
            text = elt;
        }
        if (i == 0) {
            [self panelTopButton:text index:i];
        } else if (i == count-1) {
            [self panelBottomButton:text index:i];
        } else {
            [self panelMiddleButton:text index:i];
        }
        if ((_buttonDown-1 == index) && (_buttonDown == _buttonHover)) {
            [bitmap setColor:@"white"];
        } else if (!_buttonDown && (_buttonHover-1 == index)) {
            [bitmap setColor:@"white"];
        } else {
            [bitmap setColor:@"black"];
        }
        if (_region) {
            Int4 rightRect = _rect[i];
            rightRect.y -= 1;
            id tz = [elt valueForKey:@"TZ"];
            text = [tz currentDateTimeForTimeZoneWithFormat:@"%I:%M:%S %p"];
            [bitmap drawBitmapText:text rightAlignedInRect:rightRect];
        } else {
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
@end


