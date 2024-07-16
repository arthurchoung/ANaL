#include <ctype.h>
#include <alsa/asoundlib.h>

char *_mix_name = "Master";
char *_card = "hw:0";

void write_alsa_playback_switch(int playback)
{
    snd_mixer_t* handle;
    snd_mixer_elem_t* elem;
    snd_mixer_selem_id_t* sid;

    long pmin, pmax;
    long get_vol, set_vol;

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

    snd_mixer_selem_id_alloca(&sid);

    //sets simple-mixer index and name
    snd_mixer_selem_id_set_index(sid, 0);
    snd_mixer_selem_id_set_name(sid, _mix_name);

    elem = snd_mixer_find_selem(handle, sid);
    if (!elem) {
        snd_mixer_close(handle);
        return;
    }

    if (snd_mixer_selem_has_playback_switch(elem)) {
        snd_mixer_selem_set_playback_switch_all(elem, playback);
    }

    snd_mixer_close(handle);
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "To mute: %s 1 [card name] [mixer name]\n", argv[0]);
        fprintf(stderr, "To unmute: %s 0 [card name] [mixer name]\n", argv[0]);
        fprintf(stderr, "'card name' is 'hw:0' by default\n");
        fprintf(stderr, "'mixer name' is 'Master' by default\n");
        exit(0);
    }
    if (argc >= 3) {
        _card = argv[2];
    }
    if (argc >= 4) {
        _mix_name = argv[3];
    }

    switch (argv[1][0]) {
        case '1':
            write_alsa_playback_switch(0);
            break;
        case '0':
            write_alsa_playback_switch(1);
            break;
    }

}

