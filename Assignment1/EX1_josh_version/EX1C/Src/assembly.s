.syntax unified
.thumb

.global main

.data  @ Data section, where variables are stored in memory
.equ LC_LOWER, 0x41  @ ASCII value for 'A'
.equ LC_UPPER, 0x5A  @ ASCII value for 'Z'
.equ UC_LOWER, 0x61  @ ASCII value for 'a'
.equ UC_UPPER, 0x7A  @ ASCII value for 'z'
.equ ALPHA_SIZE, 26  @ Number of letters in alphabet
.equ SHIFT_VAL, 1    @ Define the cipher's shift value

string: .asciz "dog"  @ Define null-terminated string

.text  @ Start of code section

main:
    MOV R2, #SHIFT_VAL  @ Set the shift value

    @ Calculate absolute value and direction
    CMP R2, #0          @ Check if shift value is negative
    BGE positive_shift  @ Branch if shift is positive or zero
    NEG R2, R2          @ Get absolute value of shift
    MOV R1, #1          @ Set direction flag to 1 (backward)
    B normalize_shift

positive_shift:
    MOV R1, #0          @ Set direction flag to 0 (forward)

normalize_shift:
    @ Normalize shift to be within alphabet size
    CMP R2, #ALPHA_SIZE
    BLT process_string
    SUB R2, #ALPHA_SIZE
    B normalize_shift

process_string:
    MOV R3, #0          @ Initialize offset to 0
    LDR R4, =string     @ Load address of string into R4

char_loop:
    LDRB R0, [R4, R3]   @ Load byte at offset R3 into R0
    CMP R0, #0
    BEQ end             @ Exit if null terminator found

    @ Check if uppercase letter
    CMP R0, #LC_LOWER
    BLT next_char       @ Skip if below 'A'
    CMP R0, #LC_UPPER
    BLE shift_uppercase @ Branch if uppercase letter

    @ Check if lowercase letter
    CMP R0, #UC_LOWER
    BLT next_char       @ Skip if between 'Z' and 'a'
    CMP R0, #UC_UPPER
    BLE shift_lowercase @ Branch if lowercase letter
    B next_char         @ Skip if above 'z'

shift_uppercase:
    MOV R5, #LC_LOWER   @ Set lower bound for uppercase
    MOV R6, #LC_UPPER   @ Set upper bound for uppercase
    B perform_shift

shift_lowercase:
    MOV R5, #UC_LOWER   @ Set lower bound for lowercase
    MOV R6, #UC_UPPER   @ Set upper bound for lowercase

perform_shift:
    MOV R7, R2          @ Copy shift amount to working register
    CMP R1, #0
    BNE shift_backward  @ Branch based on direction flag

shift_forward:
    @ Shift character forward
    ADD R0, R0, R7      @ Apply shift
    CMP R0, R6          @ Check if past upper bound
    BLE store_char      @ If not, store character
    SUB R0, R0, #ALPHA_SIZE  @ Wrap around
    B store_char

shift_backward:
    @ Shift character backward
    SUB R0, R0, R7      @ Apply negative shift
    CMP R0, R5          @ Check if below lower bound
    BGE store_char      @ If not, store character
    ADD R0, R0, #ALPHA_SIZE  @ Wrap around

store_char:
    STRB R0, [R4, R3]   @ Store modified character back to string

next_char:
    ADD R3, R3, #1      @ Increment offset
    B char_loop         @ Continue with next character

end:
    MOV R0, #0          @ Return 0
    BX LR               @ Return from main function
