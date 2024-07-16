#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <linux/netlink.h>

int main()
{
    setbuf(stdout, NULL);

    struct sockaddr_nl nl;
    char buf[8192];

    memset(&nl,0,sizeof(struct sockaddr_nl));
    nl.nl_family = AF_NETLINK;
    nl.nl_pid = getpid();
    nl.nl_groups = -1;
    int fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);
    if (fd < 0) {
        fprintf(stderr, "Unable to create socket\n");
        exit(1);
    }

    if (bind(fd, (void *)&nl, sizeof(struct sockaddr_nl)) != 0) {
        fprintf(stderr, "Unable to bind socket\n");
        exit(1);
    }

    for(;;) {
        int len = recv(fd, buf, sizeof(buf), 0);
        if (len < 0) {
            fprintf(stderr, "Error reading from socket: %s", strerror(errno));
            continue;
        }
        int i = 0;
        int line = 0;
        while (i < len) {
            char *p = buf+i;
            if (line == 0) {
                if (!strncmp(p, "libudev", 7)) {
                    break;
                }
            } else {
                if (!strncmp(p, "DEVTYPE=disk", 12)) {
                    printf("%s\n", p);
                    break;
                } else if (!strncmp(p, "DEVTYPE=partition", 17)) {
                    printf("%s\n", p);
                    break;
                } else if (!strncmp(p, "ACTION=bind", 11)) {
                    sleep(1); // FIXME: there should be a better way
                    printf("%s\n", p);
                    break;
                }
            }
//            printf("%d: %s\n", line, p);
            i += strlen(buf+i)+1;
            line++;
        }
    }

    return 0;
}
