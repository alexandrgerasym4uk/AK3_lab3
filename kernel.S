.syntax unified
.cpu cortex-m4
.thumb
#define A #4

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel
    
.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Result: "
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line
    // Завдання минулої лаб. роботи

    mov r0, #7         // a = 7
    mov r1, #2         // b = 2
    mov r2, #9         // c = 9

    sub r3, r0, r1     // r3 = a - b
    mov r4, #3
    mul r3, r3, r4     // r3 = (a - b) * 3

    mov r0, #1         // r0 = 1 (основа 2)
    lsl r5, r0, r2     // r5 = 2^c (зсув вліво на c біт)

    add r6, r3, r5     // r6 = (a - b) * 3 + 2^c

    // Вивід результату
    ldr r0, =final
    bl dbgput
    mov r0, r6
    bl dbgput_num
    
    end:
    b end
