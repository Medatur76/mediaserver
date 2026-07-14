#include "fcntl.h"

typedef __SIZE_TYPE__ size_t;
typedef __INTPTR_TYPE__ ssize_t;

extern ssize_t read(int fd, void *buf, size_t count);
extern ssize_t write(int fd, const void *buf, size_t count);
extern int open(const char *pathname, int flags, ...);
extern int close(int fd);

extern signed int fork(void);

__attribute__((noreturn))
extern void exit(int status);