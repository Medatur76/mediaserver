#ifdef COMPRESSED
#include "sys.h"
#else
//Everything defined here (begining with S_) was taking from the GNU C Library's POSIX Standard: 6.5 File Control Operations	<fcntl.h>
# define S_IRUSR	0x0400          /* Read by owner.  */
# define S_IWUSR	0x0200          /* Write by owner.  */
# define S_IRGRP	(S_IRUSR >> 3)  /* Read by group.  */
# define S_IROTH	(S_IRGRP >> 3)  /* Read by others.  */
#include <fcntl.h>
#include <unistd.h>
#ifdef _WIN32
#include <io.h>
#endif
typedef int fd_t;
#endif
int main(void) {
    fd_t fd = open("test.txt", O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    if (fd < 0) return 1;
    write(1, "Hello, World!\r\n", 15);
    ssize_t out = write(fd, "Hello, World!\r\n", 15);
    if (out == -1) return 2;
    out = close(fd);
    if (out) return 3;
    return 0;
}