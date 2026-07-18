//This file holds all the system functions and types the program needs regardless of the os.
//It also holds various functions prefixed with a _. These are os specific and shouldnt be used as they dont translate between windows and linux

#include "fcntl.h"
#ifndef __SYS_H
#define __SYS_H
#define main progMain
#if defined(__i386__)
#define _noStack(x) __attribute__((regparm(x)))
#else
#define _noStack(x)
#endif
typedef __SIZE_TYPE__ size_t;
typedef __INTPTR_TYPE__ ssize_t;
//TODO Force __stdcall on Win32 systems (not Win64)
typedef __INT32_TYPE__ (*ThreadFunc)(void*);
extern _noStack(1) size_t strlen(const char *str);
extern __attribute__((noreturn)) _noStack(1) void exit(int status);
#ifdef _WIN32
typedef unsigned long int flag_t;
typedef __INTPTR_TYPE__ fd_t;
typedef __WCHAR_TYPE__ wchar_t;
extern fd_t _open(wchar_t *pathname, flag_t flags, ...);
//TODO add the umode functionality to the output file
static inline __attribute__((always_inline, gnu_inline)) fd_t open(const char *pathname, flag_t flags, ...) {
    wchar_t wpath[strlen(pathname) + 1];
    const unsigned char *src = (const unsigned char *)pathname;
    wchar_t *dst = wpath;
    while ((*dst++ = *src++));
    return _open(wpath, flags, __builtin_va_arg_pack());
}
extern int _write(int fd, const void *buf, size_t count, ssize_t *out);
static inline ssize_t write(fd_t fd, const void *buf, size_t count) {
    ssize_t out;
    if (_write(fd, buf, count, &out)) return out;
    return -1;
}
extern int _read(fd_t fd, void *buf, size_t count, ssize_t *out);
static inline ssize_t read(fd_t fd, void *buf, size_t count) {
    ssize_t out;
    if (_read(fd, buf, count, &out)) return out;
    return -1;
}
extern fd_t thread(ThreadFunc, void *param);
extern signed int waitthread(fd_t thread);
#else
typedef int fd_t;
typedef int flag_t;
extern _noStack(3) fd_t open(const char *pathname, flag_t flags, ...);
extern _noStack(3) ssize_t write(fd_t fd, const void *buf, size_t count);
extern _noStack(3) ssize_t read(fd_t fd, void *buf, size_t count);
extern signed int _fork(void);
static inline unsigned int thread(ThreadFunc func, void *param) {
    //signal(SIGCHLD, SIG_IGN);
    int pid = _fork();
    //error check
    if (!pid) exit(func(param));
    return pid;
}
extern _noStack(2) void _waitpid(fd_t fd, int *out);
static inline int waitthread(fd_t fd) {
    int out;
    _waitpid(fd, &out);
    //error check
    return out;
}
#endif
extern int _noStack(1) close(fd_t fd);
typedef struct _socket {
    fd_t socketFd;
    struct sockaddr {
        unsigned short int sa_family;
        char sa_data[14];
    } address;
} socket;
#endif
extern _noStack(1) void *malloc(size_t size);
//Automatically opens and listens to a TCP socket at 127.0.0.1:port. Max 50 connections
extern _noStack(1) socket opensocket(__UINT16_TYPE__ port);
extern _noStack(1) fd_t accept(socket);

int main(void);