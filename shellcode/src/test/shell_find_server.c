#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

#include "hexdump.h"

#define BACKLOG 5

void
usage(const char *name)
{
    fprintf(stderr, "Usage: %s [-dhv][-p port] [host]\n", name);
}

int
main(int argc, char *argv[])
{
    int port = 4444;
    int c, s;
    int debug = 0, verbose = 0;
    struct sockaddr_in sin;
    struct hostent *he;

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

    if (argv[optind] == NULL)
        argv[optind] = "0.0.0.0";

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

    if (bind(s, (struct sockaddr *)&sin, sizeof(sin)) == -1) {
        perror("bind");
        exit(EXIT_FAILURE);
    }

    if (listen(s, BACKLOG) == -1) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    if (debug || verbose)
        fprintf(stderr, "Listening on %s:%d\n", argv[optind], port);

    for (;;) {
        int tmp;
        struct sockaddr_in sin;
        socklen_t sin_len = sizeof(sin);

        if((tmp = accept(s, (struct sockaddr *)&sin, &sin_len)) == -1) {
            perror("accept");
            exit(EXIT_FAILURE);
        }

        if (debug || verbose)
            fprintf(stderr, "Accepted connection from %s:%d\n", inet_ntoa(sin.sin_addr), ntohs(sin.sin_port));

        if (!fork()) {
            int count;
            char *buf;
            size_t pagesize = sysconf(_SC_PAGESIZE);

            if ((buf = valloc(pagesize)) == NULL) {
                perror("valloc");
                exit(EXIT_FAILURE);
            }

            if (mprotect(buf, pagesize, PROT_READ|PROT_WRITE|PROT_EXEC) == -1) {
                perror("mprotect");
                exit(EXIT_FAILURE);
            }

            count = recv(tmp, buf, pagesize, 0);

            if (debug)
                hexdump(stderr, buf, count);

            if (debug || verbose)
                fprintf(stderr, "%d bytes received\n", count);

            sleep(2);

#if defined(_AIX) || (defined(__linux__) && defined(__powerpc64__))
            {
                // Use a fake function descriptor.
                unsigned long fdesc[2] = {(unsigned long)buf, 0};
                (*(void (*)())fdesc)();
            }
#else
            (*(void (*)())buf)();
#endif

            free(buf);

            exit(EXIT_SUCCESS);
        }

        close(tmp);
    }

    exit(EXIT_SUCCESS);
}
