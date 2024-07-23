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


@interface RootWindow : IvarObject
@end
@implementation RootWindow
- (BOOL)shouldPassthroughClickToFocus
{
    return YES;
}
- (void)handleMouseMoved:(id)event
{
    id windowManager = [event valueForKey:@"windowManager"];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    [menuBar setValue:@"1" forKey:@"needsRedraw"];
}
- (void)handleMouseDown:(id)event
{
}
- (void)handleRightMouseDown:(id)event
{
    id windowManager = [event valueForKey:@"windowManager"];
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    id buttonDownWhich = [event valueForKey:@"buttonDownWhich"];

    id obj = [[[Definitions configDir:@"Menu/rootWindowMenu.csv"] parseCSVFile] asMenu];
    int w = [obj preferredWidth];
    int h = [obj preferredHeight];

id monitor = [Definitions monitorForX:mouseRootX y:0];
int monitorX = [monitor intValueForKey:@"x"];
int monitorY = [monitor intValueForKey:@"y"];
int monitorWidth = [monitor intValueForKey:@"width"];
int monitorHeight = [monitor intValueForKey:@"height"];
int x = mouseRootX;
if (x+w+3 > monitorX+monitorWidth) {
    x = x-w-2;
    if (x < monitorX) {
        if (mouseRootX > monitorX + (monitorWidth / 2)) {
            w = mouseRootX - monitorX - 3;
            x = monitorX;
        } else {
            w = monitorWidth - (mouseRootX - monitorX) - 3;
            x = mouseRootX;
        }
    }
}
int y = mouseRootY;
if (y+h+3 > monitorY+monitorHeight) {
    if (h > monitorHeight-3) {
        y = monitorY;
        h = monitorHeight-3;
    } else {
        y = monitorY+monitorHeight-h-3;
    }
}
    id dict = [windowManager openWindowForObject:obj x:x y:y w:w+3 h:h+3];
    [windowManager setValue:dict forKey:@"buttonDownDict"];
    [windowManager setValue:buttonDownWhich forKey:@"buttonDownWhich"];
}
@end

