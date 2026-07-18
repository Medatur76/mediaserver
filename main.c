#include "sys.h"

int consoleHandler(void *param) {
    char input;
    while (read(0, &input, 1)) {
        if (input == 0x0A) {
            *(int *)param = 0;
            write(1, "safe exit\n", 10);
            break;
        }
    }
    return 0;
}

int connectionHandler(void *param) {
    fd_t client_fd = *(fd_t *)param;
    //parsing
    close(client_fd);
    //error check
    return 0;
}

int main(void) {
    //Apparently both private and shared work here?
    volatile int *running = (int *)malloc(sizeof(int));
    *running = 1;

    //socket server = opensocket(8080);

    fd_t cHandler = thread(consoleHandler, (void *)running);

    while (*running) {
        //fd_t connection = accept(server);
        //error check
        //thread(connectionHandler, (void *)connection);
        //error check
    }

    waitthread(cHandler);

    exit(0);
}