#include "utils.h"

int min(int a, int b) {
    return a < b ? a : b;
}

int max(int a, int b) {
    return a > b ? a : b;
}

/**
 * This is a horrible strcmp and will be changed later but for now it works so yeah
 * This function returns the difference between the first unequal characters in the string pair
 * If a ends before b, the char at the same point as the null terminator in a is returned as its int representation
 * If b ends before a, 0 is returned
 * This function expects that either:
 * - The strings are not equal
 * or
 * - At least one of the strings is null terminated
*/
int strcmp(const char *a, const char *b) {
    while (*a && *b && (*a == *b)) {
        a++;
        b++;
    }
    return *b;
}

//TODO add error checking
int writeHex(socket_t *client, int a) {
    size_t size = 1;
    char *out = malloc(size);
    do {
        int x = a % 16;
        out[size - 1] = x + (x > 9 ? 'W' : '0');
        out = realloc(out, size++, size);
        a = (a - (a % 16)) / 16;
    } while (a > 0);
    for (int i = size - 2; i >= 0; i--) writeSocket(client, out + i, 1);
    writeSocket(client, "\r\n", 2);
    return 0;
}