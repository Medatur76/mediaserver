#include "sys.h"

int consoleMonitor(void *param) {
    char input;
    while (read(0, &input, 1)) {
        if (input == 0x0A) {
            *(int *)param = 0;
            break;
        }
    }
    return 0;
}

int clientHandler(void *param) {
    fd_t client = *(fd_t *)param;
    close(client);
    return 0;
}

int main(void) {
    socket_t server = opensocket(8080);
    //error check

    volatile int *running = (int *)malloc(sizeof(int));
    //error check
    *running = 1;

    fd_t monitor = thread(consoleMonitor, (void *)running);

    while (*running) {
        fd_t sock = accept(&server);
        //error check
        //thread(clientHandler, &sock);
        close(sock);
    }

    waitthread(monitor);
    close(server.socketFd);
    return 0;
}