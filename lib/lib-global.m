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

@implementation Definitions(fjkdslfjklsdjf)

+ (id)globalContext
{
    static NSDictionary *dict = nil;
    if (!dict) {
        dict = [[NSDictionary alloc] init];
    }
    return dict;
}

@end





@implementation NSString(fjdklsfjlksdjflksdlkfj)
- (id)str
{
    return [self strWithContext:[Definitions globalContext]];
}
- (void)setNilValueForKey
{
    [[Definitions globalContext] setValue:nil forKey:self];
}

- (id)valueForKey
{
    id val = [[Definitions globalContext] valueForKey:self];
    return val;
}

- (int)intValueForKey
{
    id val = [[Definitions globalContext] valueForKey:self];
    return [val intValue];
}

- (double)doubleValueForKey
{
    id val = [[Definitions globalContext] valueForKey:self];
    return [val doubleValue];
}

@end

@implementation NSObject(jfkldsjfklsdjkfljsdklfj)
- (void)setAsValueForKey:(id)key
{
    [[Definitions globalContext] setValue:self forKey:key];
}
@end
