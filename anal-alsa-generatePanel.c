#include <ctype.h>

#include <alsa/asoundlib.h>

char *_name = "hw:0";
char *_displayName = 0;

void print_all()
{
    snd_mixer_t* handle;

    if ((snd_mixer_open(&handle, 0)) < 0) {
        printf("panelText:'snd_mixer_open failed'\n");
        return;
    }
    if ((snd_mixer_attach(handle, _name)) < 0) {
        printf("panelText:'snd_mixer_attach failed'\n");
        goto cleanup;
    }
    if ((snd_mixer_selem_register(handle, NULL, NULL)) < 0) {
        printf("panelText:'snd_mixer_selem_register failed'\n");
        goto cleanup;
    }
    int ret = snd_mixer_load(handle);
    if (ret < 0) {
        printf("panelText:'snd_mixer_load failed'\n");
        goto cleanup;
    }

    int nth = -1;
    for (snd_mixer_elem_t *elem = snd_mixer_first_elem(handle); elem; elem = snd_mixer_elem_next(elem)) {
        if (snd_mixer_elem_get_type(elem) != SND_MIXER_ELEM_SIMPLE) {
            continue;
        }
        nth++;
        int index = snd_mixer_selem_get_index(elem);
        char *elem_name = (char *) snd_mixer_selem_get_name(elem);

        char namebuf[256];
        if (elem_name) {
            char *p = elem_name;
            char *q = namebuf;
            char *end = &namebuf[255];
            for (;;) {
                if (!*p) {
                    break;
                }
                if (q == end) {
                    break;
                }
                if (isalnum(*p)) {
                    *q = *p;
                    q++;
                }
                p++;
            }
            *q = 0;
        } else {
            strcpy(namebuf, "none");
        }

        char displaynamebuf[256];
        if (elem_name) {
            char *p = elem_name;
            char *q = displaynamebuf;
            char *end = &displaynamebuf[255];
            for (;;) {
                if (!*p) {
                    break;
                }
                if (q == end) {
                    break;
                }
                if (isprint(*p)) {
                    if (*p != '\'') {
                        *q = *p;
                        q++;
                    }
                }
                p++;
            }
            *q = 0;
        } else {
            strcpy(displaynamebuf, "none");
        }
    
        if (snd_mixer_selem_is_enumerated(elem)) {
            printf("panelText:''\n");
            printf("panelText:'%s:'\n", displaynamebuf);
            int nitems = snd_mixer_selem_get_enum_items(elem);
            char buf[256];
            for (int i=0; i<nitems; i++) {
                if (snd_mixer_selem_get_enum_item_name(elem, i, 255, buf) != 0) {
                    continue;
                }
                char *prefix;
                if (i == 0) {
                    prefix = "Top";
                } else if (i == nitems-1) {
                    prefix = "Bottom";
                } else {
                    prefix = "Middle";
                }
                printf("panel%sButton:'%s' checkmark:(lastLine|if:[%s%d|isEqual:%d] then:[1] else:[0]) message:[outputProcess|writeLine:'nth:%d enum:%d']\n", prefix, buf, namebuf, index, i, nth, i);
            }
            continue;
        }

        int hasPlaybackVolume = 0;
        int hasPlaybackSwitch = 0;
        int hasCaptureVolume = 0;
        int hasCaptureSwitch = 0;
        if (snd_mixer_selem_has_playback_volume(elem)) {
            hasPlaybackVolume = 1;
        }
        if (snd_mixer_selem_has_playback_switch(elem)) {
            hasPlaybackSwitch = 1;
        }
        if (snd_mixer_selem_has_capture_volume(elem)) {
            hasCaptureVolume = 1;
        }
        if (snd_mixer_selem_has_capture_switch(elem)) {
            hasCaptureSwitch = 1;
        }

        if (hasPlaybackVolume || hasPlaybackSwitch) {
            printf("panelText:''\n");
            if (index) {
                printf("panelText:'%s-%d Playback:'\n", displaynamebuf, index);
            } else {
                printf("panelText:'%s Playback:'\n", displaynamebuf);
            }

            if (hasPlaybackVolume && hasPlaybackSwitch) {
                printf("panelTopSlider:'%s%dPlaybackVolume' message:[outputProcess|writeLine:(str:'nth:%d playbackVolume:#{buttonDownKnobPct}')]\n", namebuf, index, nth);
                printf("panelMiddleButton:'On' checkmark:(lastLine|if:[%s%dPlaybackSwitch] then:[1] else:[0]) message:[outputProcess|writeLine:'nth:%d playbackSwitch:1']\n", namebuf, index, nth);
                printf("panelBottomButton:'Mute' checkmark:(lastLine|if:[%s%dPlaybackSwitch] then:[0] else:[1]) message:[outputProcess|writeLine:'nth:%d playbackSwitch:0']\n", namebuf, index, nth);
            } else if (hasPlaybackVolume) {
                printf("panelSingleSlider:'%s%dPlaybackVolume' message:[outputProcess|writeLine:(str:'nth:%d playbackVolume:#{buttonDownKnobPct}')]\n", namebuf, index, nth);
            } else if (hasPlaybackSwitch) {
                printf("panelTopButton:'On' checkmark:(lastLine|if:[%s%dPlaybackSwitch] then:[1] else:[0]) message:[outputProcess|writeLine:'nth:%d playbackSwitch:1']\n", namebuf, index, nth);
                printf("panelBottomButton:'Mute' checkmark:(lastLine|if:[%s%dPlaybackSwitch] then:[0] else:[1]) message:[outputProcess|writeLine:'nth:%d playbackSwitch:0']\n", namebuf, index, nth);
            }
        }

        if (hasCaptureVolume || hasCaptureSwitch) {
            printf("panelText:''\n");
            if (index || !strcmp(displaynamebuf, "Capture")) {
                printf("panelText:'%s-%d Capture:'\n", displaynamebuf, index);
            } else {
                printf("panelText:'%s Capture:'\n", displaynamebuf);
            }
            if (hasCaptureVolume && hasCaptureSwitch) {
                printf("panelTopSlider:'%s%dCaptureVolume' message:[outputProcess|writeLine:(str:'nth:%d captureVolume:#{buttonDownKnobPct}')]\n", namebuf, index, nth);
                printf("panelMiddleButton:'On' checkmark:(lastLine|if:[%s%dCaptureSwitch] then:[1] else:[0]) message:[outputProcess|writeLine:'nth:%d captureSwitch:1']\n", namebuf, index, nth);
                printf("panelBottomButton:'Mute' checkmark:(lastLine|if:[%s%dCaptureSwitch] then:[0] else:[1]) message:[outputProcess|writeLine:'nth:%d captureSwitch:0']\n", namebuf, index, nth);
            } else if (hasCaptureVolume) {
                printf("panelSingleSlider:'%s%dCaptureVolume' message:[outputProcess|writeLine:(str:'nth:%d captureVolume:#{buttonDownKnobPct}')]\n", namebuf, index, nth);
            } else if (hasCaptureSwitch) {
                printf("panelTopButton:'On' checkmark:(lastLine|if:[%s%dCaptureSwitch] then:[1] else:[0]) message:[outputProcess|writeLine:'nth:%d captureSwitch:0']\n", namebuf, index, nth);
                printf("panelBottomButton:'Mute' toggle:(lastLine|if:[%s%dCaptureSwitch] then:[0] else:[1]) message:[outputProcess|writeLine:'nth:%d captureSwitch:0']\n", namebuf, index, nth);
            }
        }
    }

cleanup:
    snd_mixer_close(handle);
}

/*

Usage: anal-printALSAStatus [card name] [mixer name]

'card name' is 'hw:0' by default
'mixer name' is 'Master' by default

*/

static void stripchars(char *str)
{
    char *p = str;
    char *q = str;
    while (*p) {
        if (*p == '\'') {
        } else if (!isprint(*p)) {
        } else {
            *q = *p;
            q++;
        }
        p++;
    }
    *q = 0;
}

void main(int argc, char **argv)
{
    if (argc >= 2) {
        _name = argv[1];
    }

    if (argc >= 3) {
        _displayName = argv[2];
        stripchars(_displayName);
    }

    printf("panelStripedBackground\n");
    if (_displayName) {
        printf("panelText:'%s' color:'white' backgroundColor:'black'\n", _displayName);
    }
    printf("panelText:'%s' color:'white' backgroundColor:'black'\n", _name);
    printf("panelLine\n");

    print_all();

    exit(0);
}

