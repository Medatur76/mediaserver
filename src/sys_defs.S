#if defined(_WIN32)
.intel_syntax noprefix
.section .text
.extern CreateFileW
.extern ExitProcess
.global strlen
.global _open
.global exit
//TODO
//Can be optimized apparently
strlen:
    xor rax, rax
strlen_1:
    cmp byte ptr [rcx + rax], 0
    je strlen_f
    inc rax
    jmp strlen_1
strlen_f:
    ret
_open:
    //Clear sharing flags for now
    mov r8, 0x00
    xor r9, r9
    sub rsp, 72
    mov r10, rdx
    mov rdx, 0x00
    test r10, 1
    jz _open_da_1
    mov edx, 0x04
    jmp _open_da_f
_open_da_1:
    test r10, 2
    jz _open_da_2
    mov edx, 0x80000000
_open_da_2:
    test r10, 4
    jz _open_da_f
    or edx, 0x40000000
_open_da_f:
    mov r11, 3
    test r10, 0x0008
    jz _open_cd_f
    or edx, 0x40000000
    test r10, 0x0010
    jz _open_cd_1
    mov r11, 1
    jmp _open_cd_f
_open_cd_1:
    test r10, 0x0020
    jz _open_cd_2
    mov r11, 2
    jmp _open_cd_f
_open_cd_2:
    mov r11, 4
_open_cd_f:
    mov dword ptr [rsp + 32], r11d
    mov dword ptr [rsp + 40], 128
    mov qword ptr [rsp + 48], 0
    call CreateFileW
    add rsp, 72
    ret
exit:
    jmp ExitProcess
    ud2
#elif defined(__x86_64__)
.intel_syntax noprefix
.globl open
.globl close
.globl exit
.section .text
open:
    mov rax, 2
    syscall
    ret
close:
    mov rax, 0x39
    syscall
    ret
exit:
    mov rax, 60
    syscall

    ud2
#elif defined(__i386__)
#error "There is currently no x86 binary code setup to hold the media server up"
.globl open
.section .text
open:
    mov eax, #5
    syscall
    ret
#elif defined(__aarch64__)
.globl open
.type open,%function
.globl exit
.type exit,%function
.section .text
open:
    mov x8, #56
    mov x3, x2
    mov x2, x1
    mov x1, x0
    mov x0, #-100
    svc #0
    ret
exit:
    mov x8, #93
    svc #0

    ud2
#elif defined(__arm__)
.global open
.type open,%function
.global exit
.type exit,%function
open:
    mov r7, #5
    svc #0x80
    ret
close:
    mov r7, #1
    svc #0x80

    ud2
#elif defined(__riscv)
#error "There is currently no riscv binary code setup to hold the media server up"
#endif
