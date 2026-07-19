//TODO
//strlen can be optimized apparently
.section .text
.extern progMain
.globl strlen
.globl _open
.globl exit
.globl close
.globl malloc
.globl opensocket
.globl accept
.globl _start
#if defined(_WIN32)
.intel_syntax noprefix
.extern CreateFileW
.extern GetStdHandle
.extern WriteFile
.extern ReadFile
.extern CreateThread
.extern WaitForSingleObject
.extern CloseHandle
.extern ExitProcess
.global __main
.globl _write
.globl _read
.globl thread
.globl waitthread
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
    mov rcx, -11
    sub rsp, 40
    call GetStdHandle
    add rsp, 40
    mov rcx, rax
    jmp _write_f
_write_1:
    cmp rcx, 2
    jne _write_f
    mov rcx, -12
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
    mov rcx, 1
    lea rdx, [rip + smsg]
    mov r8, smsg_end - smsg
    xor r9, r9
    call _write
    sub rsp, 40
    call progMain
    add rsp, 40
    mov rcx, rax
    jmp exit
#else
.globl write
.globl read
.globl _fork
.globl _waitpid
#if defined(__arm__) || defined(__aarch64__)
.type strlen,%function
.type exit,%function
.type _open,%function
.type write,%function
.type read,%function
.type _fork,%function
.type _waitpid,%function
.type close,%function
.type malloc,%function
.type opensocket,%function
#endif
#if defined(__x86_64__) || defined(__i386__)
.intel_syntax noprefix
#endif
#if defined(__x86_64__)
#define accReg rax
#define arg0Reg rdi
#define arg1Reg rsi
#define arg2Reg rdx
#define arg3Reg r10
#define arg4Reg r8
#define arg5Reg r9
#define jump jmp
#define jumpEquals je
#define zero(x) xor x, x
#define increment(x) inc x
#define subtract(x, y) sub x, y
#define SYS_open 2
#define SYS_write 1
#define SYS_read 0
#define SYS_fork 57
#define SYS_wait 61
#define SYS_close 3
#define SYS_mmap 9
#define SYS_socket 41
#define SYS_setsockopt 54
#define SYS_bind 49
#define SYS_listen 50
#define SYS_accept 43
#define SYS_exit 60
#define undefined ud2
#elif defined(__i386__)
#define accReg eax
#define arg0Reg ebx
#define arg1Reg ecx
#define arg2Reg edx
#define arg3Reg esi
#define arg4Reg edi
#define arg5Reg ebp
#define jump jmp
#define jumpEquals je
#define zero(x) xor x, x
#define increment(x) inc x
#define subtract(x, y) sub x, y
#define SYS_open 5
#define SYS_write 4
#define SYS_read 3
#define SYS_fork 2
#define SYS_wait 7
#define SYS_close 6
#define SYS_mmap 192
#define SYS_exit 1
#define syscall int 0x80
#elif defined(__aarch64__)
#define accReg x8
#define arg0Reg x0
#define arg1Reg x1
#define arg2Reg x2
#define arg3Reg x3
#define arg4Reg x4
#define arg5Reg x5
#define jump b
#define call bl
#define jumpEquals b.eq
#define zero(x) mov x, xzr
#define increment(x) adds x, x, 1
#define subtract(x, y) sub x, x, y
#define SYS_open 56
#define SYS_write 64
#define SYS_read 63
#define SYS_fork 220
#define SYS_wait 260
#define SYS_close 57
#define SYS_mmap 222
#define SYS_exit 93
#define ud2 udf #0
#define syscall svc #0
#elif defined(__arm__)
#define accReg r7
#define arg0Reg r0
#define arg1Reg r1
#define arg2Reg r2
#define arg3Reg r3
#define arg4Reg r4
#define arg5Reg r5
#define jump b
#define call bl
#define jumpEquals beq
#define zero(x) mov x, #0
#define increment(x) add x, x, #1
#define subtract(x, y) sub x, x, y
#define SYS_open #5
#define SYS_write #4
#define SYS_read #3
#define SYS_fork #2
#define SYS_wait #114
#define SYS_close #6
#define SYS_mmap #192
#define SYS_exit #1
#define ud2 udf #0
#define syscall svc #0
#define ret bx lr
#endif
strlen:
#if defined(__i386__)
    push arg0Reg
    mov arg0Reg, accReg
#endif
    zero(accReg)
strlen_1:
#if defined(__aarch64__) || defined(__arm__)
#if defined(__arm__)
#define w2 r2
#endif
    ldrb w2, [arg0Reg, accReg]
    cmp w2, #0
#else
    cmp byte ptr [arg0Reg + accReg], 0
#endif
    jumpEquals strlen_f
    increment(accReg)
    jump strlen_1
strlen_f:
#if defined(__aarch64__) || defined(__arm__)
    mov arg0Reg, accReg
#elif defined(__i386__)
    pop arg0Reg
#endif
    ret
_open:
#if defined(__aarch64__)
    mov x3, x2
    mov x2, x1
    mov x1, x0
    mov x0, #-100
#elif defined(__i386__)
    push arg0Reg
    mov arg0Reg, arg1Reg
    mov arg1Reg, arg2Reg
    mov arg2Reg, arg0Reg
    mov arg0Reg, accReg
#endif
    mov accReg, SYS_open
    syscall
#if defined(__i386__)
    pop arg0Reg
#endif
    ret
write:
#if defined(__i386__)
    push arg0Reg
    mov arg0Reg, arg1Reg
    mov arg1Reg, arg2Reg
    mov arg2Reg, arg0Reg
    mov arg0Reg, accReg
#endif
    mov accReg, SYS_write
    syscall
#if defined(__i386__)
    pop arg0Reg
#endif
    ret
read:
#if defined(__i386__)
    push arg0Reg
    mov arg0Reg, arg1Reg
    mov arg1Reg, arg2Reg
    mov arg2Reg, arg0Reg
    mov arg0Reg, accReg
#endif
    mov accReg, SYS_read
    syscall
#if defined(__i386__)
    pop arg0Reg
#endif
    ret
_fork:
#if defined(__i386__)
    push arg0Reg
#elif defined(__aarch64__)
    mov x0, #17
    mov x1, #0
    mov x2, #0
    mov x3, #0
    mov x4, #0
#endif
    mov accReg, SYS_fork
    syscall
#if defined(__i386__)
    pop arg0Reg
#endif
    ret
_waitpid:
#if defined(__i386__)
    push arg0Reg
#endif
    //This need to be review because I never use &out
    zero(arg3Reg)
    zero(arg1Reg)
#if defined(__i386__)
    mov arg0Reg, accReg
#endif
    zero(arg2Reg)
    mov accReg, SYS_wait
    syscall
#if defined(__i386__)
    pop arg0Reg
#endif
    ret
close:
#if defined(__i386__)
    push arg0Reg
    mov arg0Reg, accReg
#endif
    mov accReg, SYS_close
    syscall
#if defined(__i386__)
    pop arg0Reg
#endif
    ret
malloc:
#if defined(__i386__)
    push arg0Reg
    mov arg1Reg, accReg
#else
    mov arg1Reg, arg0Reg
#endif
    zero(arg0Reg)
#if defined(__arm__)
    mov arg2Reg, #0x03
    mov arg3Reg, #0x21
    mov arg4Reg, #-1
    mov arg5Reg, #0
#else
    mov arg2Reg, 0x03
    mov arg3Reg, 0x21
    mov arg4Reg, -1
    mov arg5Reg, 0
#endif
    mov accReg, SYS_mmap
    syscall
#if defined(__i386__)
    pop arg0Reg
#endif
    ret
//I wrote this all myself, I am god
opensocket:
    //arg0Reg has the port
    push arg0Reg
    //port is now on the stack
    mov arg0Reg, 2
    mov arg1Reg, 1
    //can also be 0
    mov arg2Reg, 6
    mov accReg, SYS_socket
    syscall
    mov arg0Reg, accReg
    mov arg1Reg, 1
    mov arg2Reg, 2
    push 1
    mov arg3Reg, rsp
    mov arg4Reg, 4
    mov accReg, SYS_setsockopt
    syscall
    pop accReg
    push arg0Reg
    //error check
    mov arg0Reg, 16
    call malloc
    pop arg0Reg
    pop arg2Reg
    mov word ptr [accReg], 2
    //except for this one line which is ai sadly
    xchg dl, dh
    mov word ptr [accReg+2], dx
    mov dword ptr [accReg+4], 0
    mov qword ptr [accReg+8], 0
    mov arg1Reg, accReg
    mov arg2Reg, 16
    mov accReg, SYS_bind
    syscall
    push arg1Reg
    //error check
    mov arg1Reg, 50
    mov accReg, SYS_listen
    syscall
    //error check
    mov accReg, arg0Reg
    pop arg2Reg
    ret
accept:
    mov accReg, arg0Reg
    zero(arg0Reg)
    mov arg0Reg, qword ptr [accReg]
    mov arg1Reg, qword ptr [accReg+8]
    push 16
    mov arg2Reg, rsp
    mov accReg, SYS_accept
    syscall
    pop arg2Reg
    ret
exit:
#if defined(__i386__)
    mov arg0Reg, accReg
#endif
    mov accReg, SYS_exit
    syscall
    ud2
_start:
    mov accReg, SYS_write
#if defined(__aarch64__) || defined(__arm__)
    mov arg0Reg, #1
    ldr arg1Reg, =smsg
    ldr arg2Reg, =smsg_len
#else
    mov arg0Reg, 1
    lea arg1Reg, smsg
    mov arg2Reg, smsg_end-smsg
#endif
    syscall
    call progMain
#if !defined(__aarch64__) && !defined(__arm__)
    mov arg0Reg, accReg
#endif
    mov accReg, SYS_exit
    syscall
    ud2
#endif
.section .data
smsg:
    .ascii "Built with MOS by Medatur76\n"
smsg_end:
#if defined(__aarch64__)
    smsg_len = smsg_end - smsg
#else
    .equ smsg_len, smsg_end - smsg
#endif