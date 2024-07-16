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

@implementation Definitions(fjdklsjflksdjf)
+ (id)testTable
{
    id arr = [[[Definitions homeDir] contentsOfDirectoryWithFullPaths] asFileArray];
    id cells = [@"Table" asInstance];
    [cells setupArray:arr];
    return cells;
}
@end

@implementation NSArray(jfkdlsjflksdjf)
- (id)asTable
{
    id table = [@"Table" asInstance];
    [table setupArray:self];
    return table;
}
- (id)asTable:(id)keys
{
    id table = [@"Table" asInstance];
    [table setupArray:self keys:keys];
    return table;
}
@end
@implementation Definitions(fjkdslfjklsdjflk)
+ (id)Table:(id)cmd observer:(id)observer
{
    id table = [@"Table" asInstance];
    [table setValue:cmd forKey:@"generateCommand"];
    [table setValue:observer forKey:@"observer"];
    [table updateArrayFromCommand];
    return table;
}
+ (id)ProcessUtility
{
    id cmd = nsarr();
    [cmd addObject:@"anal-listProcesses.pl"];
    id observercmd = nsarr();
    [observercmd addObject:@"anal-printEveryNSeconds:.pl"];
    [observercmd addObject:@"5"];
    id observer = [observercmd runCommandAndReturnProcess];
    if (!observer) {
NSLog(@"Unable to run observer command %@", observercmd);
exit(1);
    }

    id table = [Definitions Table:cmd observer:observer];
    [table setValue:@"1" forKey:@"sortReverse"];
    [table setValue:@"pctcpu" forKey:@"sortKey"];
    return table;
}
@end



@interface Table : IvarObject
{
    id _generateCommand;
    id _observer;
    id _origArray;
    id _array;
    id _columns;
    int _mouseX;
    int _mouseY;
    int _offsetX;
    int _offsetY;
    BOOL _buttonDown;
    int _buttonDownX;
    int _buttonDownY;
    int _selectedIndex;
    int _selectedColumn;
    id _sortKey;
    BOOL _sortReverse;
    BOOL _sortAlpha;
    BOOL _rightButtonDown;
    int _rightButtonDownX;
    int _rightButtonDownY;
    int _rightButtonDownRootX;
    int _rightButtonDownRootY;
    id _menuDict;
    int _hoverIndex;
    id _defaultMessageForClick;
    id _defaultMessageForRightClick;
}
@end

@implementation Table
- (int)fileDescriptor
{
    if (_observer) {
        return [_observer fileDescriptor];
    }
    return -1;
}
- (void)handleFileDescriptor
{
    if (_observer) {
        [_observer handleFileDescriptor];
        id data = [_observer valueForKey:@"data"];
        BOOL didReadLine = NO;
        for(;;) {
            id line = [data readLine];
            if (!line) {
                break;
            }
            didReadLine = YES;
        }
        if (didReadLine) {
            [self updateArrayFromCommand];
        }
    }
}
- (int)maximumWidthForColumn:(id)key
{
    int maxWidth = [Definitions bitmapWidthForText:key];
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id val = [elt valueForKey:key];
        int width = [Definitions bitmapWidthForText:val];
        if (width > maxWidth) {
            maxWidth = width;
        }
    }
    return maxWidth;
}

- (void)updateArrayFromCommand
{
    id output = [[[_generateCommand runCommandAndReturnOutput] asString] split:@"\n"];
    if (output) {
        [self setupArray:output];
    }
}
- (void)updateArray
{
    if (!_sortKey) {
        [self setValue:_origArray forKey:@"array"];
        return;
    }

    id arr = nil;
    if (_sortReverse) {
        if (_sortAlpha) {
            arr = [_origArray asArrayReverseSortedWithKey:_sortKey];
        } else {
            arr = [_origArray reverseNumericSortForKey:_sortKey];
        }
    } else {
        if (_sortAlpha) {
            arr = [_origArray asArraySortedWithKey:_sortKey];
        } else {
            arr = [_origArray numericSortForKey:_sortKey];
        }
    }
    [self setValue:arr forKey:@"array"];
}

- (void)setupArray:(id)arr keys:(id)keys
{
    [self setValue:arr forKey:@"origArray"];
    [self updateArray];

    [self setValue:nsarr() forKey:@"columns"];
    int cursorX = 0;
    for (int i=0; i<[keys count]; i++) {
        id key = [keys nth:i];
        id dict = nsdict();
        int maxWidth = [self maximumWidthForColumn:key];
        maxWidth += 10;
        [dict setValue:nsfmt(@"%d", cursorX) forKey:@"x"];
        [dict setValue:nsfmt(@"%d", maxWidth) forKey:@"w"];
        cursorX += maxWidth;
        [dict setValue:key forKey:@"key"];
        [_columns addObject:dict];
    }
}
- (void)setupArray:(id)arr
{
    [self setValue:arr forKey:@"origArray"];
    [self updateArray];

    id allKeys = [arr allKeys];
    [self setValue:nsarr() forKey:@"columns"];
    int cursorX = 0;
    for (int i=0; i<[allKeys count]; i++) {
        id key = [allKeys nth:i];
        id dict = nsdict();
        int maxWidth = [self maximumWidthForColumn:key];
        maxWidth += 10;
        [dict setValue:nsfmt(@"%d", cursorX) forKey:@"x"];
        [dict setValue:nsfmt(@"%d", maxWidth) forKey:@"w"];
        cursorX += maxWidth;
        [dict setValue:key forKey:@"key"];
        [_columns addObject:dict];
    }
/*
    cursorX = 0;
    int columnWidth = 1910 / [_columns count];
    for (id column in _columns) {
        [column setValue:nsfmt(@"%d", columnWidth) forKey:@"w"];
int textHeight = [Definitions bitmapHeightForText:[Definitions fitBitmapString:[column valueForKey:@"key"] width:columnWidth]];
[column setValue:nsfmt(@"%d", textHeight) forKey:@"h"];
        [column setValue:nsfmt(@"%d", cursorX) forKey:@"x"];
        cursorX += columnWidth;
    }
*/
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    _selectedIndex = -1;
    _hoverIndex = -1;

    [bitmap setColor:@"white"];
    [bitmap fillRect:r];
    int y = -_offsetY+r.y+20;
    [bitmap setColor:@"black"];
    [bitmap drawHorizontalLineAtX:r.x x:r.x+r.w-1 y:y-1];
    for (int rowindex=0; rowindex<[_array count]; rowindex++) {
        id row = [_array nth:rowindex];
        [bitmap setColor:@"black"];
        [bitmap drawHorizontalLineAtX:r.x x:r.x+r.w-1 y:y+19];
        BOOL hover = NO;
        if ((_mouseY >= y) && (_mouseY < y+20)) {
            hover = YES;
            _hoverIndex = rowindex;
        }
        BOOL button = NO;
        if ((_buttonDownY >= y) && (_buttonDownY < y+20)) {
            button = YES;
        }
        int fg = 0;
        if (hover && _buttonDown && button) {
            [bitmap setColor:@"blue"];
            [bitmap fillRect:[Definitions rectWithX:r.x y:y w:r.w h:19]];
            fg = 255;
            _selectedIndex = rowindex;
        } else if (hover && !_buttonDown) {
            [bitmap setColor:@"black"];
            [bitmap fillRect:[Definitions rectWithX:r.x y:y w:r.w h:19]];
            fg = 255;
        }
        
        id highestValue = nil;
        for (int colindex=_offsetX; colindex<[_columns count]; colindex++) {
            id col = [_columns nth:colindex];
            id key = [col valueForKey:@"key"];
            id val = [row valueForKey:key];
            if (!highestValue || ([val doubleValue] > [highestValue doubleValue])) {
                highestValue = val;
            }
        }

highestValue = nil; // disable highlight of highest value

        for (int colindex=_offsetX; colindex<[_columns count]; colindex++) {
            id col = [_columns nth:colindex];
            int x = [col intValueForKey:@"x"];
            int w = [col intValueForKey:@"w"];
            id key = [col valueForKey:@"key"];
            id val = [row valueForKey:key];
            if ([highestValue isEqual:val]) {
                [bitmap setColorIntR:255 g:0 b:0 a:255];
            } else {
                [bitmap setColorIntR:fg g:fg b:fg a:255];
            }
            [bitmap drawBitmapText:val x:x+5 y:y+4];
        }
        y += 20;
    }
    y = r.y;
    [bitmap setColor:@"black"];
    [bitmap fillRect:[Definitions rectWithX:r.x y:y w:r.w h:20]];
    [bitmap drawVerticalLineAtX:0 y:r.y y:r.y+r.h];
    if ((_mouseY >= r.y) && (_mouseY < r.y+20)) {
        _selectedIndex = [_array count];
    }
    for (int colindex=_offsetX; colindex<[_columns count]; colindex++) {
        id col = [_columns nth:colindex];
        int x = [col intValueForKey:@"x"];
        int w = [col intValueForKey:@"w"];
        int h = [col intValueForKey:@"h"];
        id key = [col valueForKey:@"key"];
        [bitmap setColor:@"black"];
        [bitmap fillRect:[Definitions rectWithX:x y:y w:w h:h]];
        [bitmap drawVerticalLineAtX:x+w y:r.y y:r.y+r.h];
        if ([_sortKey isEqual:key]) {
            [bitmap setColorIntR:0 g:0 b:255 a:255];
        } else {
            [bitmap setColorIntR:255 g:255 b:255 a:255];
        }
        id str = [bitmap fitBitmapString:key width:w];
        [bitmap drawBitmapText:str x:x+5 y:y+3];
    }

    _selectedColumn = -1;
    for (int colindex=_offsetX; colindex<[_columns count]; colindex++) {
        id col = [_columns nth:colindex];
        int x = [col intValueForKey:@"x"];
        int w = [col intValueForKey:@"w"];
        if ((_mouseX >= x) && (_mouseX < x+w)) {
            _selectedColumn = colindex;
        }
    }
}
- (void)handleMouseMoved:(id)event
{
    if (_menuDict) {
        id object = [_menuDict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleMouseMoved:)]) {
            id windowManager = [event valueForKey:@"windowManager"];
            int mouseRootX = [event intValueForKey:@"mouseRootX"];
            int mouseRootY = [event intValueForKey:@"mouseRootY"];
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            int w = [_menuDict intValueForKey:@"w"];
            int h = [_menuDict intValueForKey:@"h"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y w:w h:h x11dict:_menuDict];
            [object handleMouseMoved:newEvent];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        }
        return;
    }

    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
}
- (void)handleScrollWheel:(id)event
{
    int deltaY = [event intValueForKey:@"deltaY"];
    _offsetY -= deltaY;
}
- (void)handleMouseDown:(id)event
{
    _buttonDown = YES;
    _buttonDownX = [event intValueForKey:@"mouseX"];
    _buttonDownY = [event intValueForKey:@"mouseY"];
}
- (void)handleRightMouseDown:(id)event
{
    _rightButtonDown = YES;
    _rightButtonDownX = [event intValueForKey:@"mouseX"];
    _rightButtonDownY = [event intValueForKey:@"mouseY"];
    _rightButtonDownRootX = [event intValueForKey:@"mouseRootX"];
    _rightButtonDownRootY = [event intValueForKey:@"mouseRootY"];
}
- (void)handleMouseUp:(id)event
{
    _buttonDown = NO;
    if (_selectedIndex == [_array count]) {
        id col = [_columns nth:_selectedColumn];
        id key = [col valueForKey:@"key"];
        if ([_sortKey isEqual:key]) {
            key = nil;
        }
        [self setValue:key forKey:@"sortKey"];
        [self updateArray];
        return;
    }
    if (_selectedIndex != -1) {
        id elt = [_array nth:_selectedIndex];
        id messageForClick = [elt valueForKey:@"messageForClick"];
        if (!messageForClick) {
            messageForClick = _defaultMessageForClick;
        }
        if (messageForClick) {
            id result = [self evaluateMessage:messageForClick];
        }
    }
}
- (void)handleRightMouseUp:(id)event
{
    if (_menuDict) {
        id windowManager = [event valueForKey:@"windowManager"];
        id object = [_menuDict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleMouseUp:)]) {
            int mouseRootX = [event intValueForKey:@"mouseRootX"];
            int mouseRootY = [event intValueForKey:@"mouseRootY"];
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            int w = [_menuDict intValueForKey:@"w"];
            int h = [_menuDict intValueForKey:@"h"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y w:w h:h x11dict:_menuDict];
            [object handleMouseUp:newEvent];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
/*
            int closingIteration = [object intValueForKey:@"closingIteration"];
            if (closingIteration) {
                _closingIteration = closingIteration;
                return;
            }
*/
        }
    }
    [self setValue:nil forKey:@"menuDict"];
    _rightButtonDown = NO;
}
- (void)handleKeyDown:(id)event
{
    id keyString = [event valueForKey:@"keyString"];
NSLog(@"handleKeyDown keyString %@", keyString);
    if ([keyString isEqual:@"left"]) {
        if (_offsetX > 0) {
            _offsetX--;
        }
    } else if ([keyString isEqual:@"right"]) {
        _offsetX++;
    } else if ([keyString isEqual:@"up"]) {
        _offsetY += 20;
    } else if ([keyString isEqual:@"down"]) {
        _offsetY += 20;
    } else if ([keyString isEqual:@"space"]) {
        _offsetY += [event intValueForKey:@"viewHeight"] - 20;
    } else if ([keyString isEqual:@"b"]) {
        _offsetY -= [event intValueForKey:@"viewHeight"] - 20;;
    }
}
- (void)endIteration:(id)event
{
    if (_rightButtonDown) {
        if (!_menuDict) {
            if (_hoverIndex != -1) {
                id dict = [_array nth:_hoverIndex];
                if (dict) {
                    [self openRootMenu:dict x:_rightButtonDownRootX y:_rightButtonDownRootY];
                }
            }
        }
    }
}
- (void)openRootMenu:(id)dict x:(int)mouseRootX y:(int)mouseRootY
{
    id messageForClick = [dict valueForKey:@"messageForRightClick"];
    if (!messageForClick) {
        messageForClick = _defaultMessageForRightClick;
    }
    if (!messageForClick) {
        return;
    }
    id obj = [self evaluateMessage:messageForClick];
    if (!obj) {
        return;
    }
    int w = 200;
    if ([obj respondsToSelector:@selector(preferredWidth)]) {
        w = [obj preferredWidth];
    }
    int h = 200;
    if ([obj respondsToSelector:@selector(preferredHeight)]) {
        h = [obj preferredHeight];
    }
    id windowManager = [@"windowManager" valueForKey];
    id menuDict = [windowManager openWindowForObject:obj x:mouseRootX+3 y:mouseRootY+3 w:w+3 h:h+3 overrideRedirect:YES];
    [menuDict setValue:dict forKey:@"previousObject"];
    [menuDict setValue:self forKey:@"userObject"];
    [self setValue:menuDict forKey:@"menuDict"];
}
- (id)selectedObject
{
    if (_selectedIndex < 0) {
        return nil;
    }
    id elt = [_array nth:_selectedIndex];
    return elt;
}
@end

