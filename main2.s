/* This pins works as a GPIO, then it must be configured,
 * at assembly level, through the following registers:
 * 1) RCC register,
 * 2) GPIOC_CRL register, 
 * 3) GPIOC_CRH register, and
 * 4) GPIOC_ODR register.
 * 
 * Autor: Roberto Guevara Maldonado - 2213064649
*/


.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "gpio_map.inc"
.include "rcc_map.inc"
.include "systick_map.inc"
.include "nvic_reg_map.inc"
.include "afio_map.inc"
.include "exti_map.inc"

.section .text
.align	1
.syntax unified
.thumb
.global __main
__main:
# Setup

        @Prologo
        push {r7, lr}
        sub sp, sp, #24
        add r7, sp, #0

        ldr r0 , =SYSTICK_BASE
        mov r1, #0
        str r1, [r0, #STK_CTRL_OFFSET]

        ldr r1, [ r0 , #STK_CTRL_OFFSET]
        orr r1, r1, #7
        str r1, [r0, #STK_CTRL_OFFSET]

        # enabling clock in port A
        ldr     r0, =RCC_BASE
        mov     r1, 0x4 @ loads 4 in r1 to enable clock in port A (IOPC bit)
        str     r1, [r0, RCC_APB2ENR_OFFSET] @ M[RCC_APB2ENR] gets 4

        # reset pin 0 to F in GPIOA_CRL
        ldr     r0, =GPIOA_BASE @ moves base address of port A
        ldr     r1, =0x44444444 @ this constant signals the reset state
        str     r1, [r0, GPIOx_CRL_OFFSET] @ M[GPIOC_CRL] gets 0x44444444
        str     r1, [r0, GPIOx_CRH_OFFSET] @ M[GPIOC_CRH] gets 0x44444444

        # set pin 0, 1 as digital INPUT                                      BOTON 1 SUMA, BTON 2 RESTA
        # set pin 2, 3, 4, 5, 6, 7 as digital output                         LED 1 - 6 BIT 0 - 5 CONTADOR
        ldr     r1, =0x33333388 @ PA0-1: INPUT pull-up, PA2-7: output push-pull, max speed 50 MHz 
        str     r1, [r0, GPIOx_CRL_OFFSET] @ M[GPIOC_CRL] gets 0x33333388

        # set pin 8, 9, 10, 11 as digital output                                    LED 7 - 10 BIT 6 - 9 CONTADOR
        ldr     r1, =0x44443333 @ PC13: output push-pull, max speed 50 MHz
        str     r1, [r0, GPIOx_CRH_OFFSET] @ M[GPIOC_CRH] gets 0x44443333

        ldr 	r0, =AFIO_BASE
	mov	r1, #0
	str 	r1, [r0, AFIO_EXTICR1_OFFSET]

	ldr 	r0, =AFIO_BASE
	mov	r1, #0
	str 	r1, [r0, AFIO_EXTICR2_OFFSET]

	ldr 	r0, =EXTI_BASE
	mov	r1, #0
	str 	r1, [r0, EXTI_FTST_OFFSET]
	ldr 	r1, =0x03
	str	r1, [r0, EXTI_RTST_OFFSET]

	str 	r1, [r0, EXTI_IMR_OFFSET]

	ldr 	r0, =NVIC_BASE
	ldr 	r1, =0xC0
	str	r1, [r0, NVIC_ISER0_OFFSET]

        # set led status initial value
        add     r0, GPIOx_ODR_OFFSET @ moves address of GPIOC_ODR register to r0
        mov     r1, 0x0

         @Prologo loop
        push {r7}   
        sub sp, sp, #20                    
        add r7, sp, #0 @Updates r7

        @Set CONTADOR
        mov r0, #0b0 @Contador = 0 que sera representado en los leds (Se usa binario para facilitar la visualizacion) declarar como localidad de memoria
        str r0, [r7, #12] @Se almacena el contador

        @Set Variable de la velocidad del contador
        mov r5, #0 @Se carga 1 como la velocidad inicial del contador    registro r5 = velocidad

        @Set Variable de la direccion del contador (positivo-negativo)
        mov r6, #0 @Se carga 0 en la variable (positivo, si el valor es par la  cuenta sera positiva, de lo contrario decresera)
        @ registro r6 = modo (decreciente-creciente)

loop:   
        
        
        and r2, r6, #1 @Se hace la operacion and con la variable para determinar si es par o impar
        cmp r2, #1 @Si se cumple la comparacion y ambos numeros son iguales el numero es impar (Cambia el sentido del contador)
        beq .L3

.L2:
        ldr r0, [r7, #12]@Se carga el contador
        add r0, #1 @Se aumenta en 1 el contador                                      SUMA
        str r0, [r7, #12]@Se almacena el contador
        b .L4

.L3:
        ldr r0, [r7, #12]@Se carga el contador
        sub r0, #1 @Se decrementa en 1 el contador                                      Resta
        str r0, [r7, #12]@Se almacena el contador

.L4:

        @En esta parte se verifica el estado del contador y se actualiza el estado de los leds

        ldr r0, [r7, #12]@Se carga el contador
        mov r1, r0 @Se respalda el valor del contador para enviar la senal a los leds
        str r0, [r7, #12]@Se almacena el contador

        ldr r0, =GPIOA_BASE @ moves base address of port A
        add r0, GPIOx_ODR_OFFSET @ moves address of GPIOA_ODR register to r0
        lsl r1, #2 @Se desplaza el valor 2 unidades a la izquiera para que empieze en el pin 2 - bit 2 y termine en el pin 11 - bit 11   DONDE SE ENCUENTRAN LOS 10 LED
        str r1, [r0] @Se pasa el valor para los pines del pin 2 - 11           LED 0 - 10  


        cmp r5, #0  @Se compara para verificar la velocidad
        beq .L5
        b .L6

.L5:
        mov r8, 0x280000
        b wait

.L6:
        cmp r5, #1
        beq .L7
        b .L8

.L7:
        mov r8, 0x140000
        b wait

.L8:
        cmp r5, #2
        beq .L9
        b .L10

.L9:
        mov r8, 0xA0000
        b wait

.L10:
        cmp r5, #3
        beq .L11
        b wait

.L11:
        mov r8, 0x50000


wait:
        mov r0, #0
        waitLoop:
        add r0, r0, #1            @Delay para detener los ciclos del reloj
        cmp r0, r8
        bne waitLoop

        b       loop
