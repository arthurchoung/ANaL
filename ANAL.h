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

struct Int2 {
    union {
        int x;
        int w;
    };
    union {
        int y;
        int h;
    };
};
typedef struct Int2 Int2;

struct Int4 {
    int x;
    int y;
    int w;
    int h;
};
typedef struct Int4 Int4;

#define _GNU_SOURCE
#include <sys/param.h>
#import <objc/runtime.h>
#import <objc/Object.h>
#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdint.h>

id object_copy(id obj, size_t size);

typedef struct {
    unsigned long state;
    id *itemsPtr;
    unsigned long *mutationsPtr;
    unsigned long extra[5];
} NSFastEnumerationState;

@interface NSAutoreleasePool : Object
{
    id *_objs;
    int _nobjs;
    int _alloc;
}
@end
@interface NSConstantString : Object
{
#ifndef BUILD_WITH_GUNSTEP_RUNTIME
@public
#endif
    char *_contents;
    int _length;
}
@end
@interface NSObject : Object
{
#ifndef BUILD_WITH_GUNSTEP_RUNTIME
@public
#endif
    char *_contents;
    int _length;
    int _alloc;
    int _retainCount;
}
@end
@interface NSString : NSObject
@end
@interface NSMutableString : NSString
@end
@interface NSDictionary : NSObject
@end
@interface NSMutableDictionary : NSDictionary
@end
@interface NSArray : NSObject
@end
@interface NSMutableArray : NSArray
@end
@interface NSData : NSObject
@end
@interface NSMutableData : NSData
@end
@interface NSValue : NSObject
@end

@interface IvarObject : NSObject
@end
@interface Definitions : NSObject
@end

#import "ANAL-lib.h"
#import "ANAL-objects.h"

#import "ANAL-linux.h"

