@Terminating character
.equ NULL, 0x0

@Base register for resetting and clock settings
.equ RCC, 0x40021000	@RCC address
.equ AHBENR, 0x14		@RCC clock enable register
.equ APB1ENR, 0x1C		@Peripheral bus 1 clock enable
.equ APB2ENR, 0x18		@Peripheral bus 2 clock enable
.equ AFRH, 0x24			@GPIO alternate function high register
.equ AFRL, 0x20			@GPIO alternate function low register
.equ RCC_CR, 0x00 		@Control clock register
.equ RCC_CFGR, 0x04 	@Configure clock register

@Base address for UARTs
.equ UART4, 0x40004C00
.equ UART5, 0x40005000

@Specific bit to enable UART4
.equ UART4_EN, 19

@ register addresses and offsets for general UARTs
.equ USART_CR1, 0x00
.equ USART_BRR, 0x0C
.equ USART_ISR, 0x1C @UART status register offset
.equ USART_ICR, 0x20 @UART clear flags for errors

.equ UART_TE, 3		@Transmit enable bit
.equ UART_RE, 2		@Teceive enable bit
.equ UART_UE, 0		@Enable bit for the whole UART
.equ UART_ORE, 3 	@Overrun flag
.equ UART_FE, 1 	@Frame error

.equ UART_ORECF, 3 	@Overrun clear flag
.equ UART_FECF, 3 	@Frame error clear flag


@ different UARTs use different GPIOs for the pins
.equ GPIOA, 0x48000000	@Base register for GPIOA (pa0 is the button)
.equ GPIOC, 0x48000800	@Base register for GPIOA (pa0 is the button)

.equ GPIOA_ENABLE, 17	@Enable bit for GPIOA
.equ GPIOC_ENABLE, 19	@Enable bit for GPIOC

.equ GPIO_MODER, 0x00	@Mode for the GPIO
.equ GPIO_OSPEEDR, 0x08	@Speed for the GPIO

@Button related
.equ IDR, 0x10			@Input read register
.equ BUTTON_PIN, 0x00

@ transmitting and receiving data
.equ UART_TXE, 7		@Transmit status
.equ USART_TDR, 0x28	@Transmit register new byte is ready to read

.equ UART_RXNE, 5		@ a new byte is ready to read
.equ USART_RDR, 0x24	@ a new byte is ready to read
.equ USART_RQR, 0x18
.equ UART_RXFRQ, 3		@ a new byte is ready to read
