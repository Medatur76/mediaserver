#include "sub_systems.h"

void init(void) {
    //Ensure web folder
}

File find(String requestPath) {
    if (requestPath.len == 1) return (File){html, open("web/index.html", O_RDONLY, 0644)};
}

fileSystem = {init, find};