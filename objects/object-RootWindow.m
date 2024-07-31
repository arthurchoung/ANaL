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
    id windowManager = [Definitions windowManager];
    id menuBar = [windowManager valueForKey:@"menuBar"];
    [menuBar setValue:@"1" forKey:@"needsRedraw"];
}
- (void)handleMouseDown:(id)event
{
    id path = [Definitions configDir:@"Menu/rootWindowMenu.csv"];
    [self showRootWindowMenu:event path:path];
}
- (void)handleRightMouseDown:(id)event
{
    id path = [Definitions configDir:@"Menu/rightButtonRootWindowMenu.csv"];
    [self showRootWindowMenu:event path:path];
}
- (void)showRootWindowMenu:(id)event path:(id)path
{
    id windowManager = [Definitions windowManager];
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    id buttonDownWhich = [event valueForKey:@"buttonDownWhich"];

    id obj = [[path parseCSVFile] asMenu];
    int w = [obj preferredWidth];
    int h = [obj preferredHeight];

id monitor = [Definitions monitorForX:mouseRootX y:0];
int monitorX = [monitor intValueForKey:@"x"];
int monitorY = [monitor intValueForKey:@"y"];
int monitorWidth = [monitor intValueForKey:@"width"];
int monitorHeight = [monitor intValueForKey:@"height"];
int x = mouseRootX;
if (x+w > monitorX+monitorWidth) {
    x = x-w;
    if (x < monitorX) {
        if (mouseRootX > monitorX + (monitorWidth / 2)) {
            w = mouseRootX - monitorX;
            x = monitorX;
        } else {
            w = monitorWidth - (mouseRootX - monitorX);
            x = mouseRootX;
        }
    }
}
int y = mouseRootY;
if (y+h > monitorY+monitorHeight) {
    if (h > monitorHeight) {
        y = monitorY;
        h = monitorHeight;
    } else {
        y = monitorY+monitorHeight-h;
    }
}
    id dict = [windowManager openWindowForObject:obj x:x y:y w:w h:h];
    [windowManager setValue:dict forKey:@"buttonDownDict"];
    [windowManager setValue:buttonDownWhich forKey:@"buttonDownWhich"];
}
@end

