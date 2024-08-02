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

static id _navigationStack = nil;

static char *cStringForBitmapBackButtonLeft =
"     b\n"
"    bb\n"
"    b.\n"
"   bb.\n"
"   b..\n"
"  bb..\n"
"  b...\n"
" bb...\n"
" b....\n"
"bb....\n"
"bb....\n"
" b....\n"
" bb...\n"
"  b...\n"
"  bb..\n"
"   b..\n"
"   bb.\n"
"    b.\n"
"    bb\n"
"     b\n"
;
static char *cStringForBitmapBackButtonMiddle =
"b\n"
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
;
static char *cStringForBitmapBackButtonRight =
"b   \n"
".bb \n"
"..b \n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"..b \n"
".bb \n"
"b   \n"
;
static char *cStringForBitmapForwardButtonLeft =
"   b\n"
" bb.\n"
" b..\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
" b..\n"
" bb.\n"
"   b\n"
;
static char *cStringForBitmapForwardButtonMiddle =
"b\n"
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
;
static char *cStringForBitmapForwardButtonRight =
"b     \n"
"bb    \n"
".b    \n"
".bb   \n"
"..b   \n"
"..bb  \n"
"...b  \n"
"...bb \n"
"....b \n"
"....bb\n"
"....bb\n"
"....b \n"
"...bb \n"
"...b  \n"
"..bb  \n"
"..b   \n"
".bb   \n"
".b    \n"
"bb    \n"
"b     \n"
;

static void drawForwardButtonInBitmap_rect_palette_(id bitmap, Int4 r, char *palette)
{
    char *left = cStringForBitmapForwardButtonLeft;
    char *middle = cStringForBitmapForwardButtonMiddle;
    char *right = cStringForBitmapForwardButtonRight;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:palette];
}
static void drawBackButtonInBitmap_rect_palette_(id bitmap, Int4 r, char *palette)
{
    char *left = cStringForBitmapBackButtonLeft;
    char *middle = cStringForBitmapBackButtonMiddle;
    char *right = cStringForBitmapBackButtonRight;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:palette];
}

@implementation NSObject(Jfkldslkfjsdklfj)
- (id)asNavigationStack
{
    id obj = [@"NavigationStack" asInstance];
    [obj pushObject:self];
    return obj;
}
@end



@implementation Definitions(fjdkslfjklsdjf)
+ (void)popFromNavigationStack
{
    [[Definitions navigationStack] popObject];
}

+ (int)navigationBarHeight
{
    return 44;
}



+ (id)navigationStack
{
    if (!_navigationStack) {
        _navigationStack = [@"NavigationStack" asInstance];
        [_navigationStack retain];
    }
    return _navigationStack;
}

@end



@implementation NSDictionary(fjkldsjfklsdjfk)
- (void)pushToNavigationStack
{
    id obj = nsfmt(@"%@", self);
    [obj pushToNavigationStack];
}
@end

@implementation NSArray(jfkdsljfklsdjf)
- (void)pushToNavigationStack
{
    id obj = nsfmt(@"%@", self);
    [obj pushToNavigationStack];
}
@end
@implementation NSString(jfkldsjklfjsdkf)
- (void)pushToNavigationStack
{
NSLog(@"pushToNavigationStack %@", self);
    [[Definitions navigationStack] pushObject:self];
}
@end
@implementation NSObject(jfkldsjklfjsdkf)
- (void)pushToNavigationStack
{
NSLog(@"pushToNavigationStack %@", self);
    [[Definitions navigationStack] pushObject:self];
}
- (void)replaceTopOfNavigationStack
{
    id nav = [Definitions navigationStack];
    id context = [nav valueForKey:@"context"];
    [context setValue:self forKey:@"object"];
}
@end

@interface NavigationStack : IvarObject
{
    BOOL _buttonPassthrough;
    id _buttonDown;
    id _buttonHover;
    id _context;
    id _rightButtonDown;
    int _animateIteration;
    int _animateMaxIteration;
    id _animateFromContext;
    id _animateToContext;
    id _animateTransition;
    id _defaultTitle;
    BOOL _updateWindowName;
}
@end

@implementation NavigationStack
- (id)contextualMenu
{
    id obj = [_context valueForKey:@"object"];
    if ([obj respondsToSelector:@selector(contextualMenu)]) {
        id menu = [obj contextualMenu];
        if ([menu isArray]) {
            menu = [menu asMenu];
            [menu setValue:obj forKey:@"contextualObject"];
        }
        return menu;
    }
    return nil;
}

- (void)drawTransitionInBitmap:(id)bitmap rect:(Int4)r
{
//FIXME use textures
    int w = r.w;
    int h = r.h;

    if ([_animateTransition isEqual:@"forward"]) {
        [bitmap setColor:@"white"];
        [bitmap fillRect:r];
        double pct = (double)_animateIteration / (double)_animateMaxIteration;
        id prevObject = [_animateFromContext valueForKey:@"object"];
        id prevBitmap = [_animateFromContext valueForKey:@"bitmap"];
        if (!prevBitmap) {
            prevBitmap = [Definitions bitmapWithWidth:w height:h];
            if ([prevObject respondsToSelector:@selector(drawInBitmap:rect:)]) {
                [prevObject drawInBitmap:prevBitmap rect:[Definitions rectWithX:0 y:0 w:w h:h]];
            }
            [_animateFromContext setValue:prevBitmap forKey:@"bitmap"];
        }
        id nextObject = [_animateToContext valueForKey:@"object"];
        id nextBitmap = [_animateToContext valueForKey:@"bitmap"];
        if (!nextBitmap) {
            nextBitmap = [Definitions bitmapWithWidth:w height:h];
            if ([nextObject respondsToSelector:@selector(drawInBitmap:rect:)]) {
                [nextObject drawInBitmap:nextBitmap rect:[Definitions rectWithX:0 y:0 w:w h:h]];
            }
            [_animateToContext setValue:nextBitmap forKey:@"bitmap"];
        }
        [bitmap drawBitmap:prevBitmap x:-w*pct y:r.y];
        [bitmap drawBitmap:nextBitmap x:w-w*pct y:r.y];
    } else if ([_animateTransition isEqual:@"reverse"]) {
        [bitmap setColor:@"white"];
        [bitmap fillRect:r];
        double pct = (double)_animateIteration / (double)_animateMaxIteration;

        id prevObject = [_animateFromContext valueForKey:@"object"];
        id prevBitmap = [_animateFromContext valueForKey:@"bitmap"];
        if (!prevBitmap) {
            prevBitmap = [Definitions bitmapWithWidth:w height:h];
            if ([prevObject respondsToSelector:@selector(drawInBitmap:rect:)]) {
                [prevObject drawInBitmap:prevBitmap rect:[Definitions rectWithX:0 y:0 w:w h:h]];
            }
            [_animateFromContext setValue:prevBitmap forKey:@"bitmap"];
        }
        id nextObject = [_animateToContext valueForKey:@"object"];
        id nextBitmap = [_animateToContext valueForKey:@"bitmap"];
        if (!nextBitmap) {
            nextBitmap = [Definitions bitmapWithWidth:w height:h];
            if ([nextObject respondsToSelector:@selector(drawInBitmap:rect:)]) {
                [nextObject drawInBitmap:nextBitmap rect:[Definitions rectWithX:0 y:0 w:w h:h]];
            }
            [_animateToContext setValue:nextBitmap forKey:@"bitmap"];
        }




        [bitmap drawBitmap:prevBitmap x:w*pct y:r.y];
        [bitmap drawBitmap:nextBitmap x:-w+w*pct y:r.y];
    }
}

- (void)transition:(id)transition context:(id)nextContext
{
    _animateIteration = 0;
    _animateMaxIteration = 12;
    [self setValue:transition forKey:@"animateTransition"];
    [self setValue:_context forKey:@"animateFromContext"];
    [self setValue:nextContext forKey:@"animateToContext"];
    [self setValue:nil forKey:@"context"];
}


- (void)popToObject:(id)obj
{
    id cursor = _context;
    for(;;) {
        cursor = [cursor valueForKey:@"previous"];
        if (cursor) {
NSLog(@"popToObject %@", [cursor valueForKey:@"object"]);
            if (obj == [cursor valueForKey:@"object"]) {
                [self transition:@"reverse" context:cursor];
                return;
            }
        } else {
            break;
        }
    }
}

- (void)popObject
{
NSLog(@"popObject");
    id previous = [_context valueForKey:@"previous"];
    if (previous) {
        id previousObject = [previous valueForKey:@"object"];
        if (previousObject) {
            id currentDirectory = [previousObject valueForKey:@"currentDirectory"];
NSLog(@"currentDirectory '%@'", currentDirectory);
            if (currentDirectory) {
                [currentDirectory changeDirectory];
                if ([previousObject respondsToSelector:@selector(updateArrayAndTimestamp)]) {
                    [previousObject updateArrayAndTimestamp];
                }
                _updateWindowName = YES;
            }
        }
        [self transition:@"reverse" context:previous];
    }
}

- (void)pushObject:(id)obj
{
    if (!obj) {
        return;
    }
    if ([[obj className] isEqual:@"NavigationStack"]) {
NSLog(@"pushObject:%@ not allowed", obj);
        return;
    }
    id newContext = nsdict();
    [newContext setValue:_context forKey:@"previous"];
    [newContext setValue:obj forKey:@"object"];
    if (!_context) {
        [self setValue:newContext forKey:@"context"];
    } else {
        [self transition:@"forward" context:newContext];
    }
    _updateWindowName = YES;
}


- (int)fileDescriptor
{
    id obj = [_context valueForKey:@"object"];
    if ([obj respondsToSelector:@selector(fileDescriptor)]) {
        return [obj fileDescriptor];
    }
    return -1;
}
- (void)handleFileDescriptor
{
    id obj = [_context valueForKey:@"object"];
    if ([obj respondsToSelector:@selector(handleFileDescriptor)]) {
        [obj handleFileDescriptor];
    }
}
- (id)fileDescriptorObjects
{
    id obj = [_context valueForKey:@"object"];
    if ([obj respondsToSelector:@selector(fileDescriptorObjects)]) {
        return [obj fileDescriptorObjects];
    }
    return nil;
}

- (void)handleBackgroundUpdate:(id)x11dict
{
    id obj = [_context valueForKey:@"object"];
    if (obj) {
        if ([obj respondsToSelector:@selector(handleBackgroundUpdate:)]) {
            [obj handleBackgroundUpdate:x11dict];
        }
    }
}
- (BOOL)shouldAnimate
{
    if (_animateIteration < _animateMaxIteration) {
        return YES;
    }
    id obj = [_context valueForKey:@"object"];
    if (obj) {
        if ([obj respondsToSelector:@selector(shouldAnimate)]) {
            if ([obj shouldAnimate]) {
                return YES;
            }
        }
    }
    return NO;
}
    
- (void)beginIteration:(id)x11dict rect:(Int4)r
{
    if (_updateWindowName) {
        [x11dict setValue:[@"." asRealPath] forKey:@"changeWindowName"];
        _updateWindowName = NO;
    }
    if (_animateIteration < _animateMaxIteration) {
NSLog(@"beginIteration animateIteration %d", _animateIteration);
        _animateIteration++;
        if (_animateIteration >= _animateMaxIteration) {
            [_animateFromContext setValue:nil forKey:@"bitmap"];
            [_animateToContext setValue:nil forKey:@"bitmap"];
            [self setValue:_animateToContext forKey:@"context"];
            [self setValue:nil forKey:@"animateFromContext"];
            [self setValue:nil forKey:@"animateToContext"];
NSLog(@"context %@", _context);
        }
        return;
    }
    id obj = [_context valueForKey:@"object"];
    if (obj) {
        if ([obj respondsToSelector:@selector(beginIteration:rect:)]) {
            [obj beginIteration:x11dict rect:r];
        }
    }
}
- (void)endIteration:(id)x11dict
{
    id obj = [_context valueForKey:@"object"];
    if (obj) {
        if ([obj respondsToSelector:@selector(endIteration:)]) {
            [obj endIteration:x11dict];
        }
    }
}


- (id)buttonForMousePosEvent:(id)event x11dict:(id)x11dict
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];

    if (mouseY < 0) {
        return nil;
    }
    if (mouseY >= [Definitions navigationBarHeight]) {
        return nil;
    }

    int x11W = [x11dict intValueForKey:@"w"];

    if (mouseX < 0) {
        return nil;
    } else if (mouseX >= x11W) {
        return nil;
    } else if (mouseX < x11W / 4) {
        return @"backButton";
    } else if (mouseX > x11W / 4 * 3) {
        return @"forwardButton";
    } else {
        return @"header";
    }
    
    return nil;
}

- (void)handleKeyDown:(id)event
{
    id obj = [_context valueForKey:@"object"];
    if ([obj respondsToSelector:@selector(handleKeyDown:)]) {
        [obj handleKeyDown:event];
    }
}
- (void)handleScrollWheel:(id)event
{
    id obj = [_context valueForKey:@"object"];
    if ([obj respondsToSelector:@selector(handleScrollWheel:)]) {
        [obj handleScrollWheel:event];
    }
}
- (void)handleRightMouseDown:(id)event
{
    id obj = [_context valueForKey:@"object"];
    int mouseY = [event intValueForKey:@"mouseY"];
    int navigationBarHeight = [Definitions navigationBarHeight];
    if (mouseY < navigationBarHeight) {
        id message = [obj valueForKey:@"navigationRightMouseDownMessage"];
        if ([message length]) {
            int mouseRootX = [event intValueForKey:@"mouseRootX"];
            int mouseRootY = [event intValueForKey:@"mouseRootY"];
            id result = [self evaluateMessage:message];
            if (result) {
                [result setValue:self forKey:@"contextualObject"];
                id windowManager = [Definitions windowManager];
                [windowManager openButtonDownMenuForObject:result x:mouseRootX y:mouseRootY w:0 h:0];
            }
        }
    } else {
        if ([obj respondsToSelector:@selector(handleRightMouseDown:)]) {
            [obj handleRightMouseDown:event];
        }
    }
}
- (void)handleMouseDown:(id)event context:(id)x11dict
{
    id obj = [_context valueForKey:@"object"];
    int mouseY = [event intValueForKey:@"mouseY"];
    int navigationBarHeight = [Definitions navigationBarHeight];
    if (mouseY < navigationBarHeight) {
        id button = [self buttonForMousePosEvent:event x11dict:x11dict];
        [self setValue:button forKey:@"buttonDown"];
        _buttonPassthrough = NO;
    } else {
        if ([obj respondsToSelector:@selector(handleMouseDown:)]) {
            [obj handleMouseDown:event];
        }
        _buttonPassthrough = YES;
    }
}

- (void)handleMouseUp:(id)event
{
    id obj = [_context valueForKey:@"object"];
    if (!_buttonPassthrough) {
        if (!_buttonDown) {
            return;
        }
        id buttonDown = _buttonDown;
        [self setValue:nil forKey:@"buttonDown"];
        _buttonPassthrough = NO;
        if ([buttonDown isEqual:_buttonHover]) {
            if ([buttonDown isEqual:@"backButton"]) {
                [self goBack];
            } else if ([buttonDown isEqual:@"forwardButton"]) {
            }
        }
    } else {
        int navigationBarHeight = [Definitions navigationBarHeight];
        if ([obj respondsToSelector:@selector(handleMouseUp:)]) {
            [obj handleMouseUp:event];
        }
        _buttonPassthrough = NO;
    }
}


- (void)handleMouseMoved:(id)event context:(id)x11dict
{
    id obj = [_context valueForKey:@"object"];
    int mouseY = [event intValueForKey:@"mouseY"];
    int cellHeight = [Definitions navigationBarHeight];
    BOOL passthrough = NO;
    if (_buttonDown) {
        passthrough = _buttonPassthrough;
    } else {
        if (mouseY < cellHeight) {
            passthrough = NO;
        } else {
            passthrough = YES;
        }
    }
    
    if (!passthrough) {
        id button = [self buttonForMousePosEvent:event x11dict:x11dict];
        [self setValue:button forKey:@"buttonHover"];
    } else {
        if ([obj respondsToSelector:@selector(handleMouseMoved:)]) {
            [obj handleMouseMoved:event];
        }
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    int navigationBarHeight = [Definitions navigationBarHeight];

    id title = nil;

    Int4 r1 = r;
    r1.y += navigationBarHeight;
    r1.h -= navigationBarHeight;

    if (_animateIteration < _animateMaxIteration) {
        [self drawTransitionInBitmap:bitmap rect:r1];
    } else {
        id obj = [_context valueForKey:@"object"];
        if (obj) {
            id headerFormat = [obj valueForKey:@"headerFormat"];
            if (headerFormat) {
                title = [obj str:headerFormat];
            } else if (_defaultTitle) {
                title = _defaultTitle;
            } else {
                title = [@"." asRealPath];//nsfmt(@"%@", [obj class]);
            }


            if ([obj respondsToSelector:@selector(drawInBitmap:rect:)]) {
                [obj drawInBitmap:bitmap rect:r1];
                goto end;
            }
#ifndef BUILD_FOR_ANDROID
            if ([obj respondsToSelector:@selector(pixelBytesRGBA8888)]) {
                if (![[Definitions windowManager] valueForKey:@"openGLTexture"]) {
                    char *bytes = [obj pixelBytesRGBA8888];
                    if (bytes) {
                        int bitmapWidth = [obj bitmapWidth];
                        int bitmapHeight = [obj bitmapHeight];
                        [bitmap drawBytes:bytes bitmapWidth:bitmapWidth bitmapHeight:bitmapHeight x:r.x y:navigationBarHeight+r.y w:r.w h:r.h-navigationBarHeight]; // I think the y: calculation is wrong
                        goto end;
                    }
                }
            }

            if ([obj respondsToSelector:@selector(pixelBytesBGR565)]) {
                if (![[Definitions windowManager] valueForKey:@"openGLTexture"]) {
                    char *bytes = [obj pixelBytesBGR565];
                    if (bytes) {
                        int bitmapWidth = [obj bitmapWidth];
                        int bitmapHeight = [obj bitmapHeight];
                        [bitmap drawBytes565:bytes bitmapWidth:bitmapWidth bitmapHeight:bitmapHeight x:r.x y:navigationBarHeight+r.y w:r.w h:r.h-navigationBarHeight]; // I think the y: calculation is wrong
                        goto end;
                    }
                }
            }
#endif

            [bitmap setColor:@"white"];
            [bitmap fillRect:r1];
            [bitmap setColor:@"black"];
            id text = [obj description];
            text = [bitmap fitBitmapString:text width:r1.w-10];
            [bitmap drawBitmapText:text x:r1.x+5 y:r1.y+5];
        }
    }
end:

    [self drawNavigationBarInBitmap:bitmap rect:r title:title backButton:([_context valueForKey:@"previous"]) ? @"Back" : nil forwardButton:nil];



}
- (void)drawNavigationBarInBitmap:(id)bitmap rect:(Int4)rect title:(id)title backButton:(id)backButton forwardButton:(id)forwardButton
{
    [bitmap useChicagoFont];

    int cellHeight = [Definitions navigationBarHeight];

    Int4 headerRect = [Definitions rectWithX:rect.x y:rect.y w:rect.w h:cellHeight];
//    [bitmap setColor:@"#7990ae"];
[bitmap setColor:@"#6688bb"];
    [bitmap fillRect:headerRect];
Int4 shadowRect = headerRect;
shadowRect.y -= 1;
    [bitmap setColorIntR:0x4c g:0x55 b:0x61 a:255];
    [bitmap drawBitmapText:title centeredInRect:shadowRect];
    [bitmap setColorIntR:240 g:240 b:240 a:255];
    [bitmap drawBitmapText:title centeredInRect:headerRect];
    [bitmap setColor:@"black"];
    [bitmap drawHorizontalLineAtX:headerRect.x x:headerRect.x+headerRect.w y:headerRect.y+headerRect.h-1];
    
    if (backButton) {
        Int4 buttonRect = [Definitions rectWithX:headerRect.x y:headerRect.y w:headerRect.w/4.0 h:headerRect.h];
        if ([_buttonDown isEqual:@"backButton"] && [_buttonHover isEqual:@"backButton"]) {
            char *palette = ". #344972\nb #000000\n";
            drawBackButtonInBitmap_rect_palette_(bitmap, buttonRect, palette);
Int4 shadowRect = buttonRect;
shadowRect.y -= 1;
[bitmap setColorIntR:0x4c g:0x55 b:0x61 a:255];
[bitmap drawBitmapText:backButton centeredInRect:shadowRect];
[bitmap setColorIntR:255 g:255 b:255 a:255];
            [bitmap drawBitmapText:backButton centeredInRect:buttonRect];
        } else {
            char *palette = ". #587398\nb #000000\n";
            drawBackButtonInBitmap_rect_palette_(bitmap, buttonRect, palette);
Int4 shadowRect = buttonRect;
shadowRect.y -= 1;
[bitmap setColorIntR:0x4c g:0x55 b:0x61 a:255];
[bitmap drawBitmapText:backButton centeredInRect:shadowRect];
[bitmap setColorIntR:240 g:240 b:240 a:255];
            [bitmap drawBitmapText:backButton centeredInRect:buttonRect];
        }
    }

    if (forwardButton) {
        Int4 buttonRect = [Definitions rectWithX:headerRect.x+headerRect.w/4.0*3.0 y:headerRect.y w:headerRect.w/4.0 h:headerRect.h];
        if ([_buttonDown isEqual:@"forwardButton"] && [_buttonHover isEqual:@"forwardButton"]) {
            char *palette = ". #000000\nb #000000\n";
            drawForwardButtonInBitmap_rect_palette_(bitmap, buttonRect, palette);
            [bitmap setColorIntR:255 g:255 b:255 a:255];
            [bitmap drawBitmapText:forwardButton centeredInRect:buttonRect];
        } else {
            char *palette = ". #ffffff\nb #000000\n";
            drawForwardButtonInBitmap_rect_palette_(bitmap, buttonRect, palette);
            [bitmap setColorIntR:0 g:0 b:0 a:255];
            [bitmap drawBitmapText:forwardButton centeredInRect:buttonRect];
        }
    }
}
- (void)goBack
{
    [self popObject];
}

@end

