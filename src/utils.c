#include "utils.h"

int min(int a, int b) {
    return a < b ? a : b;
}

int max(int a, int b) {
    return a > b ? a : b;
}

int atoi(String input) {
    size_t i = 0;
    int y = 0;
    while (i < input.len) {
        char x = input.data[i];
        if (x >= '0' && x <= '9') y = y * 10 + x;
        else break;
    }
    return y;
}

int strcmp(String a, String b) {
    return strncmp(a, max(a.len, b.len), b);
}

int strncmp(String a, int n, String b) {
    int out = 0;
    for (int i = 0; i < n; i++) {}
}