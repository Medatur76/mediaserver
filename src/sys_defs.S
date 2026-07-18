//TODO
//strlen can be optimized apparently
#if defined(_WIN32)
.intel_syntax noprefix
.section .text
.extern CreateFileW
.extern GetStdHandle
.extern WriteFile
.extern ReadFile
.extern CreateThread
.extern WaitForSingleObject
.extern CloseHandle
.extern ExitProcess
.extern main
.global __main
.global strlen
.global _open
.global _write
.global _read
.global thread
.global waitthread
.global close
.globl malloc
.global exit
.global _start
__main:
    ret
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
_write:
    cmp rcx, 1
    jne _write_1
    mov ecx, -11
    sub rsp, 40
    call GetStdHandle
    add rsp, 40
    mov rcx, rax
    jmp _write_f
_write_1:
    cmp rcx, 2
    jne _write_f
    mov ecx, -12
    sub rsp, 40
    call GetStdHandle
    add rsp, 40
    mov rcx, rax
_write_f:
    sub rsp, 40
    mov dword ptr [rsp + 32], 0x00
    call WriteFile
    add rsp, 40
    ret
_read:
    test rcx, rcx
    jnz _read_f
    mov ecx, -10
    sub rsp, 40
    call GetStdHandle
    add rsp, 40
    mov rcx, rax
_read_f:
    sub rsp, 40
    mov dword ptr [rsp + 32], 0x00
    call ReadFile
    add rsp, 40
    ret
thread:
    sub rsp, 48
    mov r8, rcx
    mov r9, rdx
    xor rcx, rcx
    xor rdx, rdx
    mov qword ptr [rsp + 32], 0x00
    mov qword ptr [rsp + 40], 0x00
    call CreateThread
    add rsp, 48
    ret
waitthread:
    sub rsp, 32
    mov rdx, -1
    call WaitForSingleObject
    add rsp, 32
    ret
/*opensocket:
    sub rsp, 32
    mov rcx, 2
    mov rdi, 1
    mov r8, 6
    call socket
    add rsp, 32
    mov r10, rax
    //error check
    sub rsp, 40
    mov rcx, rax
    mov rdi, 0xFFFF
    mov r8, 4
    mov qword ptr [rsp + 32], 0x04
    mov qword ptr [rsp + 40], 0x01
    mov r9, [rsp + 40]
    call setsockopt
    add rsp, 40
    //error check
    sub rsp, 32
    mov rcx, r10*/
close:
    sub rsp, 40
    call CloseHandle
    add rsp, 40
    //This bit was AI sadly
    test eax, eax
    setz al
    movzx eax, al
    ret
malloc:
    sub rsp, 32
    call GetProcessHeap
    add rsp, 32
    //error check
    sub rsp, 32
    mov r8, rcx
    mov rcx, rax
    xor rdx, rdx
    call HeapAlloc
    add rsp, 32
    ret
exit:
    jmp ExitProcess
    ud2
_start:
    sub rsp, 40
    call main
    add rsp, 40
    mov ecx, eax
    jmp exit 
#elif defined(__x86_64__)
.intel_syntax noprefix
.extern main
.globl strlen
.globl open
.globl write
.globl read
.globl _fork
.globl _waitpid
.globl close
.globl malloc
.globl exit
.globl _start
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
write:
    mov rax, 1
    syscall
    ret
read:
    xor rax, rax
    syscall
    ret
_fork:
    mov rax, 57
    syscall
    ret
_waitpid:
    mov rax, 61
    xor rdx, rdx
    xor r10, r10
    syscall
    ret
close:
    mov rax, 3
    syscall
    ret
malloc:
    mov rax, 9
    mov rsi, rdi
    xor rdi, rdi
    mov rdx, 0x03
    mov r10, 0x21
    mov r8, -1
    mov r9, 0
    syscall
    ret
exit:
    mov rax, 60
    syscall
    ud2
_start:
    //This would allow for params to be passed but I dont feel like figuring out the windows equivalent just yet cuz yeah suck it :P
    //mov rdi, [rsp]
    //lea rsi, [rsp + 8]

    push rbp
    mov rbp, rsp

    push 0x0A363772
    mov rax, 0x75746164654d2079
    push rax
    mov rax, 0x6220534f4d206874
    push rax
    mov rax, 0x697720746c697542
    push rax

    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp]
    mov rdx, rbp
    sub rdx, rsp
    syscall
  
    mov rsp, rbp
    pop rbp

    call main
    mov edi, eax
    jmp exit
#elif defined(__i386__)
.extern main
.globl strlen
.globl open
.globl close
.globl exit
.globl _start
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
_start:
    call main
    mov ebx, eax
    jmp exit
#elif defined(__aarch64__)
.extern main
.globl strlen
.type strlen,%function
.globl open
.type open,%function
.globl close
.type close,%function
.globl write
.type write,%function
.globl read
.type read,%function
.globl _fork
.type _fork,%function
.globl _waitpid
.type _waitpid,%function
.globl malloc
.type malloc,%function
.globl exit
.type exit,%function
.globl _start
.section .text
strlen:
    mov x1, x0
    orr x0, xzr, xzr
strlen_1:
    ldrb w2, [x1, x0]
    cmp w2, #0
    b.eq strlen_f
    add x0, x0, 1
    b strlen_1
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
write:
    mov x8, #64
    svc #0
    ret
read:
    mov x8, #63
    svc #0
    ret
_fork:
    mov x8, #220
    mov x0, #17
    mov x1, #0
    mov x2, #0
    mov x3, #0
    mov x4, #0
    svc #0
    ret
_waitpid:
    mov x8, #95
    mov x1, x0
    orr x0, xzr, xzr
    orr x2, xzr, xzr
    mov x3, #4
    orr x4, xzr, xzr
    svc #0
    ret
malloc:
    mov x8, #222
    mov x1, x0
    orr x0, xzr, xzr
    mov x2, 0x03
    mov x3, 0x21
    mov x4, -1
    mov x5, 0
    svc #0
    ret
exit:
    mov x8, #93
    svc #0
    udf #0
_start:
    bl main
    b exit
#elif defined(__arm__)
.extern main
.global strlen
.type strlen,%function
.global open
.type open,%function
.global close
.type close,%function
.global exit
.type exit,%function
.global _start
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
_start:
    bl main
    b exit
#elif defined(__riscv)
.section .text
.extern main
.global strlen
.global open
.global close
.global exit
.global _start
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
_start:
    call main
    j exit
#endif
