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

static int ANAL_argc = 0;
static char **ANAL_argv = 0;

static void signal_handler(int num)
{
NSLog(@"signal_handler %d", num);
}

int main(int argc, char **argv)
{
    ANAL_argc = argc;
    ANAL_argv = argv;

    if (signal(SIGPIPE, signal_handler) == SIG_ERR) {
NSLog(@"unable to set signal handler for SIGPIPE");
    }

#ifdef BUILD_FOR_ANDROID
    extern void ANAL_initialize_stdout(FILE *);
    extern void ANAL_initialize(FILE *);
    ANAL_initialize_stdout(stdout);
    ANAL_initialize(stderr);
#else
    extern void ANAL_initialize_stdout(FILE *);
    extern void ANAL_initialize(FILE *);
    ANAL_initialize_stdout(stdout);
    if ((argc >= 2) && !strcmp(argv[1], "dialog")) {
        FILE *fp = fopen("/dev/null", "w");
        if (!fp) {
            fprintf(stderr, "unable to open /dev/null\n");
            exit(1);
        }
        ANAL_initialize(fp);
    } else {
        ANAL_initialize(stderr);
    }
#endif



    id pool = [[NSAutoreleasePool alloc] init];

        id analDir = [Definitions analDir];

        /* If argv[0] contains a slash, then add the directory that the
           executable resides in to the PATH */
        if ((argc > 0) && strchr(argv[0], '/')) {
            char *pathcstr = getenv("PATH");
            id path = nil;
            if (pathcstr && strlen(pathcstr)) {
                path = nsfmt(@"%@:%s", analDir, pathcstr);
            } else {
                path = analDir;
            }
            if (setenv("PATH", [path UTF8String], 1) != 0) {
NSLog(@"Unable to set PATH");
            }
        }

        if (setenv("SUDO_ASKPASS", [[Definitions analDir:@"anal-getPassword.pl"] UTF8String], 1) != 0) {
NSLog(@"Unable to setenv SUDO_ASKPASS");
        }

        if (argc >= 2) {
            id args = nsarr();
            for (int i=2; i<argc; i++) {
                [args addObject:nsfmt(@"%s", argv[i])];
            }
            id methodName = nsfmt(@"%s", argv[1]);
            id result = nil;
            if ([methodName containsString:@":"]) {
                result = [Definitions callMethodName:methodName args:args];
            } else {
                result = [Definitions callMethodName:methodName args:nil];
            }
            if (!result) {
                exit(0);
            }
            if ([result class] == [Definitions class]) {
                exit(0);
            }
            if ([result respondsToSelector:@selector(drawInBitmap:rect:)]
                || [result respondsToSelector:@selector(drawInBitmap:rect:context:)]
                || [result respondsToSelector:@selector(pixelBytesRGBA8888)]
                || [result respondsToSelector:@selector(pixelBytesBGR565)]
                )
            {
                [Definitions runWindowManagerForObject:result];
                [[Definitions navigationStack] setValue:nil forKey:@"context"];
                exit(0);
            }
            if ([result isArray]) {
//                NSOut(@"array with %d elements\n", [result count]);
                for (int i=0; i<[result count]; i++) {
                    id elt = [result nth:i];
                    NSOut(@"%@\n", elt);
                }
            } else {
NSOut(@"%@", result);
            }

            exit(0);
        }

        if (argc == 1) {
            id obj = nil;
            if ([Definitions respondsToSelector:@selector(Main)]) {
                obj = [Definitions Main];
            } else {
                obj = [Definitions Dir];
            }
            [Definitions runWindowManagerForObject:obj];
            [[Definitions navigationStack] setValue:nil forKey:@"context"];
        }

	[pool drain];

    return 0;
}

@implementation Definitions(mfeklwfmklsdmklfmskldfmk)
+ (void)open
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    if (argc < 2) {
        return;
    }

    if (argc > 2) {
        id filePath = nscstr(argv[2]);
        if ([filePath isDirectory]) {
            chdir(argv[2]);
        }
    }
    id obj = [Definitions Dir];
    [Definitions runWindowManagerForObject:obj];
    [[Definitions navigationStack] setValue:nil forKey:@"context"];
    exit(0);
}
+ (void)show
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    if (argc < 3) {
        return;
    }

    for (int i=3; i<argc; i++) {
        [nsfmt(@"%s", argv[i]) setAsValueForKey:nsfmt(@"arg%d", i-3)];
    }
    id message = nsfmt(@"%s", argv[2]);
    id object = [[Definitions globalContext] evaluateMessage:message];
    if (object) {
        [Definitions runWindowManagerForObject:object];
    }
    exit(0);
}
+ (void)alert
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    id str = nil;
    if (argc > 2) {
        for (int i=2; i<argc; i++) {
            if (!str) {
                str = nsfmt(@"%s", argv[i]);
            } else {
                str = nsfmt(@"%@\n%s", str, argv[i]);
            }
        }
    } else {
        id data = [Definitions dataFromStandardInput];
        str = [data asString];
    }
    if ([str length]) {
        id obj = [@"Alert" asInstance];
        [obj setValue:str forKey:@"text"];
        [obj setValue:@"OK" forKey:@"okText"];
        [Definitions runWindowManagerForObject:obj];
    }
    exit(0);
}
+ (void)confirm
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    id okText = @"OK";
    id cancelText = @"Cancel";
    if (argc > 2) {
        okText = nsfmt(@"%s", argv[2]);
    }
    if (argc > 3) {
        cancelText = nsfmt(@"%s", argv[3]);
    }
    id text = nil;
    if (argc > 4) {
        for (int i=4; i<argc; i++) {
            if (!text) {
                text = nsfmt(@"%s", argv[i]);
            } else {
                text = nsfmt(@"%@\n%s", text, argv[i]);
            }
        }
    } else {
        id data = [Definitions dataFromStandardInput];
        text = [data asString];
    }
    if ([text length]) {
        id obj = [@"Alert" asInstance];
        [obj setValue:text forKey:@"text"];
        [obj setValue:okText forKey:@"okText"];
        [obj setValue:cancelText forKey:@"cancelText"];
        [Definitions runWindowManagerForObject:obj];
    }
    exit(0);
}
+ (void)checklist
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    id text = @"Checklist";
    id okText = @"OK";
    id cancelText = @"Cancel";
    if (argc > 2) {
        okText = (argv[2]) ? nsfmt(@"%s", argv[2]) : nil;
    }
    if (argc > 3) {
        cancelText = (argv[3]) ? nsfmt(@"%s", argv[3]) : nil;
    }
    if (argc > 4) {
        text = nsfmt(@"%s", argv[4]);
    }
    id arr = nsarr();
    if (argc > 5) {
        for (int i=5; i+2<argc; i+=3) {
            id dict = nsdict();
            [dict setValue:nsfmt(@"%s", argv[i]) forKey:@"tag"];
            [dict setValue:nsfmt(@"%s", argv[i+1]) forKey:@"checked"];
            [dict setValue:nsfmt(@"%s", argv[i+2]) forKey:@"text"];
            [arr addObject:dict];
        }
    }
    id obj = [@"Checklist" asInstance];
    [obj setValue:@"1" forKey:@"dialogMode"];
    [obj setValue:text forKey:@"text"];
    [obj setValue:arr forKey:@"array"];
    [obj setValue:okText forKey:@"okText"];
    [obj setValue:cancelText forKey:@"cancelText"];
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        if ([elt intValueForKey:@"checked"]) {
            [obj setChecked:YES forIndex:i];
        }
    }
    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
+ (void)radio
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    id text = @"Radio";
    id okText = @"OK";
    id cancelText = @"Cancel";
    if (argc > 2) {
        okText = (argv[2]) ? nsfmt(@"%s", argv[2]) : nil;
    }
    if (argc > 3) {
        cancelText = (argv[3]) ? nsfmt(@"%s", argv[3]) : nil;
    }
    if (argc > 4) {
        text = nsfmt(@"%s", argv[4]);
    }
    id arr = nsarr();
    if (argc > 5) {
        for (int i=5; i+2<argc; i+=3) {
            id dict = nsdict();
            [dict setValue:nsfmt(@"%s", argv[i]) forKey:@"tag"];
            [dict setValue:nsfmt(@"%s", argv[i+1]) forKey:@"selected"];
            [dict setValue:nsfmt(@"%s", argv[i+2]) forKey:@"text"];
            [arr addObject:dict];
        }
    }
    id obj = [@"Radio" asInstance];
    [obj setValue:@"1" forKey:@"dialogMode"];
    [obj setValue:text forKey:@"text"];
    [obj setValue:arr forKey:@"array"];
    [obj setValue:okText forKey:@"okText"];
    [obj setValue:cancelText forKey:@"cancelText"];
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        if ([elt intValueForKey:@"selected"]) {
            [obj setValue:nsfmt(@"%d", i) forKey:@"selectedIndex"];
            break;
        }
    }
    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
+ (void)input
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    id okText = @"OK";
    id cancelText = @"Cancel";
    id text = @"";
    id fieldText = @"";
    id initialText = nil;

    if (argc > 2) {
        okText = (argv[2]) ? nsfmt(@"%s", argv[2]) : nil;
    }
    if (argc > 3) {
        cancelText = (argv[3]) ? nsfmt(@"%s", argv[3]) : nil;
    }
    if (argc > 4) {
        text = nsfmt(@"%s", argv[4]);
    }
    if (argc > 5) {
        fieldText = nsfmt(@"%s", argv[5]);
    }
    if (argc > 6) {
        initialText = nsfmt(@"%s", argv[6]);
    }

    id obj = [@"TextFields" asInstance];
    [obj setValue:@"1" forKey:@"dialogMode"];

    [obj setValue:text forKey:@"text"];
    [obj setValue:okText forKey:@"okText"];
    [obj setValue:cancelText forKey:@"cancelText"];

    id fields = nsarr();
    [fields addObject:fieldText];
    [obj setValue:fields forKey:@"fields"];

    if (initialText) {
        id buffers = nsarr();
        [buffers addObject:initialText];
        [obj setValue:buffers forKey:@"buffers"];
    }

    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
+ (void)password
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    id okText = @"OK";
    id cancelText = @"Cancel";
    id text = @"";
    id fieldText = @"";

    if (argc > 2) {
        okText = (argv[2]) ? nsfmt(@"%s", argv[2]) : nil;
    }
    if (argc > 3) {
        cancelText = (argv[3]) ? nsfmt(@"%s", argv[3]) : nil;
    }
    if (argc > 4) {
        text = nsfmt(@"%s", argv[4]);
    }
    if (argc > 5) {
        fieldText = nsfmt(@"%s", argv[5]);
    }

    id obj = [@"TextFields" asInstance];
    [obj setValue:@"1" forKey:@"dialogMode"];

    [obj setValue:@"1" forKey:@"hidden"];
    [obj setValue:text forKey:@"text"];
    [obj setValue:okText forKey:@"okText"];
    [obj setValue:cancelText forKey:@"cancelText"];

    id fields = nsarr();
    [fields addObject:fieldText];
    [obj setValue:fields forKey:@"fields"];

    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
+ (void)prgbox
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    id cmd = nsarr();
    for (int i=2; i<argc; i++) {
        [cmd addObject:nsfmt(@"%s", argv[i])];
    }
    id process = [cmd runCommandAndReturnProcessWithError];
    if (!process) {
NSLog(@"unable to run command %@", cmd);
        exit(1);
    }
    id obj = [@"PrgBox" asInstance];
    [obj setValue:cmd forKey:@"command"];
    [obj setValue:process forKey:@"process"];
    [obj setValue:@"OK" forKey:@"okText"];
    [Definitions runWindowManagerForObject:obj];
    exit(0);
}
+ (void)dialog
{
    int argc = ANAL_argc;
    char **argv = ANAL_argv;

    if (argc > 2) {
        char *classPrefix = "";
        [Definitions dialog:classPrefix :argc-2 :&argv[2]];
    }
    exit(-1);
}
+ (void)about
{
    id cmd = nsarr();
    [cmd addObject:@"anal-about-text.pl"];
    id text = [[cmd runCommandAndReturnOutput] asString];
    cmd = nsarr();
    [cmd addObject:@"anal"];
    [cmd addObject:@"confirm"];
    [cmd addObject:@"OK"];
    [cmd addObject:@"More Info..."];
    [cmd addObject:text];
    id output = [[[cmd runCommandAndReturnOutput] asString] chomp];
    if ([output isEqual:@"More Info..."]) {
        cmd = nsarr();
        [cmd addObject:@"anal-about-moreText.pl"];
        id text = [[cmd runCommandAndReturnOutput] asString];
        cmd = nsarr();
        [cmd addObject:@"anal"];
        [cmd addObject:@"alert"];
        [cmd addObject:text];
        [cmd runCommandAndReturnOutput];
    }
}
@end

