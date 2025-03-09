.syntax unified
.thumb

@Function prototypes
.global main
.global find_end
.global found_end
.global check_palindrome
.global palindrome_false
.global palindrome_true

.data	@Define needed variables

palindrome_string: .asciz "racecar" @Define null terminated string

.text

main:
	LDR R1, = palindrome_string		@Load address of string
	MOV R2, #0						@End index value
	MOV R3, #0						@Start index value

	check_palindrome_loop:

		BL find_end					@Function call to find length of

		BL check_palindrome			@Function call to check if palindrome

		BX LR						@Exit

find_end:
	LDRB R4, [R1, R2]				@Load char from string
    CMP R4, #0						@Check for null character
    BEQ found_end           		@If null, end of string found
    ADD R2, #1           			@Else continue to parse through string
    B find_end

found_end:
    SUB R2, #1						@Length of string is n - 1 due to null character
	BX LR							@Return to main function call

check_palindrome:
    CMP R2, R3               		@Check for when end is less than or equal to start
    BLE palindrome_true      		@If it is, palindrome confirmed

    LDRB R5, [R1, R3]        		@Load starting char
    LDRB R6, [R1, R2]        		@Load end char
    CMP R5, R6               		@Compare for equivalence
    BNE palindrome_false    		@If not equal, not plaindrome

    ADD R3, #1           			@Start + 1
    SUB R2, #1           			@End - 1
    B check_palindrome      		@Loop again

palindrome_false:
    MOV R0, #0               		@Set R0 as result register
    BX LR                   		@R0 = 0, not palindrome

palindrome_true:
    MOV R0, #1               		@R0 = 1, is palindrome
    BX LR
