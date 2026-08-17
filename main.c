#include "sys.h"

int clientHandler(void *param) {
    socket_t *client = (socket_t *)param;

    writeFd(1, "Connection from: ", 17);
    for (int i = 0; i < 4; i++) {
        int n = (client->address->ip >> (i * 8)) & 0xFF;
        char buf[3];
        int len = 0;
        do {
            buf[len++] = (n % 10) + '0';
            n /= 10;
        } while (n > 0);
        for (int j = len - 1; j >= 0; j--) {
            writeFd(1, &buf[j], 1);
        }
        if (i < 3) {
            writeFd(1, ".", 1);
        } else {
            writeFd(1, "\n", 1);
        }
    }

    writeSocket(client, "HTTP/1.1 404 Not Found\r\n\r\n404", 29);

    closeSocket(client);

    writeFd(1, "Closing connection\n", 19);
    return 0;
}

int consoleWatcher(void *param) {
    char input;
    while (readFd(0, &input, 1)) {
        if (input == 0x0A) {
            *(__UINT8_TYPE__ *)param = 0;
            break;
        }
    }
    writeFd(1, "Exit command registered\n", 24);
    return 0;
}

int main(void) {
    socket_t server = opensocket(8081);
    writeFd(1, "Server open\n", 12);

    volatile __UINT8_TYPE__ *running = (__UINT8_TYPE__ *)malloc(sizeof(__UINT8_TYPE__));
    *running = 1;
    fd_t watcher = thread(consoleWatcher, (void *)running);

    writeFd(1, "Listening\n", 10);
    while (*running) {
        socket_t client = acceptConnection(&server);
        
        thread(clientHandler, (void *)&client);
    }

    writeFd(1, "Exiting\n", 8);

    waitthread(watcher);
    closeSocket(&server);

    return 0;
}