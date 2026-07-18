#include "sys.h"

//This file checks every custom function to ensure proper translation

int consoleHandler(void *param) {
    write(1, "child started\n", strlen("child started\n"));
    fd_t file = open("./child.log", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    char input;
    while (read(0, &input, 1)) {
        if (input == 0x0A) {
            *(int *)param = 0;
            write(1, "safe exit\n", 10);
            break;
        }
    }
    write(file, "1\r\nchild exited safely", strlen("0\r\nchild exited safely"));
    close(file);
    write(1, "child exiting\n", 14);
    return 0;
}

int main(void) {
    volatile int *running = (int *)malloc((size_t)0 + sizeof(int));
    *running = 1;

    fd_t cHandler = thread(consoleHandler, (void *)running);

    while (*running) {
    }

    write(1, "parent left loop\n", 17);

    waitthread(cHandler);

    char exitCode = -1;

    fd_t file = open("./child.log", O_RDONLY);

    read(file, &exitCode, 1);

    close(file);

    write(1, "parent exiting\n", 15);

    return exitCode - '0';
}