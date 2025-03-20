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

	B end

keep_going:
	BGT rx_uart              @ Return from function

end:
	B end*/
