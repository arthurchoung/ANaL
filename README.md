# ANaL

Amiga, NeXTSTEP, and Linux -- Together at last!

  * Workbench 2.0 style window frames
  * NeXTStep style widgets (i.e. buttons)
  * Custom lightweight Objective-C foundation
  * Bitmapped graphics, low DPI displays
  * Running on Linux and X11


## Overview

The goal is to have an OS that is stable and not constantly changing from year to year for no apparent reason.

This is a streamlined version of HOTDOG that focuses on combining elements of Amiga Workbench 2.0 and NeXTStep, to create a desktop environment for Linux.

HOTDOG was more of an exploration of different GUI's of the past, whereas ANaL makes the decision of which GUI to use moving forward.

HOTDOG was created more as a joke, to make fun of the red-yellow color scheme. Hopefully, ANaL will be taken more seriously as a viable desktop OS.


## How to compile and run

$ sh makeUtils.sh

$ perl build.pl

To run the window manager:

$ ./anal runWindowManager

To run the iPod style interface:

$ ./anal


## Notes

Some of the Perl scripts use the JSON module.


## Why Amiga and NeXTStep

It would be nice to have a GUI that consumes a minimal amount of resources, but is not excessively minimal.

The absolute minimum would be to use 2 colors for the GUI, like the Mac Classic or Atari ST GEM. But perhaps this is too primitive.

Workbench 2.0 uses 4 colors, black, white, gray, and blue. The original NeXTStep uses 4 colors, black, white, the same gray, and another shade of gray. Both have a similar 3D look and feel. NeXTStep in particular has a perfectly usable GUI using only 4 colors.

Windows 3.1, the colorized Mac System 7, and Mac Platinum all use more than 4 colors.

Aqua was extremely slow when it was first released on Mac OS X, while the NeXTStep GUI on which it was based was reasonably fast on older hardware.


## Why Workbench 2.0 Window Frames

Workbench 2.0 has window frames with a border on all sides, that can be repurposed for resizing. NeXTStep doesn't have borders on the sides, so they can't be repurposed for resizing.

Workbench 2.0 has the close button at the upper left corner. NeXTStep has the close button at the upper right corner.


## Why NeXTStep Widgets

NeXTStep widgets look more polished than Workbench 2.0 widgets.


## Why Objective-C

Objective-C is the language used by NeXTStep. C and Objective-C are both extremely stable and do not change from year to year. Mixing C, Objective-C, C++, and Objective-C++ is easy.

Swift is actually a replacement for C++, it is not a viable replacement for Objective-C.

ANaL uses a custom lightweight Objective-C foundation on top of the GCC Objective-C runtime. The style of Objective-C is completely different from the one Apple uses, everything is basically **id**.

Alternatively, it is possible to use an older version of the GNUstep Objective-C runtime that uses the old object struct layout (located in external/libobjc2). This requires everything to be compiled with clang, and allows for the use of Objective-C 2.0 features such as NSFastEnumeration and NSArray/NSDictionary literals, as well as blocks and libdispatch (with the appropriate libs). However, the GCC runtime has better performance, so it is the default.

ANaL does not use Automatic Reference Counting. It causes problems with type-checking during compilation (it is too strict).


## Amiga

There were two separate parts to the Amiga, both of which were ahead of their time at the time they were released.

The first part was the custom chipset. It was designed to take advantage of the fact that RAM was faster than the CPU at the time. Once the CPU became faster than RAM, the design reached a dead-end and became obsolete. I am not so interested in the custom chipset. For games, I generally prefer tiles and sprites, with the exception of Robotron which uses a blitter. And I prefer sound chips over PCM audio for music and sound effects. Samples are good for speech. So in terms of hardware, I am more interested in the X68000 than the Amiga.

The second part was the pre-emptive multitasking operating system. This is the part that is perhaps overlooked when talking about the Amiga, since the focus is usually on games, but I find it to be the more interesting part. There are a number of ideas from the Amiga that I plan to explore in this project, such as AmigaGuide, ARexx ports, data types, and so forth.


## Legal

Copyright (c) 2024 Arthur Choung. All rights reserved.

Email: arthur -at- fmamp.com

Released under the GNU General Public License, version 3.

For details on the license, refer to the LICENSE file.

