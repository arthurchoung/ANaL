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

/* Use the newer ALSA API */
#define ALSA_PCM_NEW_HW_PARAMS_API

#include <alsa/asoundlib.h>

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
    BOOL _initialized;
    snd_pcm_t *_handle;
}
@end
@implementation AudioOutput
- (void)dealloc
{
    [self closeAudio];
    [super dealloc];
}
- (void)openAudioWithSampleRate:(int)sampleRate frameCount:(int)frameCount channels:(int)channels bitsPerChannel:(int)bitsPerChannel
{
    if (_initialized) {
        [self closeAudio];
    }

    int result = snd_pcm_open(&_handle, "default", SND_PCM_STREAM_PLAYBACK, 0);
    if (result < 0) {
NSLog(@"Unable to open pcm device, %s", snd_strerror(result));
        exit(1);
    }

    snd_pcm_hw_params_t *params = 0;
    snd_pcm_hw_params_alloca(&params);

    /* Default values */
    snd_pcm_hw_params_any(_handle, params);

    /* Interleaved mode */
    snd_pcm_hw_params_set_access(_handle, params, SND_PCM_ACCESS_RW_INTERLEAVED);

    /* Signed 16-bit little-endian format */
    if (bitsPerChannel == 16) {
        snd_pcm_hw_params_set_format(_handle, params, SND_PCM_FORMAT_S16_LE);
    } else if (bitsPerChannel == 8) {
        snd_pcm_hw_params_set_format(_handle, params, SND_PCM_FORMAT_S8);
    } else {
NSLog(@"Error, %d bits per channel unsupported", bitsPerChannel);
exit(1);
    }

    /* Number of channels */
    snd_pcm_hw_params_set_channels(_handle, params, channels);

    /* Sampling rate */
    unsigned int val = sampleRate;
    int dir = 0;
    snd_pcm_hw_params_set_rate_near(_handle, params, &val, &dir);

    /* Write params to driver */
    result = snd_pcm_hw_params(_handle, params);
    if (result < 0) {
NSLog(@"Unable to set hw params, %s", snd_strerror(result));
        exit(1);
    }

    _initialized = YES;
}
- (void)writeAudio:(void *)buffer frameCount:(int)frameCount
{
    if (!_initialized) {
        return;
    }

    int result = snd_pcm_writei(_handle, buffer, frameCount);
    if (result == -EPIPE) {
NSLog(@"underrun");
        snd_pcm_prepare(_handle);
    } else if (result < 0) {
NSLog(@"writei error, %s", snd_strerror(result));
    } else if (result != frameCount) {
NSLog(@"incomplete writei");
    }
}
- (void)closeAudio
{
    if (_initialized) {
        snd_pcm_drain(_handle);
        snd_pcm_close(_handle);
        _initialized = NO;
    }
}
@end

