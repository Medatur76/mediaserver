//This is a modified version of mingw-w64's fcntl.h file
/**
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is part of the mingw-w64 runtime package.
 * No warranty is given; refer to the file DISCLAIMER.PD within this package.
 */
#ifndef _INC_FCNTL
#define _INC_FCNTL

#define O_RDONLY 0x0000
#define O_WRONLY 0x0001
#define O_RDWR 0x0002
#define O_TRUNC 0x0200

//Everything defined here (begining with S_) was taking from the GNU C Library's POSIX Standard: 6.5 File Control Operations	<fcntl.h>
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
#define O_APPEND 0x0008
#define O_CREAT 0x0100
#define O_EXCL 0x0400
#define O_TEXT 0x4000
#define O_BINARY 0x8000
#define o_RAW O_BINARY
#define _O_WTEXT 0x10000
#define _O_U16TEXT 0x20000
#define _O_U8TEXT 0x40000
#define O_ACCMODE (O_RDONLY|O_WRONLY|O_RDWR)

#define O_NOINHERIT 0x0080
#define O_TEMPORARY 0x0040
#define _O_SHORT_LIVED 0x1000

#define O_SEQUENTIAL 0x0020
#define O_RANDOM 0x0010
#else
#define O_APPEND 0x0400
#define O_CREAT 0x0040
#define O_ACCMODE (O_RDONLY|O_WRONLY|O_RDWR)
#define O_NOCTTY 0x0100
#endif
#endif