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

static int adjustedYForPct_rect_insideRect_(double pct, Int4 innerRect, Int4 outerRect)
{
    int val = outerRect.y+pct*(outerRect.h-innerRect.h);
    return val;
}

static double normalizedYForRect_insideRect_(Int4 innerRect, Int4 outerRect)
{
    return (double)(innerRect.y - outerRect.y) / (double)(outerRect.h-innerRect.h);
}


@implementation Definitions(fjkdlsjfklmnekwlvmlkdsjkvsfjdskfjsdk)
+ (id)VolumeMenu
{
    return [Definitions VolumeMenu:@"hw:0" :@"Master"];
}
+ (id)VolumeMenu:(id)cardName :(id)mixerName
{
    id obj = [@"VolumeMenu" asInstance];
    [obj setValue:cardName forKey:@"alsaCardName"];
    [obj setValue:mixerName forKey:@"alsaMixerName"];
    [obj setup];
    return obj;
}
@end

static char *sliderPalette =
/*
"b #000000\n"
". #6688bb\n"
"X #aaaaaa\n"
"o #ffffff\n"
*/
"b #000000\n"
". #555555\n"
"X #aaaaaa\n"
"o #ffffff\n"
;
static char *sliderTopPixels =
"booooooooooooooo\n"
;

static char *sliderMiddlePixels =
"bX.X.X.X.X.X.X.o\n"
"b.X.X.X.X.X.X.Xo\n"
;
static char *sliderBottomPixels =
"bbbbbbbbbbbbbbbb\n"
;
static char *sliderKnobPixels =
"bbbbbbbbbbbbbbbo\n"
"b.............bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"booooooooooooXbo\n"
"bo............bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boXXXXXXXXXXX.bo\n"
"boooooooooooo.bo\n"
"booooooooooooobo\n"
;







@interface VolumeMenu : IvarObject
{
    int _pixelScaling;

    id _alsaCardName;
    id _alsaMixerName;
    id _alsaStatus;
    id _alsaVolume;
    double _volume;
    int _playbackSwitch;
    double _grabbedSliderPct;
    int _mouseX;
    int _mouseY;
    Int4 _rectForVolumeSliderTrack;
    Int4 _rectForVolumeSliderKnob;
    int _grabbedVolumeSliderY;
}
@end
@implementation VolumeMenu
- (id)init
{
    self = [super init];
    if (self) {
        int scaling = [[Definitions valueForEnvironmentVariable:@"ANAL_SCALING"] intValue];
        if (scaling < 1) {
            scaling = 1;
        }
        _pixelScaling = scaling;

//FIXME scale pixels
    }
    return self;
}

- (void)setup
{
    id cmd = nsarr();
    [cmd addObject:@"anal-printALSAStatus"];
    if (_alsaCardName) {
        [cmd addObject:_alsaCardName];
        if (_alsaMixerName) {
            [cmd addObject:_alsaMixerName];
        }
    }
    id alsaStatus = [cmd runCommandAndReturnProcess];
    [self setValue:alsaStatus forKey:@"alsaStatus"];

    cmd = nsarr();
    [cmd addObject:@"anal-setALSAVolume"];
    if (_alsaCardName) {
        [cmd addObject:_alsaCardName];
        if (_alsaMixerName) {
            [cmd addObject:_alsaMixerName];
        }
    }
    id alsaVolume = [cmd runCommandAndReturnProcess];
    [self setValue:alsaVolume forKey:@"alsaVolume"];
    _volume = 0.0;
    _playbackSwitch = 0;
}

- (int)preferredWidth
{
    char *middle = sliderMiddlePixels;
    int widthForMiddle = [Definitions widthForCString:middle];
    return widthForMiddle+12*_pixelScaling;
}
- (int)preferredHeight
{
    return 200;
}
- (int)fileDescriptor
{
    int fd = [_alsaStatus fileDescriptor];
    return fd;
}

- (void)handleFileDescriptor
{
    [_alsaStatus handleFileDescriptor];
    for(;;) {
        id line = [[_alsaStatus valueForKey:@"data"] readLine];
        if (!line) {
            break;
        }
NSLog(@"alsaStatus '%@'", line);
        _playbackSwitch = [line intValueForKey:@"playbackSwitch"];
        _volume = [line doubleValueForKey:@"volume"];
    }
}

- (void)handleMouseMoved:(id)event
{
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];
    if (_grabbedVolumeSliderY) {
        [self updateVolumeSlider];
    } else {
        Int4 r = _rectForVolumeSliderKnob;
        if ([Definitions isX:_mouseX y:_mouseY insideRect:r]) {
            _grabbedSliderPct = _volume;
            _grabbedVolumeSliderY = _mouseY - _rectForVolumeSliderKnob.y;
        }
    }
}
- (void)handleMouseUp:(id)event
{
    id x11dict = [event valueForKey:@"x11dict"];
    [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
}

- (void)updateVolumeSlider
{
    double sliderPct = _grabbedSliderPct;
    int adjustedSliderY = adjustedYForPct_rect_insideRect_(sliderPct, _rectForVolumeSliderKnob, _rectForVolumeSliderTrack);
    if (_grabbedVolumeSliderY) {
        adjustedSliderY = _mouseY - _grabbedVolumeSliderY;
    }
    if (adjustedSliderY < _rectForVolumeSliderTrack.y) {
        adjustedSliderY = _rectForVolumeSliderTrack.y;
    }
    if (adjustedSliderY+_rectForVolumeSliderKnob.h >= _rectForVolumeSliderTrack.y+_rectForVolumeSliderTrack.h) {
        adjustedSliderY = _rectForVolumeSliderTrack.y+_rectForVolumeSliderTrack.h-_rectForVolumeSliderKnob.h;
    }
    Int4 newRectForSlider = _rectForVolumeSliderKnob;
    newRectForSlider.y = adjustedSliderY;
    double newSliderPct = normalizedYForRect_insideRect_(newRectForSlider, _rectForVolumeSliderTrack);
    newSliderPct = 1.0-newSliderPct;
    if (sliderPct != newSliderPct) {
        if (!_playbackSwitch) {
            static BOOL alreadyRun = NO;
            if (!alreadyRun) {
                id cmd = nsarr();
                [cmd addObject:@"anal-setALSAMute"];
                [cmd addObject:@"0"];
                if (_alsaCardName) {
                    [cmd addObject:_alsaCardName];
                    if (_alsaMixerName) {
                        [cmd addObject:_alsaMixerName];
                    }
                }
                [cmd runCommandInBackground];
                alreadyRun = YES;
            }
        }
        [_alsaVolume writeString:nsfmt(@"%f\n", newSliderPct)];
        _grabbedSliderPct = newSliderPct;
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [bitmap setColor:@"black"];
    [bitmap fillRect:r];
    r.x += 2*_pixelScaling;
    r.y += 2*_pixelScaling;
    r.w -= 4*_pixelScaling;
    r.h -= 4*_pixelScaling;
    [bitmap setColor:@"#aaaaaa"];
    [bitmap fillRect:r];
    r.x += 4*_pixelScaling;
    r.y += 4*_pixelScaling;
    r.w -= 8*_pixelScaling;
    r.h -= 8*_pixelScaling;

    id obj = self;

    double pct = _volume;
    if (_grabbedVolumeSliderY) {
        pct = _grabbedSliderPct;
    }

    _rectForVolumeSliderTrack = [Definitions rectWithX:r.x y:r.y+4 w:r.w h:r.h-8];
    double sliderPct = _volume;
    if (_grabbedVolumeSliderY) {
        sliderPct = _grabbedSliderPct;
    }
    int adjustedSliderY = adjustedYForPct_rect_insideRect_(1.0-sliderPct, _rectForVolumeSliderKnob, _rectForVolumeSliderTrack);
    _rectForVolumeSliderKnob = [Definitions rectWithX:r.x y:adjustedSliderY w:r.w h:12];

    char *top = sliderTopPixels;
    char *middle = sliderMiddlePixels;
    char *bottom = sliderBottomPixels;
    char *knob = sliderKnobPixels;

    int heightForTop = [Definitions heightForCString:top];
    int heightForMiddle = [Definitions heightForCString:middle];
    int heightForBottom = [Definitions heightForCString:bottom];
    int heightForKnob = [Definitions heightForCString:knob];

    int widthForMiddle = [Definitions widthForCString:middle];

    char *palette = sliderPalette;
    [bitmap drawCString:top palette:palette x:r.x y:r.y];
    int y;
    for (y=r.y+heightForTop; y<r.y+r.h-heightForBottom; y+=heightForMiddle) {
        [bitmap drawCString:middle palette:palette x:r.x y:y];
    }
    [bitmap drawCString:bottom palette:palette x:r.x y:r.y+r.h-heightForBottom];
    int knobY = (int)(r.h-heightForTop-heightForBottom-heightForKnob) * pct;
    [bitmap drawCString:knob palette:palette x:r.x y:r.y+r.h-heightForBottom-knobY-heightForKnob];
}

@end

