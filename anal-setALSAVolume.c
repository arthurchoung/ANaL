#include <ctype.h>
#include <alsa/asoundlib.h>

char *_mix_name = "Master";
char *_card = "hw:0";

void write_alsa_volume(double volume)
{
    snd_mixer_t* handle;
    snd_mixer_elem_t* elem;
    snd_mixer_selem_id_t* sid;

    long pmin, pmax;
    long get_vol, set_vol;

    snd_mixer_selem_id_alloca(&sid);

    //sets simple-mixer index and name
    snd_mixer_selem_id_set_index(sid, 0);
    snd_mixer_selem_id_set_name(sid, _mix_name);

    if ((snd_mixer_open(&handle, 0)) < 0) {
        return;
    }
    if ((snd_mixer_attach(handle, _card)) < 0) {
        snd_mixer_close(handle);
        return;
    }
    if ((snd_mixer_selem_register(handle, NULL, NULL)) < 0) {
        snd_mixer_close(handle);
        return;
    }
    int ret = snd_mixer_load(handle);
    if (ret < 0) {
        snd_mixer_close(handle);
        return;
    }
    elem = snd_mixer_find_selem(handle, sid);
    if (!elem) {
        snd_mixer_close(handle);
        return;
    }

    long minv, maxv;

    snd_mixer_selem_get_playback_volume_range (elem, &minv, &maxv);

    long val = minv + (double)(maxv-minv)*volume;
    if(snd_mixer_selem_set_playback_volume_all(elem, val) < 0) {
        snd_mixer_close(handle);
        return;
    }

    snd_mixer_close(handle);
}

/*

Usage: anal-setALSAVolume [card name] [mixer name]

Reads a line from stdin
If the line is a floating point value, sets the volume to that number

'card name' is 'hw:0' by default
'mixer name' is 'Master' by default

*/

int main(int argc, char **argv)
{
/*
    if (argc != 1) {
        if (isdigit(argv[1][0]) || (argv[1][0] == '.')) {
            double vol = strtod(argv[1], NULL);
            if ((vol >= 0.0) && (vol <= 1.0)) {
                write_alsa_volume(vol);
                exit(0);
            }
        }
        fprintf(stderr, "Usage: %s [number between 0.0 and 1.0]\n", argv[0]);
        fprintf(stderr, "If there are no arguments, then it will read from stdin\n");
        exit(1);
    }
*/
    if (argc >= 2) {
        _card = argv[1];
    }
    if (argc >= 3) {
        _mix_name = argv[2];
    }

    for(;;) {
        char buf[256];
        if (!fgets(buf, 256, stdin)) {
            break;
        }
        if (isdigit(buf[0]) || (buf[0] == '.')) {
            double vol = strtod(buf, NULL);
            if ((vol >= 0.0) && (vol <= 1.0)) {
                write_alsa_volume(vol);
            }
        }
    }
    exit(0);
}

