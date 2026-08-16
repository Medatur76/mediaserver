@ECHO OFF

if not exist "./bin" mkdir "./bin"

gcc src/sys_defs.S src/*.c main.c -I./include -o bin/program.exe -DCOMPRESSED -DSOCKET --static -nostdlib -fno-builtin -s -fno-ident -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,-e,_start -Os -fno-stack-protector -fno-pic -fno-pie -ffreestanding -fomit-frame-pointer -mno-stack-arg-probe -lkernel32 -lws2_32

"./bin/program.exe"

echo %ERRORLEVEL%