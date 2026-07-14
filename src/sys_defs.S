#if defined(_WIN32)
#error "Windows is absolutely frigging autistic when it comes to low level code so its not supported yet :("
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
