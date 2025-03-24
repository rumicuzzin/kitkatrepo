.syntax unified
.thumb

#include "initialise.s"
#include "definitions.s"

.global main

.text

main:
    BL enable_timer2_clock
    BL enable_peripheral_clocks
    BL initialise_discovery_board

    @ Configure Timer 2 for 0.5s delay (1 MHz clock → ARR = 50000)
    LDR R0, =TIM2
    MOV R1, #159               @ Prescaler to get 1 MHz from system clock
    STR R1, [R0, TIM_PSC]

    LDR R1, =50000            @ ARR = 500000 → overflow every 0.5 sec
    STR R1, [R0, TIM_ARR]

    MOV R1, #0b10000001        @ ARPE=1, CEN=1
    STR R1, [R0, TIM_CR1]

    LDR R5, =GPIOE             @ Load base address of GPIOE

loop:
    @ Wait for update event (UIF = bit 0 in TIM_SR)
wait_for_update:
    LDR R0, =TIM2
    LDR R1, [R0, TIM_SR]
    TST R1, #0x1
    BEQ wait_for_update

    @ Clear the update event flag (write 0 to bit 0 only)
    MOV R1, #0x0
    STR R1, [R0, TIM_SR]

    @ Toggle PE8
    LDR R6, [R5, ODR]          @ Read current output state
    EOR R6, R6, #0x0100        @ Toggle bit 8
    STR R6, [R5, ODR]          @ Write updated value

    B loop                     @ Repeat forever
