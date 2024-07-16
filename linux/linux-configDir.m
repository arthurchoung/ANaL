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

@implementation Definitions(fjkdsljfklsdjf)
+ (id)configDir
{
    id execDir = [Definitions execDir];
    if ([execDir isEqual:@"/usr/bin"]) {
        id homeConfigDir = [Definitions homeDir:@"ANaL"];
        if ([homeConfigDir isDirectory]) {
            return homeConfigDir;
        }
        return @"/etc/ANaL";
    }
    return execDir;
}

+ (id)configDir:(id)path
{
    return nsfmt(@"%@/%@", [Definitions configDir], path);
}
@end
