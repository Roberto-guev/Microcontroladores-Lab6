.include "exti_map.inc"
.include "gpio_map.inc"


.cpu cortex-m3      @ Generates Cortex-M3 instructions
.section .text
.align	1
.syntax unified
.thumb
.global exti_isr
exti_isr:
@Prologo
       

        add     r6, #1 @Se aumenta en 1 el contador
        ldr     r0, =EXTI_BASE
        ldr     r1, [r0, EXTI_PR_OFFSET]
        orr     r1, r1, 0x1
        str     r1, [r0, EXTI_PR_OFFSET]
        bx lr
