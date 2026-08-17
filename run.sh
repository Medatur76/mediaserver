#!/bin/bash

[ ! -d "./bin" ] && mkdir "./bin"

gcc src/sys_defs.S src/*.c main.c -I./include -o bin/program -DCOMPRESSED -DSOCKET --static -nostdlib -fno-builtin -s -fno-ident -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,-e,_start -Os -fno-stack-protector -fno-pic -fno-pie -ffreestanding -fomit-frame-pointer

chmod +x ./bin/program

./bin/program

echo $?