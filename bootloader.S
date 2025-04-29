.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

.global bootload
.section .rodata
    image: .incbin "kernel.bin"
    end_of_image:
    str_boot_start: .asciz "bootloader started"
    str_boot_end:   .asciz "bootloader finished"
    str_boot_indicate: .asciz "#"

.section .text
bootload:
    ldr r0, =str_boot_start    
    bl dbgput_line                   // Вивід в консоль повідомлення про старт
    
    ldr r1, =image                   // r1 = початок kernel.bin
    ldr r2, =end_of_image            // r2 = кінець kernel.bin
    subs r3, r2, r1                  // r3 = розмір ядра в байтах
    lsrs r3, r3, #1                  // r3 = кількість halfword

    ldr r4, =_ram_start              // r4 = адреса для копіювання

loop:
    subs r3, r3, #1                  // Декремент лічильника halfword'ів
    blt done_copy                    // Вихід з циклу якщо r3 < 0

    ldrh r5, [r1, r3, lsl #1]        // Завантаження 2 байтів з образу ядра
    strh r5, [r4, r3, lsl #1]        // Записування цих байтів у відповідне місце
    b loop
 
    
done_copy:
    ldr r0, =str_boot_end
    bl dbgput_line                   // Вивід в консоль повідомлення про завершення роботи

    ldr r2, =_ram_start
    adds r2, r2, #4        
    ldr r0, [r2]                     // Завантаження адреси точки входу ядра   
    bx r0                            // Перехід на виконання ядра
    
bootload_end:    
    b bootload_end
