@ECHO OFF

if not exist "./bin" mkdir "./bin"

gcc src/sys_defs.S src/*.c main.c -I./include -o bin/program.exe -DCOMPRESSED --static -nostdlib -fno-builtin -s -fno-ident -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,-e,_start -Os -lkernel32 -mno-stack-arg-probe

:: "./bin/program.exe"

:: echo %ERRORLEVEL%