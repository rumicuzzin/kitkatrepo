.syntax unified
.thumb

.global main

#include "initialise.s"
#include "definitions.s"

.data
@define variables
string:.asciz "AEB"
.text

main:
	BL enable_peripheral_clocks
    BL initialise_discovery_board

	LDR R1 ,= string
	LDR R3, = GPIOE
	LDR R6, = GPIOA
	MOV R4, #0  @ count the number of vowels
	MOV R5, #0  @ count the number of consonants

count:
	LDRB R2, [R1], #1
	CMP R2, #0
	BEQ display_vowel
	CMP R2, #'A'
    BEQ increment_vowel
    CMP R2, #'E'
    BEQ increment_vowel
    CMP R2, #'I'
    BEQ increment_vowel
    CMP R2, #'O'
    BEQ increment_vowel
    CMP R2, #'U'
    BEQ increment_vowel
    CMP R2, #'a'
    BEQ increment_vowel
    CMP R2, #'e'
    BEQ increment_vowel
    CMP R2, #'i'
    BEQ increment_vowel
    CMP R2, #'o'
    BEQ increment_vowel
    CMP R2, #'u'
    BEQ increment_vowel

    CMP R2, #'A'
    BLT count
    CMP R2, #'z'
    BGT count
    CMP R2, #'Z'
    BLE increment_consonant
    CMP R2, #'a'
    BGE increment_consonant
    B count

increment_vowel:
 	ADD R4, R4, #1
 	B count

increment_consonant:
 	ADD R5, R5, #1
 	B count

display_vowel:

    STRB R4, [R3, #ODR +1]

wait_button_press:
    LDR R0, [R6, #IDR]
    TST R0, #1 << BUTTON_PIN
    BEQ wait_button_press

    BL display_consonant

display_consonant:
    STRB R5, [R3, #ODR +1]
    B display_consonant
