.syntax unified
.thumb

.global main

#include "initialise.s"
#include "definitions.s"

.data
@define variables

.text

main:
    BL enable_peripheral_clocks			@ Branch with link to set the clocks for the I/O and UART
    BL initialise_discovery_board

    LDR R2, =GPIOE						@ Load the base address of GPIOE into R5
    LDR R4, =0b00000000					@ Store initial pattern for LEDs into R4

    LDR R1, =GPIOA						@ Load the base address of GPIOA into R1
    STRB R4, [R2, #ODR +1]				@ Display initial pattern

loop:
    LDR R0, [R1, #IDR]					@ Load the input data register (IDR) of GPIOA into R0
    TST R0, #1 << BUTTON_PIN			@ Test the specific bit for the button pin

    BEQ loop						@ Branch if the button is not pressed

    BL debounce_button					@ Branch to debounce function

loop_return:
    LSL R4, #1							@ Left shift the values in R4
    ORR R4, R4, 0b00000001				@ Set the next bit to 1 @For (B) use ORR
    STRB R4, [R2, #ODR +1]				@ Store value of the pattern into the output register
    CMP R4, 0b11111111
    BEQ loop_turnoff
    B loop

loop_turnoff:
	LDR R0, [R1, #IDR]
	TST R0, #1 << BUTTON_PIN

	BEQ loop_turnoff
	BL debounce_button_turnoff

loop_return_turnoff:
    LSR R4, #1							@ Left shift the values in R4
    AND R4, R4, 0b01111111
    STRB R4, [R2, #ODR +1]				@ Store value of the pattern into the output register
    B loop_turnoff

debounce_button:
    MOV R5, #0         					@ Counter for stable state
    MOV R6, #10        					@ Debounce threshold

debounce_loop:
    LDR R0, [R1, #IDR]
    TST R0, #1 << BUTTON_PIN

    BEQ stable_state
    B debounce_loop

debounce_button_turnoff:
	MOV R5, #0         					@ Counter for stable state
    MOV R6, #10        					@ Debounce threshold

debounce_loop_turnoff:
    LDR R0, [R1, #IDR]
    TST R0, #1 << BUTTON_PIN

    BEQ stable_state_turnoff
    B debounce_loop_turnoff

stable_state:
    ADDS R5, #1
    CMP R5, R6
    BLT debounce_loop  					@ Continue debounce if not stable for required cycles

    B loop_return      					@ Return when stable

stable_state_turnoff:
	ADDS R5, #1
    CMP R5, R6
    BLT debounce_loop_turnoff  					@ Continue debounce if not stable for required cycles

    B loop_return_turnoff      					@ Return when stable
