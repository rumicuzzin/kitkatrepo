.syntax unified
.thumb
.global main
#include "definitions.s"
#include "initialise.s"

.data
.bss
    led_index: .space 4  @ Stores current LED index (starting from PE8)
    direction: .space 4   @ Stores current direction (1 = forward, 0 = backward)

.text

main:
    BL enable_peripheral_clocks  @ Enable clocks for GPIO
    BL initialise_discovery_board @ Set GPIOE pins as outputs
    MOV R0, #0x0100              @ Start with first LED (PE8)
    LDR R1, =led_index
    STR R0, [R1]                 @ Store initial LED index
    MOV R0, #1                   @ Start direction as forward
    LDR R1, =direction
    STR R0, [R1]                 @ Store initial direction

main_loop:
    BL read_button_and_toggle  @ Check button press and update LED state
    B main_loop                   @ Infinite loop

@ Function to set LED pattern based on a given bitmask
@ R0 - bitmask input (bits 8-15 correspond to LEDs on PE8-PE15)
set_leds:
    LDR R1, =GPIOE         @ Load base address of GPIOE
    STRH R0, [R1, #ODR]    @ Store bitmask into output data register (ODR)
    BX LR                  @ Return from function

@ Function to read the user button and toggle LED state
read_button_and_toggle:
    LDR R1, =GPIOA         @ Load base address of GPIOA (button is connected here)
    LDR R2, [R1, #IDR]     @ Read input data register (IDR)
    TST R2, #1             @ Test if button (PA0) is pressed (bit 0 set)
    BEQ return_button      @ If not pressed, return

    LDR R3, =GPIOE         @ Load base address of GPIOE
    LDRH R4, [R3, #ODR]    @ Read current LED state
    LDR R5, =led_index     @ Load current LED index
    LDR R6, [R5]           @ Get stored LED bit position
    LDR R7, =direction     @ Load direction index
    LDR R8, [R7]           @ Get current direction

    CMP R8, #1             @ Check if direction is forward
    BEQ turn_on_next       @ If forward, turn on next LED
    B turn_off_next        @ If backward, turn off next LED

turn_on_next:
    ORR R4, R6             @ Turn on the current LED
    STRH R4, [R3, #ODR]    @ Store updated LED state
    LSL R6, R6, #1         @ Move to the next LED

    CMP R6, #0x10000       @ Check if we exceeded PE15
    BNE store_next_index   @ If not, store next index
    MOV R0, #0             @ Reverse direction
    STR R0, [R7]           @ Store new direction
    MOV R6, #0x8000        @ Set to PE15 to turn off from the top
    B store_next_index

turn_off_next:
    BIC R4, R6             @ Turn off the current LED
    STRH R4, [R3, #ODR]    @ Store updated LED state
    LSR R6, R6, #1         @ Move to the previous LED

    CMP R6, #0x0080        @ Check if we reached PE8 while going backward
    BNE store_next_index   @ If not, store next index
    MOV R0, #1             @ Reverse direction to forward
    STR R0, [R7]           @ Store new direction
    MOV R6, #0x0100        @ Set to PE8 to start turning on from the bottom

store_next_index:
    STR R6, [R5]           @ Store updated LED index

return_button:
    BX LR                  @ Return from function
