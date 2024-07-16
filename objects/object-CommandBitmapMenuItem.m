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

// for compatibility
// CommandOutputBitmap has been renamed to CommandBitmapMenuItem
@implementation Definitions(fjkdlsjkfjkdfjlksdjdskfldsjkfjfkdlsmfkldsmkfljkf)
+ (id)CommandOutputBitmap:(id)cmd
{
    id process = [cmd runCommandAndReturnProcess];
    id obj = [@"CommandBitmapMenuItem" asInstance];
    [obj setValue:process forKey:@"fileDescriptor"];
    return obj;
}
@end

@implementation Definitions(fjkdlsfjlksdjdskfldsjkfjfkdlsmfkldsmkfljkf)
+ (id)CommandBitmapMenuItem:(id)cmd
{
    id process = [cmd runCommandAndReturnProcess];
    id obj = [@"CommandBitmapMenuItem" asInstance];
    [obj setValue:process forKey:@"fileDescriptor"];
    return obj;
}
@end


@interface CommandBitmapMenuItem : IvarObject
{
    id _fileDescriptor;
    id _firstLine;
    id _pixels;
    id _palette;
    id _highlightedPalette;
}
@end
@implementation CommandBitmapMenuItem
- (int)fileDescriptor
{
    if (_fileDescriptor) {
        return [_fileDescriptor fileDescriptor];
    }
    return -1;
}
- (void)handleData:(id)data
{
    for(;;) {
        if (!_firstLine) {
            id line = [data readLine];
            if (!line) {
                break;
            }
            line = [line chomp];
            if (![line length]) {
                continue;
            }
            [self setValue:line forKey:@"firstLine"];
        } else {
            id lines = [data readGroupOfLines];
            if (!lines) {
                break;
            }
            id arr = [@"pixels palette highlightedPalette" split];
            if ([arr containsObject:_firstLine]) {
                [self setValue:lines forKey:_firstLine];
                [self setValue:nil forKey:@"firstLine"];
            }
        }
    }
}
- (void)handleFileDescriptor
{
    if (_fileDescriptor) {
        [_fileDescriptor handleFileDescriptor];
        [self handleData:[_fileDescriptor valueForKey:@"data"]];
    }
}
@end
