#include <ctype.h>
#include <alsa/asoundlib.h>

char *_card = "hw:0";

void write_alsa(int nth, char *str)
{
    snd_mixer_t* handle;

    if ((snd_mixer_open(&handle, 0)) < 0) {
        return;
    }
    if ((snd_mixer_attach(handle, _card)) < 0) {
        goto cleanup;
    }
    if ((snd_mixer_selem_register(handle, NULL, NULL)) < 0) {
        goto cleanup;
    }
    int ret = snd_mixer_load(handle);
    if (ret < 0) {
        goto cleanup;
    }

    snd_mixer_elem_t *elem = snd_mixer_first_elem(handle);
    for (int i=0; i<nth; i++) {
        if (!elem) {
            break;
        }
        elem = snd_mixer_elem_next(elem);
    }
    if (!elem) {
        goto cleanup;
    }

    char *p;
    if (p = strstr(str, "playbackVolume:")) {
        p += 15;
        double volume = strtod(p, NULL);
        if ((volume >= 0.0) && (volume <= 1.0)) {
            long minv, maxv;

            snd_mixer_selem_get_playback_volume_range (elem, &minv, &maxv);

            long val = minv + (double)(maxv-minv)*volume;
            snd_mixer_selem_set_playback_volume_all(elem, val);
        }
    } else if (p = strstr(str, "playbackSwitch:")) {
        p += 15;
        int val = strtol(p, NULL, 10);
        snd_mixer_selem_set_playback_switch_all(elem, val);
    } else if (p = strstr(str, "enum:")) {
        p += 5;
        int val = strtol(p, NULL, 10);
        snd_mixer_selem_set_enum_item(elem, 0, val);
    } else if (p = strstr(str, "captureVolume:")) {
        p += 14;
        double volume = strtod(p, NULL);
        if ((volume >= 0.0) && (volume <= 1.0)) {
            long minv, maxv;

            snd_mixer_selem_get_capture_volume_range (elem, &minv, &maxv);

            long val = minv + (double)(maxv-minv)*volume;
            snd_mixer_selem_set_capture_volume_all(elem, val);
        }
    } else if (p = strstr(str, "captureSwitch:")) {
        p += 14;
        int val = strtol(p, NULL, 10);
        snd_mixer_selem_set_capture_switch_all(elem, val);
    }

cleanup:
    snd_mixer_close(handle);
}

/*

Usage: anal-setALSAVolume [card name]

Reads from stdin

'card name' is 'hw:0' by default

*/

int main(int argc, char **argv)
{
    if (argc >= 2) {
        _card = argv[1];
    }

    for(;;) {
        char buf[256];
        if (!fgets(buf, 256, stdin)) {
            break;
        }
        char *p = strstr(buf, "nth:");
        if (p) {
            p += 4;
            int nth = strtol(p, NULL, 10);
            write_alsa(nth, buf);
        }
    }
    exit(0);
}

