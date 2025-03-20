.syntax unified
.thumb

.global main

#include "initialise.s"
.data


.align
terminate_char: .byte '!'
incoming_buffer: .space 62
buffer_length: .byte 62
.text

main:
	BL initialise_power
	BL enable_peripheral_clocks
	BL enable_uart4
	@uncomment the BOTH TWO lines under to change the clock speed (*6) for Ex3c
	@BL change_clock_speed
	@BL set_baud_rate

	LDR R0, =UART4 @save address of UART to R0
	LDR R1, =incoming_buffer	@save the address of buffer to R1
	LDR R2, =terminate_char	@save adress of terminate_char to R2
	LDRB R2, [R2]

	MOV R3, #0 @counter

loop:

	LDR R4, [R0, USART_ISR]	@status of uart
	TST R4, 1 << UART_ORE | 1 << UART_FE @Do a AND of the current status and the bit mask or ore and fe

	BNE clear_errors

	TST R4, 1 << UART_RXNE

	BEQ loop

	LDRB R5, [R0, USART_RDR]
	STRB R5, [R1, R3]

	ADD R3, #1

	CMP R5, R2
	BNE keep_going

	@uncomment the line under for Ex3d
	B transmitting

	B end_loop
keep_going:
	LDR R4, [R0, USART_RQR]
	ORR R4, 1 << UART_RXFRQ
	STR R4, [R0, USART_RQR]

	BGT loop
clear_errors:
@clear overrun and frame error
	LDR R4, [R0, USART_ICR]
	ORR R4, 1 << UART_ORECF | 1 << UART_FECF @ clear the flags
	STR R4, [R0, USART_ICR]	@store the status back
	B loop

transmitting:
	BL enable_uart
	@*uncomment the BOTH TWO line under if the above change_clock_speed and set_baud_rate is used
	@BL change_clock_speed
	@BL set_baud_rate

	LDR R0, =UART	@save address of UART to R0
	LDR R1, =incoming_buffer	@save the address of buffer to R1
	LDR R2, =terminate_char	@save adress of terminate_char to R2
	LDRB R2, [R2]
transmitting_loop:
	LDR R3, [R0, USART_ISR]
	ANDS R3, 1 << UART_TXE

	BEQ transmitting_loop

	LDRB R4, [R1], #1
	STRB R4, [R0, USART_TDR]

	CMP R4, R2
	BNE transmitting_loop

	B end_loop
end_loop:

	B end_loop
