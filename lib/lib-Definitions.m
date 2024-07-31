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

#include <stdarg.h>
#include <sys/time.h>

id nsarr()//$;
{
    return [[[NSArray alloc] init] autorelease];
}
id nsdict()//$;
{
    return [[[NSDictionary alloc] init] autorelease];
}
id nsdata()//$;
{
    return [[[NSData alloc] init] autorelease];
}
id nsfmt(id formatString, ...)///$;
{
    va_list args;
    va_start(args, formatString);
    id str = [[[NSString alloc] initWithFormat:formatString arguments:args] autorelease];
    va_end(args);
    return str;
}

id nscstr(char *str)//$;
{
    return (str) ? [NSString stringWithUTF8String:str] : nil;
}
id nscstrn(char *str, int len)//$;
{
    return (str) ? [[[NSString alloc] initWithBytes:str length:len] autorelease] : nil;
}

@implementation Definitions
+ (id)gettimeofday
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return nsfmt(@"%ld.%06ld", tv.tv_sec, tv.tv_usec);
}

+ (id)valueForEnvironmentVariable:(id)key
{
    if (!key) {
        return nil;
    }
    char *str = getenv([key UTF8String]);
    if (!str) {
        return nil;
    }
    return nsfmt(@"%s", str);
}
+ (void)setValue:(id)val forEnvironmentVariable:(id)key
{
    setenv([key UTF8String], [val UTF8String], 1);
}

+ (id)processID
{
    return nsfmt(@"%d", getpid());
}

+ (double)percentageChangeFrom:(double)from to:(double)to
{
    return ((to - from) / from) * 100.0;
}
+ (double)degreesToRadians:(double)angle
{
    return (angle * 0.01745329252);
}

+ (void)sendTerminationSignalToSelf
{
    kill(getpid(), SIGTERM);
}
+ (void)exit:(int)code
{
    exit(code);
}


+ (id)arrayOfRandomDoubles:(int)count
{
    id arr = nsarr();
    for (int i=0; i<count; i++) {
        [arr addObject:nsfmt(@"%f", [Definitions randomDouble])];
    }
    return arr;
}

+ (double)randomDouble
{
    static BOOL first = YES;
    if (first) {
        srand48(time(0));
        first = NO;
    }
    
    return drand48();
}

+ (int)randomInt:(int)maximum
{
    static BOOL first = YES;
    if (first) {
        struct timeval tv;
        gettimeofday(&tv, NULL);
        srandom(tv.tv_usec+getpid());
        first = NO;
    }
    int n = random() % maximum;
    return n;
}


+ (id)decodeBase64Bytes:(unsigned char *)bytes length:(int)len
{
    if (!len) {
        return nil;
    }
    id result = [Definitions dataWithCapacity:len];

    unsigned char *base64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    int base64numchars = strlen(base64chars);
    unsigned char base64table[256];

    for (int i=0; i<256; i++) {
        base64table[i] = base64numchars;
    }
    for (int i=0; i<base64numchars; i++) {
        unsigned char c = base64chars[i];
        base64table[c] = i;
    }

    uint16_t bits = 0;
    int numbits = 0;

    unsigned char *dst = [result bytes];
    unsigned char *q = dst;
    for (int i=0; i<len; i++) {
        if (base64table[bytes[i]] >= base64numchars) {
            continue;
        }
        if (numbits) {
            bits <<= 6;
        }
        bits &= 0xffc0;
        bits |= base64table[bytes[i]];
        numbits += 6;
        if (numbits >= 8) {
            uint16_t val = bits;
            if (numbits > 8) {
                val >>= (numbits % 8);
            }
            numbits -= 8;
            *q = (unsigned char)val;
            q++;
        }
    }
    [result setLength:q-dst];
    return result;
}

@end

