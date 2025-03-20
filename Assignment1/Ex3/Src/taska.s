/*.syntax unified
.thumb

.global main

#include "initialise.s"

.data
@ define variables


.align
@ can allocate as an array
@incoming_buffer: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
@ or allocate just as a block of space with this number of bytes
incoming_buffer: .space 62

@ One strategy is to keep a variable that lets you know the size of the buffer.
incoming_counter: .byte 62

@ Define a string
tx_string: .asciz "ab\r\n!"
@ one way to know the length of the string is to just define it as a variable
tx_length: .byte 4


.text
@ define text


@ this is the entry function called from the c file
main:

	@ in class run through the functions to perform the config of the ports
	@ for more details on changing the UART, refer to the week 3 live lecture/tutorial session.

	BL initialise_power
	BL change_clock_speed
	BL enable_peripheral_clocks
	BL enable_uart

	@ uncomment the next line to enter a transmission loop


	@ To read in data, we need to use a memory buffer to store the incoming bytes
	@ Get pointers to the buffer and counter memory areas
	LDR R6, =incoming_buffer
	LDR R7, =incoming_counter

	@ dereference the memory for the maximum buffer size, store it in R7
	LDRB R7, [R7]

	@ Keep a pointer that counts how many bytes have been received
	MOV R8, #0x00

Button_check:
	LDR R1, =GPIOA
	LDR R0, [R1, #IDR]					@ Load the input data register (IDR) of GPIOA into R0
    TST R0, #1 << BUTTON_PIN			@ Test the specific bit for the button pin

    BEQ Button_check
	B tx_loop

@ continue reading forever (NOTE: eventually it will run out of memory as we don't have a big buffer)

tx_loop:

	@ the base address for the register to set up UART
	LDR R0, =UART

	@ load the memory addresses of the buffer and length information
	LDR R3, =tx_string
	LDR R4, =tx_length

	@ dereference the length variable
	@ notice how memory address R4 is replaced by the value that was at that memory address
	LDR R4, [R4]


tx_uart:

	LDR R1, [R0, USART_ISR] @ load the status of the UART
	ANDS R1, 1 << UART_TXE  @ 'AND' the current status with the bit mask that we are interested in
						    @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	@ loop back to check status again if the flag indicates there is no byte waiting
	BEQ tx_uart

	@ load the next value in the string into the transmit buffer for the specified UART
	LDRB R5, [R3], #1
	CMP R5, #33
	BEQ Button_check

	STRB R5, [R0, USART_TDR]

	@ note the use of the S on the end of the SUBS, this means that the register flags are set
	@ and this subtraction can be used to make a branch

	@ keep looping while there are more characters to send
	SUBS R4, #1
	BGT tx_uart

	@ make a delay before sending again
	BL delay_loop

	@ loop back to the start
	B Button_check


delay_loop:
	LDR R9, =0xfffff

delay_inner:
	@ notice the SUB has an S on the end, this means it alters the condition register
	@ and can be used to make a branching decision.
	SUBS R9, #1
	BGT delay_inner
	BX LR*/



