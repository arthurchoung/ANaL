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

static unsigned char *buttonPalette =
"b #000000\n"
". #AAAAAA\n"
"X #ffffff\n"
"o #6688bb\n"
;

static unsigned char *buttonDisabledPixels =
"    \n"
"    \n"
"   b\n"
"   b\n"
" b  \n"
" b  \n"
"   b\n"
"   b\n"
" b  \n"
" b  \n"
"   b\n"
"   b\n"
" b  \n"
" b  \n"
"   b\n"
"   b\n"
" b  \n"
" b  \n"
"   b\n"
"   b\n"
"    \n"
"    \n"
;

static unsigned char *buttonLeftPixels =
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"Xb\n"
"Xb\n"
;
static unsigned char *buttonMiddlePixels =
"X\n"
"X\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
"b\n"
"b\n"
;
static unsigned char *buttonRightPixels =
"Xb\n"
"Xb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
;
static unsigned char *buttonDownLeftPixels =
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bb\n"
"bX\n"
"bX\n"
;
static unsigned char *buttonDownMiddlePixels =
"b\n"
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
"X\n"
"X\n"
;
static unsigned char *buttonDownRightPixels =
"bX\n"
"bX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
"XX\n"
;

static unsigned char *separatorPixels =
"X\n"
"X\n"
"b\n"
"b\n"
;

@implementation Definitions(fmeklwfmklsdmlfksdfm)
+ (id)testAmigaGuide
{
    id path = [Definitions analDir:@"Help/test.guide"];
    return [Definitions AmigaGuide:path];
}
+ (id)AmigaGuide:(id)path
{
    id obj = [@"AmigaGuide" asInstance];
    [obj loadFile:path];
    [obj loadNode:@"main"];
    return obj;
}
+ (id)AmigaGuide
{
    id path = [Definitions analDir:@"Help/anal.guide"];
    return [Definitions AmigaGuide:path];
}
@end

#define MAX_BUTTONS 500
#define BUFSIZE 256

@implementation NSString(mfkelwmfklsdfmklsdmf)
- (id)parseQuotedTokens
{
    char *q = [self UTF8String];
    char *r = q;
    BOOL isQuoted = NO;
    id tokens = nsarr();
    for(;;) {
        if (!*r) {
            if (r > q) {
                id str = nsfmt(@"%.*s", r-q, q);
                [tokens addObject:str];
            }
            break;
        } else if (*r == ' ') {
            if (!isQuoted) {
                if (r > q) {
                    id str = nsfmt(@"%.*s", r-q, q);
                    [tokens addObject:str];
                    q = r+1;
                    r = q;
                    continue;
                } else {
                    q++;
                    r = q;
                    continue;
                }
            } else {
                r++;
                continue;
            }
        } else if (*r == '"') {
            if (isQuoted) {
                id str = nsfmt(@"%.*s", r-q, q);
                [tokens addObject:str];
                q = r+1;
                r = q;
                isQuoted = NO;
                continue;
            } else {
                q = r+1;
                r = q;
                isQuoted = YES;
                continue;
            }
        } else {
            r++;
            continue;
        }
    }
    return tokens;
}

@interface AmigaGuide : IvarObject
{
    int _scrollY;
    int _buttonDown;
    int _buttonHover;
    int _mouseX;
    int _mouseY;
    int _cursorX;
    int _cursorY;
    int _cursorH;
    int _leftMargin;

    id _lines;
    Int4 _buttonRect[MAX_BUTTONS];
    char _buttonType[MAX_BUTTONS][BUFSIZE];
    char _buttonLink[MAX_BUTTONS][BUFSIZE];
    int _numButtons;

    id _prevNode;
    id _nextNode;
    id _curNode;
    id _indexNode;
    id _tocNode;
    id _nodeTitle;
    id _nodeText;

    id _bitmap;
    Int4 _r;
    int _textHeight;
    id _history;
}
@end
@implementation AmigaGuide
- (id)init
{
    self = [super init];
    if (self) {
        _buttonDown = -1;
        _buttonHover = -1;
        _leftMargin = 8;
    }
    return self;
}
- (void)addToHistory:(id)node
{
    if (!node) {
        return;
    }

    if (!_history) {
        [self setValue:nsarr() forKey:@"history"];
    }

    [_history addObject:node];
}
- (void)loadNode:(id)node
{
    _scrollY = 0;
    [self setValue:node forKey:@"curNode"];
    node = [node lowercaseString];
    [self setValue:nil forKey:@"indexNode"];
    [self setValue:nil forKey:@"tocNode"];
    [self setValue:nil forKey:@"prevNode"];
    [self setValue:nil forKey:@"nextNode"];
    [self setValue:nil forKey:@"nodeTitle"];
    id lastNode = nil;
    BOOL found = NO;
    BOOL end = NO;
    id results = nsarr();
    id lines = _lines;
    for (int i=0; i<[lines count]; i++) {
        id line = [lines nth:i];
        if ([line hasPrefix:@"@"]) {
            id tokens = [line parseQuotedTokens];
            int numTokens = [tokens count];
            id command = [[tokens nth:0] lowercaseString];
            if ([command isEqual:@"@database"]) {
            } else if ([command isEqual:@"@node"]) {
                if (numTokens >= 2) {
                    id name = [tokens nth:1];
                    id title = [tokens nth:2];
                    if (end) {
                        [self setValue:name forKey:@"nextNode"];
                        break;
                    }
                    if ([[name lowercaseString] isEqual:node]) {
                        [self setValue:lastNode forKey:@"prevNode"];
                        found = YES;
                    }
                    lastNode = name;
                }
            } else if ([command isEqual:@"@index"]) {
                if (numTokens >= 2) {
                    id name = [tokens nth:1];
                    [self setValue:name forKey:@"indexNode"];
                }
            } else if ([command isEqual:@"@rem"]) {
            } else if ([command isEqual:@"@remark"]) {
            } else if ([command isEqual:@"@endnode"]) {
                if (found) {
                    if (_nextNode) {
                        break;
                    }
                    end = YES;
                }
            } else if ([command isEqual:@"@title"]) {
                if (numTokens >= 2) {
                    id title = [tokens nth:1];
                    [self setValue:title forKey:@"nodeTitle"];
                }
            } else if ([command isEqual:@"@toc"]) {
                if (numTokens >= 2) {
                    id name = [tokens nth:1];
                    [self setValue:name forKey:@"tocNode"];
                }
            } else if ([command isEqual:@"@prev"]) {
                if (found) {
                    if (numTokens >= 2) {
                        id prev = [tokens nth:1];
                        [self setValue:prev forKey:@"prevNode"];
                    }
                }
            } else if ([command isEqual:@"@next"]) {
                if (found) {
                    if (numTokens >= 2) {
                        id next = [tokens nth:1];
                        [self setValue:next forKey:@"nextNode"];
                    }
                }
            } else {
                if (found) {
                    [results addObject:line];
                }
            }
        } else {
            if (found) {
                [results addObject:line];
            }
        }
    }
    id text = [results join:@"\n"];
    [self setValue:text forKey:@"nodeText"];
}
- (void)loadFile:(id)path
{
    id str = [path stringFromFile];
    id lines = [str componentsSeparatedByString:@"\n"];
    [self setValue:lines forKey:@"lines"];
}
- (int)drawButton:(id)text type:(id)type link:(id)link minWidth:(int)minWidth
{
    int maxWidth = _r.w;

    int textWidth = [_bitmap bitmapWidthForText:text];
    int w = minWidth;
    if (textWidth+12 > minWidth) {
        w = textWidth+12;
    }
    int h = 22;
    int textOffsetX = (w-textWidth)/2;

    if (_cursorX + w > maxWidth) {
        _cursorY += _cursorH;
        _cursorH = h;
        _cursorX = 2;
    } else {
        if (_cursorH < h) {
            _cursorH = h;
        }
    }

    if (!type) {
        unsigned char *left = buttonLeftPixels;
        unsigned char *middle = buttonMiddlePixels;
        unsigned char *right = buttonRightPixels;
        unsigned char *disabled = buttonDisabledPixels;
        unsigned char *palette = buttonPalette;

        [Definitions drawInBitmap:_bitmap left:left palette:palette middle:middle palette:palette right:right palette:palette x:_cursorX y:_cursorY w:w];
        [Definitions drawInBitmap:_bitmap left:left palette:palette middle:disabled palette:palette right:right palette:palette x:_cursorX y:_cursorY w:w];
        [_bitmap setColor:@"black"];
        [_bitmap drawBitmapText:text x:_cursorX+textOffsetX y:_cursorY+4];

        _cursorX += w;
        if (_cursorH < h) {
            _cursorH = h;
        }

        return w;
    }

    if ((_buttonDown == _numButtons) && (_buttonHover == _numButtons)) {
        unsigned char *left = buttonDownLeftPixels;
        unsigned char *middle = buttonDownMiddlePixels;
        unsigned char *right = buttonDownRightPixels;
        unsigned char *palette = buttonPalette;

        [Definitions drawInBitmap:_bitmap left:left palette:palette middle:middle palette:palette right:right palette:palette x:_cursorX y:_cursorY w:w];
    } else {
        unsigned char *left = buttonLeftPixels;
        unsigned char *middle = buttonMiddlePixels;
        unsigned char *right = buttonRightPixels;
        unsigned char *palette = buttonPalette;

        [Definitions drawInBitmap:_bitmap left:left palette:palette middle:middle palette:palette right:right palette:palette x:_cursorX y:_cursorY w:w];
    }
    [_bitmap setColor:@"black"];
    [_bitmap drawBitmapText:text x:_cursorX+textOffsetX y:_cursorY+4];

    _buttonRect[_numButtons].x = _cursorX;
    _buttonRect[_numButtons].y = _cursorY;
    _buttonRect[_numButtons].w = w;
    _buttonRect[_numButtons].h = h;
    sprintf(_buttonType[_numButtons], "%.*@", BUFSIZE-1, type);
    if (link) {
        sprintf(_buttonLink[_numButtons], "%.*@", BUFSIZE-1, link);
    } else {
        strcpy(_buttonLink[_numButtons], "");
    }
    _numButtons++;

    _cursorX += w;
    if (_cursorH < h) {
        _cursorH = h;
    }

    return w;
}

- (void)drawTextCString:(char *)p :(char *)q
{
    if (p == q) {
        return;
    }

    int maxWidth = _r.w;

    id text = nsfmt(@"%.*s", q-p, p);
    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    [_bitmap drawBitmapText:text x:_cursorX y:_cursorY];
    _cursorX += textWidth;
    if (_cursorH < textHeight) {
        _cursorH = textHeight;
    }
}
- (void)drawText:(id)text
{
    if (!text) {
        return;
    }
    char *cstr = [text UTF8String];
    char *p = cstr;
    char *q = p;
    for(;;) {
        if (!*q) {
            [self drawTextCString:p :q];
            return;
        }
        if (*q == '@') {
            if (q[1] == '{') {
                [self drawTextCString:p :q];
                goto bracket;
            } else {
                q++;
            }
        } else if (*q == '\n') {
            [self drawTextCString:p :q];
            p = q+1;
            q = p;
            _cursorY += _cursorH;
            _cursorX = 2+_leftMargin;
            _cursorH = _textHeight;
        } else {
            q++;
        }
        continue;

    bracket:
        BOOL isQuoted = NO;
        id tokens = nsarr();
        q += 2;
        char *r = q;
        for(;;) {
            if (!*r) {
                return;
            }
            if (*r == '}') {
                if (r > q) {
                    id str = nsfmt(@"%.*s", r-q, q);
                    [tokens addObject:str];
                }
if ([[tokens nth:1] isEqual:@"link"]) {
    [self drawButton:[tokens nth:0] type:@"link" link:[tokens nth:2] minWidth:0];
}
                p = r+1;
                q = p;
                break;
            } else if (*r == ' ') {
                if (!isQuoted) {
                    if (r > q) {
                        id str = nsfmt(@"%.*s", r-q, q);
                        [tokens addObject:str];
                        q = r+1;
                        r = q;
                        continue;
                    } else {
                        q++;
                        r = q;
                        continue;
                    }
                } else {
                    r++;
                    continue;
                }
            } else if (*r == '"') {
                if (isQuoted) {
                    id str = nsfmt(@"%.*s", r-q, q);
                    [tokens addObject:str];
                    q = r+1;
                    r = q;
                    isQuoted = NO;
                    continue;
                } else {
                    q = r+1;
                    r = q;
                    isQuoted = YES;
                    continue;
                }
            } else {
                r++;
                continue;
            }
        }
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [self setValue:bitmap forKey:@"bitmap"];
    _r = r;
    _textHeight = [bitmap bitmapHeightForText:@"X"];

    _numButtons = 0;

    [bitmap useTopazFont];
    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRect:r];

    _cursorX = r.x+2+_leftMargin;
    _cursorY = -_scrollY+r.y+2 + 22+2 + 4+2;


    [bitmap setColor:@"black"];
    id text = nsfmt(@"%@", _nodeText);
    [self drawText:text];


    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRectangleAtX:r.x y:r.y w:r.w h:2+22+4+2];
    _cursorX = r.x+2;
    _cursorY = r.y+2;


    id type = nil;
    int w;
    w = [self drawButton:@"Contents" type:@"contents" link:nil minWidth:76];
    _cursorX += 2;
    w = [self drawButton:@"Index" type:@"index" link:nil minWidth:76];
    _cursorX += 2;
    w = [self drawButton:@"Help" type:nil link:nil minWidth:76];
    _cursorX += 2;
    if ([_history count] > 0) {
        type = @"back";
    } else {
        type = nil;
    }
    w = [self drawButton:@"Retrace" type:type link:nil minWidth:76];
    _cursorX += 2;
    if (_prevNode) {
        type = @"prev";
    } else {
        type = nil;
    }
    w = [self drawButton:@"Browse <" type:type link:nil minWidth:76];
    _cursorX += 2;
    if (_nextNode) {
        type = @"next";
    } else {
        type = nil;
    }
    w = [self drawButton:@"Browse >" type:type link:nil minWidth:76];

    _cursorY += _cursorH + 2;
    _cursorH = _textHeight;


    [Definitions drawInBitmap:bitmap left:separatorPixels palette:buttonPalette middle:separatorPixels palette:buttonPalette right:separatorPixels palette:buttonPalette x:r.x+2 y:_cursorY w:r.w-4];
    _cursorY += 4 + 2;


    [self setValue:nil forKey:@"bitmap"];
}
- (void)handleMouseDown:(id)event
{
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
    _buttonDown = -1;
    for (int i=0; i<_numButtons; i++) {
        if ([Definitions isX:_mouseX y:_mouseY insideRect:_buttonRect[i]]) {
            _buttonDown = i;
            break;
        }
    }
}
- (void)handleMouseMoved:(id)event
{
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
    _buttonHover = -1;
    for (int i=0; i<_numButtons; i++) {
        if ([Definitions isX:_mouseX y:_mouseY insideRect:_buttonRect[i]]) {
            _buttonHover = i;
            break;
        }
    }
}
- (void)handleMouseUp:(id)event
{
    if ((_buttonDown != -1) && (_buttonDown == _buttonHover)) {
        if (!strcmp(_buttonType[_buttonDown], "contents")) {
            [self addToHistory:_curNode];
            [self loadNode:@"main"];
        } else if (!strcmp(_buttonType[_buttonDown], "index")) {
            [self addToHistory:_curNode];
            [self loadNode:@"main"];
        } else if (!strcmp(_buttonType[_buttonDown], "help")) {
        } else if (!strcmp(_buttonType[_buttonDown], "back")) {
            int count = [_history count];
            if (count > 0) {
                int index = count-1;
                id elt = [_history nth:index];
                [self loadNode:elt];
                [_history removeObjectAtIndex:index];
            }
        } else if (!strcmp(_buttonType[_buttonDown], "prev")) {
            if (_prevNode) {
                [self addToHistory:_curNode];
                [self loadNode:_prevNode];
            }
        } else if (!strcmp(_buttonType[_buttonDown], "next")) {
            if (_nextNode) {
                [self addToHistory:_curNode];
                [self loadNode:_nextNode];
            }
        } else if (!strcmp(_buttonType[_buttonDown], "link")) {
            [self addToHistory:_curNode];
            id node = nsfmt(@"%s", _buttonLink[_buttonDown]);
            [self loadNode:node];
        }
    }

    _buttonDown = -1;
}
- (void)handleScrollWheel:(id)event
{
    _scrollY -= [event intValueForKey:@"deltaY"];
}
@end

