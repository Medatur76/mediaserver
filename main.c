#include "sys.h"

int consoleHandler(void *param) {
    write(1, "child started\n", 14);
    char input;
    while (read(0, &input, 1)) {
        if (input == 0x0A) {
            *(int *)param = 0;
            write(1, "safe exit\n", 10);
            break;
        }
    }
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

    write(1, "parent exiting\n", 15);

    return 0;
}