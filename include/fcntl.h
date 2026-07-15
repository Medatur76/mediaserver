//This is a modified compilation of the mingw-w64 runtime package and the GNU C Library
#ifndef _INC_FCNTL
#define _INC_FCNTL

# define S_IRUSR	0x0400          /* Read by owner.  */
# define S_IWUSR	0x0200          /* Write by owner.  */
# define S_IXUSR	0x0100          /* Execute by owner.  */
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