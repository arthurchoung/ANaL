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


void print_first_element()
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
    
        if (snd_mixer_selem_has_playback_volume(elem)) {
            printf("%s", namebuf);
            fflush(stdout);
            break;
        }

    }

cleanup:
    snd_mixer_close(handle);
}

/*

Usage: anal-printALSAStatus [card name]

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

    print_first_element();

    exit(0);
}

