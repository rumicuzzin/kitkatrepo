/*.syntax unified
.thumb

.global main

#include "initialise.s"

.data
@ define variables

.align
incoming_buffer: .space 62
buffer_length: .byte 62
terminate_char: .byte '!'
.text
@ define text


@ this is the entry function called from the c file
main:

	@ in class run through the functions to perform the config of the ports
	@ for more details on changing the UART, refer to the week 3 live lecture/tutorial session.

	BL initialise_power
	@BL change_clock_speed
	BL enable_peripheral_clocks
	BL enable_uart

	LDR R0, =UART
	LDR R1, = incoming_buffer
	LDR R2, = terminate_char
	LDRB R2, [R2]

	MOV R3, #0 @counter

rx_uart:
	LDR R4, [R0, USART_ISR] @ load the status of the UART
	TST R4, 1 << UART_RXNE

	BEQ rx_uart

	LDRB R5, [R0, #USART_RDR]
	STRB R5, [R1, R3]
	ADD R3, #1
	CMP R5, R2
	BNE keep_going

	B tx_uart


	B end

tx_uart:
	LDR R6, [R0, USART_ISR] @ load the status of the UART
	ANDS R6, 1 << UART_TXE  @ 'AND' the current status with the bit mask that we are interested in
						    @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	@ loop back to check status again if the flag indicates there is no byte waiting
	BEQ tx_uart

	@ load the next value in the string into the transmit buffer for the specified UART
	LDRB R7, [R1], #1
	STRB R7, [R0, USART_TDR]
	CMP R7, #33
	BEQ rx_uart



	@ note the use of the S on the end of the SUBS, this means that the register flags are set
	@ and this subtraction can be used to make a branch

	@ keep looping while there are more characters to send
	SUBS R3, #1
	BGT tx_uart

	@ make a delay before sending again
	BL delay_loop

	@ loop back to the start
	B end

delay_loop:
	LDR R9, =0xfffff

delay_inner:
	@ notice the SUB has an S on the end, this means it alters the condition register
	@ and can be used to make a branching decision.
	SUBS R9, #1
	BGT delay_inner
	BX LR

keep_going:
	BGT rx_uart              @ Return from function
end:
	B end*/
