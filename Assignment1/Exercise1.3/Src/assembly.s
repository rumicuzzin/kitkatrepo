.syntax unified
.thumb

.global main

// Clock registers
.equ RCC, 0x40021000
.equ AHBENR, 0x14

// Relevant bits to enable GPIO
.equ GPIOA_ENABLE, 17
.equ GPIOE_ENABLE, 21

// Port A & E base address and mode selection
.equ GPIOA_BASE, 0x48000000
.equ GPIOE_BASE, 0x48001000
.equ MODER, 0x00

// Input and output registers for GPIO ports
.equ IDR, 0x10
.equ ODR, 0x14

.data @ data section, where variables are stored in memory.

byte_array_1: .byte 0,1,2,3,4,5,6,7 @ array of bytes with values 0,1,2,3,4,5,6,7
byte_array_2: .byte 0x01,0x23,0x45,0x67 @ array of bytes using hexadecimal values
word_array_1: .word 0x01234567 @ 32-bit word (4 bytes) with the value

.text
@ start of the code section

@ this is the entry function called from the startup file
main:

	LDR R0, =byte_array_1 @ Loads the memory address of byte_array_1 and word_array_1 into register R0.
	LDR R0, =word_array_1 @ Loads the memory address of word_array_1 into register R0.
 	@ Load the address of byte_array_1 first, then overwrite it with word_array_1.

	LDR R0, =0x1234
	LDR R1, =0x0002
 	@Loads immediate values into registers

forever_loop :

	ADD R0 , R1 @ adds R1 to R0 (R0 = R0 + R1)
	B forever_loop @ unconditional branch back to forever_loop.
