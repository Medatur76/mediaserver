#include "utils.h"

typedef enum _headers {
    
} Headers;

typedef struct _file {
    enum _t_file {
        html,
        video,
        audio
    } t_file;
    int fd;
} File;


struct _fileSystem {
    int (*init)(void);
    File (*locateFile)(String);
} fileSystem;

struct _backupSystem {
    int (*init)(void);
} backupSystem;