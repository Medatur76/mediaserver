#include "fcntl.h"
#ifndef __SYS_H
#define __SYS_H
typedef __SIZE_TYPE__ size_t;
typedef __INTPTR_TYPE__ ssize_t;
extern size_t strlen(const char *str);
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
#else
typedef int fd_t;
typedef int flag_t;
extern fd_t open(const char *pathname, flag_t flags, ...);
extern ssize_t write(fd_t fd, const void *buf, size_t count);
extern ssize_t read(fd_t fd, void *buf, size_t count);
#endif
extern int close(fd_t fd);
extern __attribute__((noreturn)) void exit(int status);
#endif