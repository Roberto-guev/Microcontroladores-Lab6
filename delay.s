.include "exti_map.inc"
.include "gpio_map.inc"

.cpu cortex-m3      @ Generates Cortex-M3 instructions
.section .text
.align	1
.syntax unified
.thumb
.global delay
delay:
       
        add     r5, #1
        and     r5, r5, #3
        
        ldr     r0, =EXTI_BASE
        ldr     r1, [r0, EXTI_PR_OFFSET]
        orr     r1, r1, 0x2
        str     r1, [r0, EXTI_PR_OFFSET]
        bx lr
     