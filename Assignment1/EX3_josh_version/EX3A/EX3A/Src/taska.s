.syntax unified
.thumb

#include "initialise.s"
#include "definitions.s"

.global main

.data

.align

tx_string: .asciz "!man im broke"	@String

ARNOLDSCHWARZENEGGER: .ascii "!"  		@Terminating character

.text

main:
	BL enable_peripheral_clocks
	BL enable_uart4
	BL enable_button
	
	LDR R1, = tx_string		@Load string address

	transmit_loop:
		BL check_button		@Check button

		BL tx_loop			@Transmit

		B transmit_loop		@Loop for next value

check_button:
	LDR R0, = GPIOA				@Load IO address
	LDR R4, [R0, IDR]			@Load input value
	TST R4, #1 << BUTTON_PIN	@Compare input value

	BEQ check_button			@Loop if no input

	BX LR						@Branch back to function call

tx_loop:
	LDRB R2, [R1], #1		@Load value
	CMP R2, NULL			@Check for null character
	
	BEQ terminate			@Time to terminate
	
	B tx_uart				@Branch to send char

terminate:
	LDR R0, = ARNOLDSCHWARZENEGGER
	LDRB R2, [R0]				@Append terminator
	BL tx_uart

	BX LR						@Exit program

tx_uart:
	LDR R0, = UART4				@Load base address
	LDR R3, [R0, USART_ISR]		@Load the status of the UART
	TST R3, #1 << UART_TXE  	@Check if transmit buffer is ready for more data
	
	BEQ tx_uart					@Reloop until ready for transmit

	STRB R2, [R0, USART_TDR] 	@Load the next value in the string into the transmit data register

	B delay_loop				@Delay

delay_loop:
	LDR R9, = 0xfffff			@Set arbitary large number

	B delay_inner

delay_inner:
	SUBS R9, #1					@Decrement delay
	BGT delay_inner
	
	BX LR 						@Return 

	
