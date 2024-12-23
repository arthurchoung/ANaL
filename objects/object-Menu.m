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

@implementation NSString(fjekwlfmklwemfklsdmkflsd)
- (id)parseGeneratedMenuFromString
{
    id lines = [self split:@"\n"];
    id results = nsarr();
    id dict = nil;
    for (int i=0; i<[lines count]; i++) {
        id line = [lines nth:i];
        if ([line hasPrefix:@"="]) {
            char *p = [line UTF8String];
            p++;
            if (*p) {
                char *q = strchr(p, '=');
                if (q) {
                    int len = q - p;
                    if (len > 0) {
                        id key = nsfmt(@"%.*s", len, p);
                        id val = nsfmt(@"%s", q+1);
                        if (!dict) {
                            dict = nsdict();
                        }
                        [dict setValue:val forKey:key];
                    } else {
                        if (!dict) {
                            dict = nsdict();
                        }
                        [results addObject:dict];
                        dict = nil;
                    }
                }
            }
        }
    }
    return results;
}
@end


@implementation NSArray(jfkdlsjflksdjkf)
- (id)asMenu
{
    id menu = [@"Menu" asInstance];
    [menu setValue:self forKey:@"array"];
    return menu;
}
@end

@interface Menu : IvarObject
{
    int _mouseX;
    int _mouseY;
    id _array;
    id _selectedObject;
    id _contextualObject;
    int _scrollY;

    int _pixelScaling;
    id _scaledFont;

    int _unmapInsteadOfClose;
    id _title;

    unsigned long _contextualWindow;
}
@end

@implementation Menu

- (id)init
{
    self = [super init];
    if (self) {
        int scaling = [[Definitions valueForEnvironmentVariable:@"ANAL_SCALING"] intValue];
        if (scaling < 1) {
            scaling = 1;
        }
        _pixelScaling = scaling;

        id obj;
        obj = [Definitions scaleFont:scaling
                        :[Definitions arrayOfCStringsForTopazFont]
                        :[Definitions arrayOfWidthsForTopazFont]
                        :[Definitions arrayOfHeightsForTopazFont]
                        :[Definitions arrayOfXSpacingsForTopazFont]];
        [self setValue:obj forKey:@"scaledFont"];
    }
    return self;
}
- (void)useFixedWidthFont
{
}
- (int)preferredWidth
{
    id bitmap = [Definitions bitmapWithWidth:1 height:1];
    if (_scaledFont) {
        [bitmap useFont:[[_scaledFont nth:0] bytes]
                    :[[_scaledFont nth:1] bytes]
                    :[[_scaledFont nth:2] bytes]
                    :[[_scaledFont nth:3] bytes]];
    }

    int highestWidth = 0;
    int highestRightWidth = 0;
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id text = nil;
        id stringFormat = [elt valueForKey:@"stringFormat"];
        if (stringFormat) {
            if (_contextualObject) {
                text = [_contextualObject str:stringFormat];
            } else {
                text = [elt str:stringFormat];
            }
        }
        if (![text length]) {
            text = [elt valueForKey:@"displayName"];
            if (![text length]) {
                text = [elt valueForKey:@"messageForClick"];
            }
        }
        if ([text length]) {
            int w = [bitmap bitmapWidthForText:text];
            if (w > highestWidth) {
                highestWidth = w;
            }
        }
        id hotKey = [elt valueForKey:@"hotKey"];
        if (hotKey) {
            int w = [bitmap bitmapWidthForText:hotKey];
            if (w > highestRightWidth) {
                highestRightWidth = w;
            }
        }
    }
    if (highestWidth && highestRightWidth) {
        return highestWidth + 12*_pixelScaling + highestRightWidth + 26*_pixelScaling;
    }
    if (highestWidth) {
        return highestWidth + 12*_pixelScaling;
    }
    return 1;
}
- (int)preferredHeight
{
    int h = [_array count]*16*_pixelScaling;
    if (h) {
        return h+12*_pixelScaling;
    }
    return 1;
}

- (void)beginIteration:(id)x11dict rect:(Int4)r
{
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)outerRect
{
    if (_scaledFont) {
        [bitmap useFont:[[_scaledFont nth:0] bytes]
                    :[[_scaledFont nth:1] bytes]
                    :[[_scaledFont nth:2] bytes]
                    :[[_scaledFont nth:3] bytes]];
    }

    Int4 origRect = outerRect;
    outerRect.y -= _scrollY;
    Int4 r = outerRect;
    r.x += 2*_pixelScaling;
    r.y += 2*_pixelScaling;
    r.w -= 4*_pixelScaling;
    r.h -= 4*_pixelScaling;
    [bitmap setColor:@"black"];
    [bitmap fillRect:origRect];
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];

    [self setValue:nil forKey:@"selectedObject"];
    id arr = _array;
    int numberOfCells = [arr count];
    if (!numberOfCells) {
        return;
    }
    int cellHeight = 16*_pixelScaling;
    for (int i=0; i<numberOfCells; i++) {
        Int4 cellRect = [Definitions rectWithX:r.x y:r.y+4*_pixelScaling+i*cellHeight w:r.w h:cellHeight];
        id elt = [arr nth:i];
        id text = nil;
        id stringFormat = [elt valueForKey:@"stringFormat"];
        if ([stringFormat length]) {
            if (_contextualObject) {
                text = [_contextualObject str:stringFormat];
            } else {
                text = [elt str:stringFormat];
            }
        }
        if (![text length]) {
            text = [elt valueForKey:@"displayName"];
            if (![text length]) {
                text = [elt valueForKey:@"messageForClick"];
            }
        }
        id rightText = [elt valueForKey:@"hotKey"];
        Int4 r2 = cellRect;
        r2.x += 2*_pixelScaling;
        r2.w -= 4*_pixelScaling;
        id messageForClick = [elt valueForKey:@"messageForClick"];
        if ([messageForClick length] && [Definitions isX:_mouseX y:_mouseY insideRect:origRect] && [Definitions isX:_mouseX y:_mouseY insideRect:cellRect]) {
            if ([text length]) {
                [bitmap setColor:@"black"];
                [bitmap fillRect:r2];
                [bitmap setColor:@"white"];
                [bitmap drawBitmapText:text x:r2.x+4*_pixelScaling y:r2.y];
                if ([rightText length]) {
                    int w = [bitmap bitmapWidthForText:rightText];
                    [bitmap drawBitmapText:rightText x:cellRect.x+cellRect.w-w-4*_pixelScaling y:cellRect.y];
                }
            } else {
                [bitmap setColor:@"white"];
                [bitmap drawHorizontalDashedLineAtX:r2.x x:r2.x+r2.w y:r2.y+r2.h/2 dashLength:1];
            }
            [self setValue:elt forKey:@"selectedObject"];
        } else {
            if ([text length]) {
                if ([messageForClick length]) {
                    [bitmap setColor:@"black"];
                    [bitmap drawBitmapText:text x:r2.x+4*_pixelScaling y:r2.y];
                    if ([rightText length]) {
                        int w = [bitmap bitmapWidthForText:rightText];
                        [bitmap drawBitmapText:rightText x:cellRect.x+cellRect.w-w-4*_pixelScaling y:cellRect.y];
                    }
                } else {
                    [bitmap setColor:@"#aaaaaa"];
                    [bitmap fillRect:r2];
                    [bitmap setColor:@"black"];
                    [bitmap drawBitmapText:text x:r2.x+4*_pixelScaling y:r2.y];
                }
            } else {
                [bitmap setColor:@"black"];
                [bitmap drawHorizontalDashedLineAtX:r2.x x:r2.x+r2.w y:r2.y+r2.h/2 dashLength:1];
            }
        }
    }
}
- (void)handleKeyDown:(id)event
{
NSLog(@"AmigaMenu handleKeyDown");
    id keyString = [event valueForKey:@"keyString"];
NSLog(@"keyString %@", keyString);
    if ([keyString isEqual:@"up"]) {
        _scrollY -= 20;
    } else if ([keyString isEqual:@"down"]) {
        _scrollY += 20;
    }
}
- (void)handleScrollWheel:(id)event
{
NSLog(@"AmigaMenu handleScrollWheel");
    int dy = [event intValueForKey:@"scrollingDeltaY"];
NSLog(@"dy %d", dy);
    _scrollY += dy;
}
- (void)handleMouseMoved:(id)event
{
//NSLog(@"Menu handleMouseMoved");
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
}

- (void)handleMouseUp:(id)event context:(id)x11dict
{
NSLog(@"Menu handleMouseUp");
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    if (mouseRootY == -1) {
        [self setValue:nil forKey:@"selectedObject"];
    }

    if (_selectedObject) {
        id message = [_selectedObject valueForKey:@"messageForClick"];
        if (message) {
            id context = _contextualObject;
            if (!context) {
                context = _selectedObject;
            }
            [context  evaluateMessage:message];
            if (_contextualWindow) {
                id windowManager = [Definitions windowManager];
                id contextualDict = [windowManager dictForObjectWindow:_contextualWindow];
                [contextualDict setValue:@"1" forKey:@"needsRedraw"];
            }
        }
    }
    if (_unmapInsteadOfClose) {
        id windowManager = [Definitions windowManager];
        id window = [x11dict valueForKey:@"window"];
        if (window) {
            [windowManager XUnmapWindow:[window unsignedLongValue]];
        }
    } else {
        [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
    }
}
- (void)handleRightMouseUp:(id)event context:(id)x11dict
{
    [self handleMouseUp:event context:x11dict];
}
@end

