.syntax unified
.thumb

#include "definitions.s"

@Function to enable the clocks for the peripherals
enable_peripheral_clocks:
	LDR R0, = RCC

	@Enable all of the GPIO peripheral clocks in AHBENR
	LDR R1, [R0, #AHBENR]		@Address for RCC clock
	ORR R1, 1 << GPIOE_ENABLE | 1 << GPIOD_ENABLE | 1 << GPIOC_ENABLE | 1 << GPIOB_ENABLE | 1 << GPIOA_ENABLE  @ enable GPIO
	STR R1, [R0, #AHBENR]
	BX LR

@Function to enable a UART4
enable_uart4:
	LDR R0, = GPIOC				@Using port C for alternative function

	@Set the alternate function for the UART pins
	LDR R1, = 0x55				@Alternate function five 0101 = 0x5
	STRB R1, [R0, AFRH + 1]		@Set to alternate function (pins 10 and 11) (+ 1 for second byte)

	@Modify the mode of the GPIO to alternate
	LDR R1, [R0, GPIO_MODER]	@Alternate function mode for port C
	ORR R1, 0xA00000 			@Mask for pins (PC10 to PC11) 0xA = 1010
	STR R1, [R0, GPIO_MODER]	@Store

	@Modify speed of the GPIO pins to high speed
	LDR R1, [R0, GPIO_OSPEEDR]	@Address for speed control
	ORR R1, 0xF00000			@Mask for pins to be set as high speed
	STR R1, [R0, GPIO_OSPEEDR]

	@ Set the enable bit for UART4
	LDR R0, =RCC 				@The base address for the register to turn clocks on/off
	LDR R1, [R0, #APB1ENR] 		@Load the original value from the enable register
	ORR R1, 1 << UART4_EN  		@Apply the bit mask to the previous values of the enable the UART
	STR R1, [R0, #APB1ENR] 		@Store the modified enable register values back to RCC

	@Baud rate
	MOV R1, #0x46 				@For 8MHz
	LDR R0, = UART4 			@The base address for the register to turn clocks on/off
	STRH R1, [R0, #USART_BRR] 	@Store this value directly in the first half word (16 bits)

	@Enable USART
	LDR R0, = UART4 			@Base address
	LDR R1, [R0, #USART_CR1] 	@Load the original value from the enable register
	ORR R1, 1 << UART_TE | 1 << UART_RE | 1 << UART_UE @Make a bit mask with a '1' for the bits to enable,
	STR R1, [R0, #USART_CR1] 	@Store the modified enable register values back to RCC

	BX LR @ return

@Function to enable putton on port A
enable_button:
	LDR R0, = GPIOA				@Base address
	LDRB R1, [R0, #GPIO_MODER] 	@Load the low byte of the MODER register
	AND R1, #0b11111100			@Bit mask to enable input mode
	STRB R1, [R0, #GPIO_MODER]

	BX LR

