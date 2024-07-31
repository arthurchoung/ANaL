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

@implementation Definitions(fewiomfiodsvmkocxjvoksjdfoks)
+ (void)updateWindowPositionsForExpose:(id)windows monitor:(id)monitor
{
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorY = [monitor intValueForKey:@"y"];
    int monitorWidth = [monitor intValueForKey:@"width"];
    int monitorHeight = [monitor intValueForKey:@"height"];
    
    id cmd = nsarr();
    [cmd addObject:@"anal-packRectanglesIntoWidth:height:..."];
    [cmd addObject:nsfmt(@"%d", monitorWidth)];
    [cmd addObject:nsfmt(@"%d", monitorHeight)];
    for (int i=0; i<[windows count]; i++) {
        id window = [windows nth:i];
        int x = [window intValueForKey:@"x"];
        int y = [window intValueForKey:@"y"];
        if ([window intValueForKey:@"ANALNOFRAME"]) {
            [cmd addObject:nsfmt(@"id:%@", [window valueForKey:@"childWindow"])];
        } else {
            [cmd addObject:nsfmt(@"id:%@", [window valueForKey:@"window"])];
        }
        [cmd addObject:nsfmt(@"x:%d", x - monitorX)];
        [cmd addObject:nsfmt(@"y:%d", y - monitorY)];
        [cmd addObject:nsfmt(@"w:%d", [window intValueForKey:@"w"])];
        [cmd addObject:nsfmt(@"h:%d", [window intValueForKey:@"h"])];
    }
    id data = [cmd runCommandAndReturnOutput];
    id results = [[data asString] split:@"\n"];
    for (int i=0; i<[results count]; i++) {
        id elt = [results nth:i];
        id windowID = [elt valueForKey:@"id"];
        if (!windowID) {
            continue;
        }
        id dict = [windows objectWithValue:windowID forKey:@"window"];
        if (!dict) {
            dict = [windows objectWithValue:windowID forKey:@"childWindow"];
            if (!dict) {
                continue;
            }
        }
        [dict setValue:[dict valueForKey:@"x"] forKey:@"origX"];
        [dict setValue:[dict valueForKey:@"y"] forKey:@"origY"];
        [dict setValue:[dict valueForKey:@"w"] forKey:@"origW"];
        [dict setValue:[dict valueForKey:@"h"] forKey:@"origH"];

        int newX = [elt intValueForKey:@"x"];
        int newY = [elt intValueForKey:@"y"];
        int newW = [elt intValueForKey:@"w"];
        int newH = [elt intValueForKey:@"h"];
        id moveWindow = nsfmt(@"%d %d", monitorX+newX, monitorY+newY);
        id resizeWindow = nsfmt(@"%d %d", newW, newH);
        [dict setValue:moveWindow forKey:@"moveWindow"];
        [dict setValue:resizeWindow forKey:@"resizeWindow"];
    }
}
@end

@implementation Definitions(jfewjfsdjflksdjfkljsdklf)
+ (void)toggleExposeMode
{
    id windowManager = [Definitions windowManager];
    id rootObject = [windowManager valueForKey:@"rootWindowObject"];
    if (![[rootObject className] isEqual:@"ExposeRootWindow"]) {
        [Definitions enterExposeMode];
    } else {
        [Definitions exitExposeMode];
    }
}
+ (void)enterExposeMode
{
    id windowManager = [Definitions windowManager];
    id oldRootWindowObject = [windowManager valueForKey:@"rootWindowObject"];
    if ([[oldRootWindowObject className] isEqual:@"ExposeRootWindow"]) {
        return;
    }

    id rootObject = [@"ExposeRootWindow" asInstance];
    [rootObject setValue:oldRootWindowObject forKey:@"oldRootWindowObject"];
    [windowManager setFocusDict:nil];
    [rootObject unmapIrrelevantWindows];
    [windowManager setValue:rootObject forKey:@"rootWindowObject"];
    id obj = [@"ExposeWindow" asInstance];
    id dict = [windowManager openWindowForObject:obj x:0 y:0 w:1 h:1];
    [windowManager unmapObjectWindow:dict];
    [rootObject tileWindows];
}
+ (void)exitExposeMode
{
    id windowManager = [Definitions windowManager];
    id rootObject = [windowManager valueForKey:@"rootWindowObject"];
    if (![[rootObject className] isEqual:@"ExposeRootWindow"]) {
        return;
    }

    id oldRootWindowObject = [rootObject valueForKey:@"oldRootWindowObject"];
    [windowManager setValue:oldRootWindowObject forKey:@"rootWindowObject"];
    id dict = [windowManager dictForObjectWindowClassName:@"ExposeWindow"];
    [dict setValue:@"1" forKey:@"shouldCloseWindow"];
    [rootObject revertWindowPositions];
    [rootObject mapIrrelevantWindows];
}
@end

@interface ExposeRootWindow : IvarObject
{
    id _oldRootWindowObject;
}
@end
@implementation ExposeRootWindow
- (void)unmapIrrelevantWindows
{
    id windowManager = [Definitions windowManager];
    id reparentClassName = [windowManager valueForKey:@"reparentClassName"];
    id objectWindows = [windowManager valueForKey:@"objectWindows"];
    for (int i=0; i<[objectWindows count]; i++) {
        id dict = [objectWindows nth:i];
        if (![dict valueForKey:@"window"]) {
            continue;
        }
        id object = [dict valueForKey:@"object"];
        if ([[object className] isEqual:reparentClassName]) {
            continue;
        }
        if ([dict intValueForKey:@"isUnmapped"]) {
            continue;
        }
        [dict setValue:@"1" forKey:@"exposeIrrelevant"];
        [windowManager unmapObjectWindow:dict];
    }
}
- (void)mapIrrelevantWindows
{
    id windowManager = [Definitions windowManager];
    id objectWindows = [windowManager valueForKey:@"objectWindows"];
    for (int i=0; i<[objectWindows count]; i++) {
        id dict = [objectWindows nth:i];
        if (![dict valueForKey:@"window"]) {
            continue;
        }
        id object = [dict valueForKey:@"object"];
        if (![dict valueForKey:@"exposeIrrelevant"]) {
            continue;
        }
        [dict setValue:nil forKey:@"exposeIrrelevant"];
        [windowManager mapObjectWindow:dict];
    }
}
- (void)tileWindows
{
    id windowManager = [Definitions windowManager];
    id reparentClassName = [windowManager valueForKey:@"reparentClassName"];
    id monitors = [Definitions monitorConfig];
    id objectWindows = [windowManager valueForKey:@"objectWindows"];
    id arr = nsarr();
    for (int i=0; i<[monitors count]; i++) {
        [arr addObject:nsarr()];
    }
    for (int i=0; i<[objectWindows count]; i++) {
        id dict = [objectWindows nth:i];
        if (![dict valueForKey:@"window"]) {
            if (![dict intValueForKey:@"ANALNOFRAME"]) {
                continue;
            }
        }
        if (![dict intValueForKey:@"ANALNOFRAME"]) {
            id object = [dict valueForKey:@"object"];
            if (![[object className] isEqual:reparentClassName]) {
                continue;
            }
        }
        int x = [dict intValueForKey:@"x"];
        int y = [dict intValueForKey:@"y"];
        int w = [dict intValueForKey:@"w"];
        int h = [dict intValueForKey:@"h"];
        int centerX = x + w/2;
        int centerY = y + h/2;
        int monitorIndex = [Definitions monitorIndexForX:centerX y:centerY];
        [[arr nth:monitorIndex] addObject:dict];
    }
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
[Definitions updateWindowPositionsForExpose:elt monitor:[monitors nth:i]];
//        [self tileWindows:elt monitor:[monitors nth:i]];
    }
}
- (void)revertWindowPositions
{
    id windowManager = [Definitions windowManager];
    id reparentClassName = [windowManager valueForKey:@"reparentClassName"];
    id objectWindows = [windowManager valueForKey:@"objectWindows"];
    for (int i=0; i<[objectWindows count]; i++) {
        id dict = [objectWindows nth:i];
        if (![dict valueForKey:@"window"]) {
            if (![dict intValueForKey:@"ANALNOFRAME"]) {
                continue;
            }
        }
        if ([!dict intValueForKey:@"ANALNOFRAME"]) {
            id object = [dict valueForKey:@"object"];
            if (![[object className] isEqual:reparentClassName]) {
                continue;
            }
        }
        int x = [dict intValueForKey:@"origX"];
        int y = [dict intValueForKey:@"origY"];
        int w = [dict intValueForKey:@"origW"];
        int h = [dict intValueForKey:@"origH"];
        if ((w > 0) && (h > 0)) {
            [dict setValue:nsfmt(@"%d %d", x, y) forKey:@"moveWindow"];
            [dict setValue:nsfmt(@"%d %d", w, h) forKey:@"resizeWindow"];
        }
    }
}
- (void)handleDidSetInputFocusEvent:(id)event
{
    [Definitions exitExposeMode];
}
- (void)handleEnterWindowEvent:(id)event context:(id)x11dict
{
    id windowManager = [Definitions windowManager];
    id reparentClassName = [windowManager valueForKey:@"reparentClassName"];
    if (!x11dict) {
        return;
    }
    if (![x11dict intValueForKey:@"ANALNOFRAME"]) {
        id object = [x11dict valueForKey:@"object"];
        if (![[object className] isEqual:reparentClassName]) {
            return;
        }
    }
    int x = [x11dict intValueForKey:@"x"];
    int y = [x11dict intValueForKey:@"y"];
    int w = [x11dict intValueForKey:@"w"];
    int h = [x11dict intValueForKey:@"h"];
    id dict = [windowManager dictForObjectWindowClassName:@"ExposeWindow"];
    [dict setValue:x11dict forKey:@"underneathObjectWindow"];
    [windowManager moveResizeObjectWindow:dict x:x y:y w:w h:h];
    [windowManager mapObjectWindow:dict];
}
- (void)handleMouseDown:(id)event
{
    [Definitions exitExposeMode];
}
- (void)handleMouseMoved:(id)event
{
    id windowManager = [Definitions windowManager];
    id dict = [windowManager dictForObjectWindowClassName:@"ExposeWindow"];
    [dict setValue:nil forKey:@"underneathObjectWindow"];
    [windowManager unmapObjectWindow:dict];
}
@end


@interface ExposeWindow : IvarObject
@end
@implementation ExposeWindow
- (void)drawInBitmap:(id)bitmap rect:(Int4)r context:(id)context
{
    [bitmap setColor:@"blue"];
    Int4 bottom = r;
    bottom.h = 5;
    [bitmap fillRect:bottom];
    Int4 top = r;
    top.h = 5;
    top.y = r.y+r.h-5;
    [bitmap fillRect:top];
    Int4 left = r;
    left.w = 5;
    [bitmap fillRect:left];
    Int4 right = r;
    right.w = 5;
    right.x = r.x+r.w-5;
    [bitmap fillRect:right];

    id windowManager = [Definitions windowManager];
    unsigned long win = [[context valueForKey:@"window"] unsignedLongValue];
    if (win) {
        [windowManager addMaskToWindow:win bitmap:bitmap];
    }
}
@end


