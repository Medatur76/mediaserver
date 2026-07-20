#include "sub_systems.h"
#include "utils.h"

int fsInit() {
    return 0;
}

file_t openFile(const char *path) {
    //Will hardcode this in the future
    return (file_t){open(path, O_RDONLY), html};
}