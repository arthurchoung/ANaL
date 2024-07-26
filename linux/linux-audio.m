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

// FIXME: Couple of hacks, fix later
@implementation Definitions(fmekwlfeiosmfklxdvmosjdfiosdf)
+ (id)PercentString:(id)val
{
    return nsfmt(@"%@%%", val);
}
+ (id)MuteString
{
    return @"Mute";
}
@end


@implementation Definitions(fmekwlfmklsdmkfl)
+ (id)currentAudioDevice
{
    id path = [Definitions homeDir:@".asoundrc"];
    id str = [path stringFromFile];
    if ([str hasPrefix:@"#ANaL hw:"]) {
        int num = [str intValueForKey:@"hw"];
        return nsfmt(@"hw:%d", num);
    }
    return @"hw:0";
}
@end


@interface AudioOutput : IvarObject
{
    id _aplay;
    int _sampleRate;
    int _numberOfChannels;
    int _bitsPerChannel;
}
@end
@implementation AudioOutput

- (void)openAudioWithSampleRate:(int)sampleRate frameCount:(int)frameCount channels:(int)channels bitsPerChannel:(int)bitsPerChannel
{
    _sampleRate = sampleRate;
    _numberOfChannels = channels;
    _bitsPerChannel = bitsPerChannel;
    
    id cmd = nsarr();
    [cmd addObject:@"aplay"];
    [cmd addObject:@"-t"];
    [cmd addObject:@"raw"];
    [cmd addObject:@"-r"];
    [cmd addObject:nsfmt(@"%d", sampleRate)];
    [cmd addObject:@"-c"];
    [cmd addObject:nsfmt(@"%d", channels)];
    [cmd addObject:@"-f"];
    if (bitsPerChannel == 8) {
        [cmd addObject:@"S8"];
    } else {
        [cmd addObject:@"S16_LE"];
    }
    [cmd addObject:@"-"];
    id aplay = [cmd runCommandAndReturnProcess];
    [self setValue:aplay forKey:@"aplay"];
}   

- (void)writeAudio:(uint16_t *)buffer frameCount:(int)frameCount
{
    [_aplay writeBytes:buffer length:_numberOfChannels*(_bitsPerChannel/8)*frameCount];
}

- (void)closeAudio
{
    [self setValue:nil forKey:@"aplay"];
}
@end

