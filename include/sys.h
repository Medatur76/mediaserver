//This file holds all the system functions and types the program needs regardless of the os.
//It also holds various functions prefixed with a _. These are os specific and shouldnt be used as they dont translate between windows and linux

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
extern _noStack(2) char *strcpy(char *ptr, const char *str);
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
extern int _write(fd_t fd, const void *buf, size_t count, ssize_t *out);
static inline ssize_t writeFd(fd_t fd, const void *buf, size_t count) {
    ssize_t out;
    if (_write(fd, buf, count, &out)) return out;
    return -1;
}
extern int _read(fd_t fd, void *buf, size_t count, ssize_t *out);
static inline ssize_t readFd(fd_t fd, void *buf, size_t count) {
    ssize_t out;
    if (_read(fd, buf, count, &out)) return out;
    return -1;
}
extern _noStack(2) int _mkdir(const wchar_t *path, int umode);
static inline __attribute__((always_inline, gnu_inline)) int mkdir(const char *pathname, int umode) {
    wchar_t wpath[strlen(pathname) + 1];
    const unsigned char *src = (const unsigned char *)pathname;
    wchar_t *dst = wpath;
    while ((*dst++ = *src++));
    return _mkdir(wpath, umode);
}
extern int _noStack(1) closeFd(fd_t fd);
extern fd_t thread(ThreadFunc, void *param);
extern signed int waitthread(fd_t thread);
#else
typedef int fd_t;
typedef int flag_t;
extern _noStack(3) fd_t _open(const char *pathname, flag_t flags, int umode);
//Next two lines ai
#define OPEN_GET(_1,_2,_3,NAME,...) NAME
#define open(...) OPEN_GET(__VA_ARGS__, open3, open2)(__VA_ARGS__)
#define open2(path, flags) _open(path, flags, 0)
#define open3(path, flags, umode) _open(path, flags, umode)
extern _noStack(3) ssize_t writeFd(fd_t fd, const void *buf, size_t count);
extern _noStack(3) ssize_t readFd(fd_t fd, void *buf, size_t count);
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
extern _noStack(2) int mkdir(const char *path, int umode);
extern int _noStack(1) _close(fd_t fd);
#define closeFd(x) _close(x)
#endif
extern _noStack(1) void *malloc(size_t size);
extern _noStack(3) void *realloc(void *ptr, size_t old_size, size_t new_size);
extern _noStack(2) int free(void *ptr, size_t size);
#ifdef SOCKET
typedef struct _socket {
    fd_t socketHandle;
    struct _sockaddr {
        short   sin_family;
        unsigned short sin_port;
        struct  _in_addr {
            __UINT32_TYPE__ s_addr;
        } sin_addr;
        char    sin_zero[8];
    } *address;
} socket_t;
//Automatically opens and listens to a TCP socket at 127.0.0.1:port. Max 50 connections
extern _noStack(1) socket_t opensocket(__UINT16_TYPE__ port);
extern _noStack(1) socket_t acceptConnection(socket_t*);
#ifdef _WIN32
extern ssize_t readSocket(socket_t*, void *buf, size_t count);
extern ssize_t writeSocket(socket_t*, void *buf, size_t count);
extern int closeSocket(socket_t*);
#else
#define readSocket(x, y, z) readFd((x)->socketHandle, y, z)
#define writeSocket(x, y, z) writeFd((x)->socketHandle, y, z)
#define closeSocket(x) _close((x)->socketHandle)
#endif
#endif

int main(void);
#endif

//This is a modified compilation of the mingw-w64 runtime package and the GNU C Library
#ifndef _INC_FCNTL
#define _INC_FCNTL

# define S_IRUSR	0400          /* Read by owner.  */
# define S_IWUSR	0200          /* Write by owner.  */
# define S_IXUSR	0100          /* Execute by owner.  */
/* Read, write, and execute by owner.  */
# define S_IRWXU	(S_IRUSR|S_IWUSR|S_IXUSR)

# define S_IRGRP	(S_IRUSR >> 3)  /* Read by group.  */
# define S_IWGRP	(S_IWUSR >> 3)  /* Write by group.  */
# define S_IXGRP	(S_IXUSR >> 3)  /* Execute by group.  */
/* Read, write, and execute by group.  */
# define S_IRWXG	(S_IRWXU >> 3)

# define S_IROTH	(S_IRGRP >> 3)  /* Read by others.  */
# define S_IWOTH	(S_IWGRP >> 3)  /* Write by others.  */
# define S_IXOTH	(S_IXGRP >> 3)  /* Execute by others.  */
/* Read, write, and execute by others.  */
# define S_IRWXO	(S_IRWXG >> 3)

#ifdef _WIN32
#define O_APPEND 0x0001
//Might change this to 0 to match linux default functionality
#define O_RDONLY 0x0002
#define O_WRONLY 0x0004
#define O_RDWR O_RDONLY | O_WRONLY
//This might be wrong
#define O_ACCMODE (O_RDONLY|O_WRONLY|O_RDWR)
#define O_CREAT 0x0008
#define O_EXCL  0x0010
#define O_TRUNC 0x0020
#else
#define O_RDONLY 0x0000
#define O_WRONLY 0x0001
#define O_RDWR 0x0002
#define O_TRUNC 0x0200
#define O_APPEND 0x0400
#define O_CREAT 0x0040
#define O_ACCMODE (O_RDONLY|O_WRONLY|O_RDWR)
#define O_EXCL 0200
#endif
#endif