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
    BL configure_timer

    LDR R0, =TIM2
    MOV R1, #0b1           @ Enable timer
    STR R1, [R0, TIM_CR1]

    MOV R4, #10000         @ Number of 0.1ms periods in 1 second

    LDR R5, =GPIOE         @ Load GPIOE base address
count_loop:
    LDR R0, =TIM2
wait_for_update:
    LDR R1, [R0, TIM_SR]   @ Check status register
    TST R1, #0x01          @ Check if update event occurred
    BEQ wait_for_update    @ Wait for timer to overflow

    STR R1, [R0, TIM_SR]   @ Clear update event flag

    SUBS R4, R4, #1        @ Decrement counter
    BNE count_loop         @ Repeat until 1 second is reached

    @ Toggle LED every 1 second
    LDR R6, [R5, ODR]      @ Load current LED state
    EOR R6, R6, #0x0100   @ Toggle bit 8 (Assuming LED is on PE8)
    STR R6, [R5, ODR]      @ Store updated LED state

    MOV R4, #10000         @ Reset counter for next 1 second interval
    B count_loop           @ Continue blinking indefinitely
