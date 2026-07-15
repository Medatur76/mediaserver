#ifdef COMPRESSED
#include "sys.h"
void _start(void) {
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
#define exit(x) return x
int main(void) {
#endif
    int fd = open("test.txt", O_RDONLY | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    if (fd < 0) exit(1);
    fd = close(fd);
    if (fd < 0) exit(2);
    exit(0);
}