#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int
hexdump(FILE *stream, const char *buf, size_t size)
{
    size_t i, j;

    for (i = 0; i < size; i += 16) {
        fprintf(stream, "%08zx  ", i);

        for (j = 0; j < 16; j++) {
            if (j == 8)
                fprintf(stream, " ");

            if (i + j >= size)
                fprintf(stream, "   ");
            else
                fprintf(stream, "%02hhx ", buf[i + j]);
        }

        fprintf(stream, " ");

        for (j = 0; j < 16; j++) {
            if (i + j >= size)
                fprintf(stream, " ");
            else {
                if (isprint(buf[i + j]) && !isspace(buf[i + j]))
                    fprintf(stream, "%c", buf[i + j]);
                else
                    fprintf(stream, ".");
            }
        }

        fprintf(stream, "\n");
    }

    return size;
}
