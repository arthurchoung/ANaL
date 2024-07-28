#include <ctype.h>

#include <alsa/asoundlib.h>

snd_ctl_t *_ctl;
char *_name = "hw:0";

int setup()
{
    snd_ctl_t *ctl;
    int err;
    err = snd_ctl_open(&ctl, _name, SND_CTL_READONLY);
    if (err < 0) {
fprintf(stderr, "Unable to open ctl %s\n", _name);
        exit(1);
    }
    err = snd_ctl_subscribe_events(ctl, 1);
    if (err < 0) {
fprintf(stderr, "Unable to subscribe to ctl %s\n", _name);
        exit(1);
    }
    _ctl = ctl;

    return 1;
}

int read_alsa_event()
{
    snd_ctl_event_t *event;
    snd_ctl_event_alloca(&event);

    if (snd_ctl_read(_ctl, event) < 0) {
        return 0;
    }
    if (snd_ctl_event_get_type(event) != SND_CTL_EVENT_ELEM) {
        return 0;
    }

    unsigned int mask = snd_ctl_event_elem_get_mask(event);
    if (mask & SND_CTL_EVENT_MASK_VALUE) {
        return 1;
    }

    return 0;
}


void print_all()
{
    snd_mixer_t* handle;

    if ((snd_mixer_open(&handle, 0)) < 0) {
        return;
    }
    if ((snd_mixer_attach(handle, _name)) < 0) {
        goto cleanup;
    }
    if ((snd_mixer_selem_register(handle, NULL, NULL)) < 0) {
        goto cleanup;
    }
    int ret = snd_mixer_load(handle);
    if (ret < 0) {
        goto cleanup;
    }

    char *prefix = "";
    for (snd_mixer_elem_t *elem = snd_mixer_first_elem(handle); elem; elem = snd_mixer_elem_next(elem)) {
        if (snd_mixer_elem_get_type(elem) != SND_MIXER_ELEM_SIMPLE) {
            continue;
        }
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
    
        if (snd_mixer_selem_is_enumerated(elem)) {
/*
            int nitems = snd_mixer_selem_get_enum_items(elem);
            char buf[256];
            for (int i=0; i<nitems; i++) {
                if (snd_mixer_selem_get_enum_item_name(elem, i, 255, buf) != 0) {
                    continue;
                }
                printf("i %d '%s'\n", i, buf);
            }
*/
            unsigned int val = 0;
            if (snd_mixer_selem_get_enum_item(elem, 0, &val) == 0) {
                printf("%s%s%d:%d", prefix, namebuf, index, val);
                prefix = " ";
            }
            continue;
        }

        if (snd_mixer_selem_has_playback_volume(elem)) {
            long pmin, pmax;
            long get_vol, set_vol;

            long minv=0, maxv=0;

            snd_mixer_selem_get_playback_volume_range (elem, &minv, &maxv);

            long outvol = 0;
            if(snd_mixer_selem_get_playback_volume(elem, 0, &outvol) == 0) {
                /* make the value bound to 100 */
                outvol -= minv;
                maxv -= minv;
                minv = 0;
                double result = (double)outvol;
                result /= (double)maxv;
                printf("%s%s%dPlaybackVolume:%f", prefix, namebuf, index, result);
                prefix = " ";
            }
        }

        if (snd_mixer_selem_has_playback_switch(elem)) {
            int playback = 0;
            if(snd_mixer_selem_get_playback_switch(elem, 0, &playback) == 0) {
                printf("%s%s%dPlaybackSwitch:%d", prefix, namebuf, index, playback);
                prefix = " ";
            }
        }

        if (snd_mixer_selem_has_capture_volume(elem)) {
            long pmin, pmax;
            long get_vol, set_vol;

            long minv=0, maxv=0;

            snd_mixer_selem_get_capture_volume_range (elem, &minv, &maxv);

            long outvol = 0;
            if(snd_mixer_selem_get_capture_volume(elem, 0, &outvol) == 0) {
                /* make the value bound to 100 */
                outvol -= minv;
                maxv -= minv;
                minv = 0;
                double result = (double)outvol;
                result /= (double)maxv;
                printf("%s%s%dCaptureVolume:%f", prefix, namebuf, index, result);
                prefix = " ";
            }
        }

        if (snd_mixer_selem_has_capture_switch(elem)) {
            int capture = 0;
            if(snd_mixer_selem_get_capture_switch(elem, 0, &capture) == 0) {
                printf("%s%s%dCaptureSwitch:%d", prefix, namebuf, index, capture);
                prefix = " ";
            }
        }
    }

    printf("\n");
    fflush(stdout);



cleanup:
    snd_mixer_close(handle);
}

/*

Usage: anal-alsa-printStatus [card name]

'card name' is 'hw:0' by default

*/

void main(int argc, char **argv)
{
    if (argc >= 2) {
        _name = argv[1];
    }

    if (!setup()) {
        exit(1);
    }

    for(;;) {
        print_all();
        int result = read_alsa_event();
        if (!result) {
fprintf(stderr, "Unable to read alsa event\n");
        }
    }

    exit(0);
}

