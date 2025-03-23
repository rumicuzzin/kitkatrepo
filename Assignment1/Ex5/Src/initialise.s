.syntax unified
.thumb

#include "definitions.s"


enable_peripheral_clocks:

	LDR R0, =RCC

	@ enable all of the GPIO peripherals in AHBENR
	LDR R1, [R0, #AHBENR]
	ORR R1, 1 << GPIOE_ENABLE | 1 << GPIOC_ENABLE   @ enable GPIO
	STR R1, [R0, #AHBENR]

	BX LR @ return


initialise_discovery_board:
	LDR R0, =GPIOE 	@ load the address of the GPIOE
	LDR R1, =0x5555  @ load the binary value of 01 (OUTPUT) for each port in the upper two bytes
					 @ as 0x5555 = 01010101 01010101
	STRH R1, [R0, #GPIO_MODER + 2]   @ store the new register values in the top half word representing
								@ the MODER settings for pe8-15
	BX LR @ return from function call

enable_uart:

	LDR R0, =GPIOC

	@ set the alternate function for the USART1 Pa9,10
	LDR R1, =0x77
	STRB R1, [R0, AFRL + 2]

	@ choose mode alternate function for Pa9,10
	LDR R1, =0x00A00A00 @ Mask for pins to change to 'alternate function mode'
	STR R1, [R0, GPIO_MODER]

	@set the speed to high
	LDR R1, =0x00F00F00 @ Mask for pins to be set as high speed
	STR R1, [R0, GPIO_OSPEEDR]

	@ enable bus for USART1
	LDR R0, =RCC
	LDR R1, [R0, #APB2ENR]
	ORR R1, 1 << UART_EN  @ apply the bit mask to the original value
	STR R1, [R0, #APB2ENR]

	@ default baud rate
	MOV R1, #0x46 @8Mhz/115200
	LDR R0, =UART @
	STRH R1, [R0, #USART_BRR]

	@ enable the functions
	LDR R0, =UART
	LDR R1, [R0, #USART_CR1]
	ORR R1, 1 << UART_TE | 1 << UART_RE | 1 << UART_UE @ make a bit mask with corresponding bits to '1' for enable
														@whats gonna be used
	STR R1, [R0, #USART_CR1]

	BX LR

enable_uart4:

	LDR R0, =GPIOC

	@ set the alternate function for UART4
	LDR R1, =0x55

	STRB R1, [R0, AFRH+1]

	LDR R1, =0x00A00A00 @ Mask for pin pc10,11 to AF
	STR R1, [R0, GPIO_MODER]

	@ set the speed for pc10,11 to high
	LDR R1, =0x00F00F00 @ Mask for pins
	STR R1, [R0, GPIO_OSPEEDR]

	@ enable bus for UART4
	LDR R0, =RCC
	LDR R1, [R0, #APB1ENR]
	ORR R1, 1 << UART4_EN  @ apply the bit mask to the orginal value
	STR R1, [R0, #APB1ENR]

	@ default baud rate 115200
	MOV R1, #0x46 @ same as enable_uart
	LDR R0, =UART4
	STRH R1, [R0, #USART_BRR]

	@ enable pin functions
	LDR R0, =UART4
	LDR R1, [R0, #USART_CR1]
	ORR R1, 1 << UART_TE | 1 << UART_RE | 1 << UART_UE @ bit mask for enable, turning the corresponding bits to 1
	STR R1, [R0, #USART_CR1]

	BX LR




change_clock_speed:

	@ enable
	LDR R0, =RCC
	LDR R1, [R0, #RCC_CR]
	LDR R2, =1 << HSEBYP | 1 << HSEON @ bit mask with 1 at 0th position
	ORR R1, R2 @ apply the bit mask
	STR R1, [R0, #RCC_CR]

wait_for_HSERDY:
@wait for the previous part is done
	LDR R1, [R0, #RCC_CR]
	TST R1, 1 << HSERDY
	BEQ wait_for_HSERDY

@switch to PLL
	@ clock is set to External clock, f=8MHz
	LDR R1, [R0, #RCC_CFGR]
	LDR R2, =1 << 20 | 1 << PLLSRC | 1 << 22 @ 1<<22, usb prescela to 1
	ORR R1, R2  @ set PLLSRC and PLLMUL to 0100 - bit 20 is 1 (set speed as 6x faster)
				@ NOTE: No faster than 72MHz)
	STR R1, [R0, #RCC_CFGR]

	@ enable PLL and wait for complete
	LDR R0, =RCC
	LDR R1, [R0, #RCC_CR]
	ORR R1, 1 << PLLON @ apply the bit mask to turn on the PLL
	STR R1, [R0, #RCC_CR]

wait_for_PLLRDY:
	LDR R1, [R0, #RCC_CR]
	TST R1, 1 << PLLRDY @ Test the HSERDY bit
	BEQ wait_for_PLLRDY

@ step 3, PLL is ready, switch system clock to PLL
	LDR R0, =RCC
	LDR R1, [R0, #RCC_CFGR]  @ load the current value of the peripheral clock registers
	MOV R2, 1 << 10 | 1 << 1  @ some more settings - bit 1 (SW = 10)  - PLL set as system clock
									   @ bit 10 (HCLK=100) divided by 2 (clock is faster, need to prescale for peripherals)
	ORR R1, R2	@ Set the values of these two clocks (turn them on)
	STR R1, [R0, #RCC_CFGR]  @ store the modified register back to the submodule

	LDR R1, [R0, #RCC_CFGR]  @ load the current value of the peripheral clock registers
	ORR R1, 1 << USBPRE	@ Set the USB prescaler (when PLL is on for the USB)
	STR R1, [R0, #RCC_CFGR]  @ store the modified register back to the submodule

	BX LR



@ initialise the power systems on the microcontroller
@ PWREN (enable power to the clock), SYSCFGEN system clock enable
initialise_power:

	LDR R0, =RCC

	@ enable clock power in APB1ENR
	LDR R1, [R0, #APB1ENR]
	ORR R1, 1 << PWREN @ apply the bit mask for power enable
	STR R1, [R0, #APB1ENR]

	@ enable clock config in APB2ENR
	LDR R1, [R0, #APB2ENR]
	ORR R1, 1 << SYSCFGEN @ apply the bit mask for system configeration
	STR R1, [R0, #APB2ENR]

	BX LR

@extra function for change baud rate if clock speed is changed
set_baud_rate:
	LDR R0, =UART4 @change this uart base address to the uart will be used
	MOV R1, #0x1A1	@value given by calculation using f=8MHz, baud rate = 115200
	STRH R1, [R0, #USART_BRR]

	BX LR
