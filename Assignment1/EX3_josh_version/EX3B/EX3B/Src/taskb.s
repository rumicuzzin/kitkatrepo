.syntax unified
.thumb

#include "initialise.s"
#include "definitions.s"

.global main

.data

.align

tx_string: .asciz "man im broke"	@String

ARNOLDSCHWARZENEGGER: .ascii "!"  	@Terminating character

@ or allocate just as a block of space with this number of bytes
incoming_buffer: .space 129

@ One strategy is to keep a variable that lets you know the size of the buffer.
incoming_counter: .byte 129

.text

main:
	BL enable_peripheral_clocks
	BL enable_uart4
	    
    @ Get pointers to the buffer and counter memory areas
	LDR R1, = incoming_buffer
	LDR R7, = incoming_counter

	LDRB R7, [R7]	    @Dereference the memory for the maximum buffer size, store it in R7

	MOV R8, #0x00 	    @Keep a pointer that counts how many bytes have been received
	
    receive_loop:

        BL receive_char		@Receive character

        B check_terminator 	@Check if terminating character

receive_char:
	LDR R0, = UART4             @The base address for the register to set up UART
	LDR R2, [R0, USART_ISR]     @Load the status of the UART

	TST R2, 1 << UART_ORE | 1 << UART_FE  @Error check

	BNE clear_error             @Branch to fix error

	TST R2, 1 << UART_RXNE      @Check if ready to receive

	BEQ receive_char            @Loop until ready

	LDRB R3, [R0, USART_RDR]    @Load char
	STRB R3, [R1, R8]           @Store char at R1
	ADD R8, #0x1                @Increment by 1

	CMP R7, R8					@Check if end of buffer
	BGT no_reset
	MOV R8, #0

check_terminator:
	LDR R2, = ARNOLDSCHWARZENEGGER	@Load terminator address
	LDRB R4, [R2]			@Load terminator
    CMP R3, R4      		@Check if received character is the terminator
    BEQ store_null          @If terminator received, store null and exit

    B receive_loop          @Continue receiving

store_null:
    MOV R3, #0              @Load null terminator
    STRB R3, [R1, R8]       @ Store null terminator at end of string
    BX LR                   @ Return

no_reset:
	@ load the status of the UART
	LDR R2, [R0, USART_RQR]
	ORR R2, 1 << UART_RXFRQ
	STR R2, [R0, USART_RQR]

	BX LR

clear_error:
	@ Clear the overrun/frame error flag in the register USART_ICR
	LDR R2, [R0, USART_ICR]
	ORR R2, 1 << UART_ORECF | 1 << UART_FECF @ clear the flags (by setting flags to 1)
	STR R2, [R0, USART_ICR]
	B receive_char


