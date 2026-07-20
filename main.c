#include "sys.h"
#include "utils.h"
#include "sub_systems.h"

#define writeBufSize 16777216 //16 MB

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
    char *buffer = malloc(sizeof(char) * 3);
    read(client, buffer, 3);
    if (strcmp(buffer, "GET")) {
        write(client, "HTTP/1.1 405 Method Not Allowed\r\nAllow: GET\r\nContent-Length: 0\r\n\r\n", 66);
        close(client);
        return 0;
    }

    buffer = realloc(buffer, 3, 4);
    size_t bufferSize = 4;
    read(client, buffer, 1);
    read(client, buffer, 1);
    strcpy(buffer, "web/\0");
    while (buffer[bufferSize - 1] != ' ') {
        buffer = realloc(buffer, bufferSize++, bufferSize);
        read(client, buffer + bufferSize - 1, 1);
    };
    buffer[bufferSize - 1] = 0;

    file_t file;
    if (bufferSize == 5) {
        file = openFile("web/index.html");
    } else {
        file = openFile(buffer);
    }

    if (file.fd <= 0) {
        write(client, "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n", 45);
    } else {
        //Will update this later to handle HTTP/2 
        write(client, "HTTP/1.1 200 Ok\r\nTransfer-Encoding: chunked\r\nContent-Type: ", 59);
        switch (file.type) {
            case video:
                write(client, "video/webm\r\n\r\n", 14);
                break;
            case audio:
                write(client, "audio/mpeg\r\n\r\n", 14);
                break;
            case image:
                write(client, "image/webp\r\n\r\n", 14);
                break;
            case json:
                write(client, "application/json\r\n\r\n", 20);
                break;
            case html:
            default:
                write(client, "text/html\r\n\r\n", 13);
                break;
        }
        buffer = realloc(buffer, bufferSize, bufferSize = writeBufSize);
        int readSize;
        while ((readSize = read(file.fd, buffer, writeBufSize)) > 0) {
            if (writeHex(client, readSize)) break;
            //I probably could reduce this to one write but just for redundancy its like this
            int totalWritten = 0;
            while (totalWritten < readSize) {
                int iWritten = write(client, buffer + totalWritten, readSize - totalWritten);
                //error check
                totalWritten += iWritten;
            }
            write(client, "\r\n", 2);
        }
        write(client, "0\r\n\r\n", 5);
    }

    free(buffer, bufferSize);
    close(client);
    return 0;
}

int main(void) {
    int ret;
    if (ret = fsInit()) {
        write(1, "File system init error\n", 23);
        return ret;
    }

    socket_t server = opensocket(8080);
    //error check

    volatile int *running = (int *)malloc(sizeof(int));
    //error check
    *running = 1;

    fd_t monitor = thread(consoleMonitor, (void *)running);

    while (*running) {
        //Might change this to a poll or use the signal() to unset SA_RESTART
        fd_t sock = accept(&server);
        //error check
        thread(clientHandler, &sock);
    }

    waitthread(monitor);
    close(server.socketFd);
    return 0;
}