#include "sys.h"

int fsInit();

typedef struct _file_t {
    fd_t fd;
    enum type_t {
        html,
        //This by default will turn into video/webm. Need to add ffmpeg or add a way to pass different video types
        video,
        //This might get specific later on
        audio,
        //This by default will turn into image/webm. Need to add ffmpeg or add a way to pass different image types
        image,
        json
    } type;
} file_t;

file_t openFile(const char *);