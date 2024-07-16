#include <fcntl.h>
#include <poll.h>
#include <stdlib.h>
#include <stdio.h>

int main()
{
    setbuf(stdout, NULL);

    int mfd = open("/proc/mounts", O_RDONLY, 0);
    if (mfd < 0) {
        fprintf(stderr, "Unable to open /proc/mounts\n");
        exit(1);
    }

    for(;;) {
        struct pollfd pfd;
        pfd.fd = mfd;
        pfd.events = POLLERR | POLLPRI;
        pfd.revents = 0;

        int rv = poll(&pfd, 1, 60*1000);
        if (rv >= 0) {
            if (pfd.revents & POLLERR) {
                fprintf(stdout, "/proc/mounts changed.\n");
            }
        }
    }

    return 0;
}

