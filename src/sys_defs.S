//TODO
//strlen can be optimized apparently
#if defined(_WIN32)
.intel_syntax noprefix
.section .text
.extern CreateFileW
.extern CloseHandle
.extern ExitProcess
.global strlen
.global _open
.global close
.global exit
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
close:
    jmp CloseHandle
    ret
exit:
    jmp ExitProcess
    ud2
#elif defined(__x86_64__)
.intel_syntax noprefix
.globl strlen
.globl open
.globl close
.globl exit
.section .text
strlen:
    xor rax, rax
strlen_1:
    cmp byte ptr [rdi + rax], 0
    je strlen_f
    inc rax
    jmp strlen_1
strlen_f:
    ret
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
.globl strlen
.globl open
.globl close
.globl exit
.section .text
strlen:
    xor eax, eax
strlen_1:
    cmp byte ptr [ebx + eax], 0
    je strlen_f
    inc eax
    jmp strlen_1
strlen_f:
    ret
open:
    mov eax, #5
    syscall
    ret
close:
    mov eax, #6
    syscall
    ret
exit:
    mov eax, #1
    syscall
    ud2
#elif defined(__aarch64__)
.globl strlen
.type strlen,%function
.globl open
.type open,%function
.globl close
.type close,%function
.globl exit
.type exit,%function
.section .text
strlen:
    mov x1, x0
    xor x0, x0
strlen_1:
    cmp byte ptr [x1 + x0], 0
    je strlen_f
    inc x0
    jmp strlen_1
strlen_f:
    ret
open:
    mov x8, #56
    mov x3, x2
    mov x2, x1
    mov x1, x0
    mov x0, #-100
    svc #0
    ret
close:
    mov x8, #57
    svc #0
    ret
exit:
    mov x8, #93
    svc #0
    ud2
#elif defined(__arm__)
.global strlen
.type strlen,%function
.global open
.type open,%function
.global close
.type close,%function
.global exit
.type exit,%function
strlen:
    mov r1, r0
    xor r0, r0
strlen_1:
    cmp byte ptr [r1 + r0], 0
    je strlen_f
    inc r0
    jmp strlen_1
strlen_f:
    ret
open:
    mov r7, #5
    svc #0x80
    ret
close:
    mov r7, #6
    svc #0x80
    ud2
exit:
    mov r7, #1
    svc #0x80
    ud2
#elif defined(__riscv)
.section .text
.global strlen
.global open
.global close
.global exit
strlen:
    mov a1, a0
    xor a0, a0
strlen_1:
    cmp byte ptr [a1 + a0], 0
    je strlen_f
    inc a0
    jmp strlen_1
strlen_f:
    ret
open:
    mov a7, #56
    svc #0x80
    ret
close:
    mov a7, #57
    svc #0x80
    ud2
exit:
    mov a7, #93
    svc #0x80
    ud2
#endif
