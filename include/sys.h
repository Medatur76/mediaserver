#include "fcntl.h"
#ifndef __SYS_H
#define __SYS_H
typedef __SIZE_TYPE__ size_t;
typedef __INTPTR_TYPE__ ssize_t;
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
#else
typedef int fd_t;
typedef int flag_t;
extern fd_t open(const char *pathname, flag_t flags, ...);
#endif
extern size_t strlen(const char *str);
extern ssize_t read(int fd, void *buf, size_t count);
extern ssize_t write(int fd, const void *buf, size_t count);
extern int close(fd_t fd);
extern signed int fork(void);
__attribute__((noreturn))
extern void exit(int status);
#endif