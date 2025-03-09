.syntax unified
.thumb

@Function prototypes
.global main

.global convert_to_lowercase
.global convert_to_uppercase
.global next_character
.global check_state_upper
.global check_state_lower
.global done

.data	@Define needed variables

Ascii_string: .asciz "LoloLO!" @Define null terminated string

.equ state, 0x1 				@Define constant state to take values 1 or 0
								@0 for lower to upper 1 for upper to lower
.text

main:
	LDR R1, = Ascii_string 		@Load address of string
	LDR R2, = state				@Load state value
	MOV R4, #0					@Load 0 as starting increment value (int i = 0)


	@For loop to go through string
	string_loop:
		LDRB R3, [R1, R4]		@Load first ascii character
		CMP R3, #0				@Check for null terminator
		BEQ done				@Exit if null

		CMP R3, #0x41			@Check for letters, less than 0x41 not relevant
		BLT next_character		@Loop to next character

		CMP R3, #0x5A			@Check if uppercase, 0x41 < R3 < 0x5A
		BLE check_state_lower	@Check state value

		CMP R3, #0x61			@Check for letters, 0x5A < R3 <0x60 not relevant
    	BLT next_character		@Loop to next character

   		CMP R3, #0x7A			@Check if lowercase, #0x61 < R3 < #0x7A
    	BLE check_state_upper 	@Check state value

    	BX LR

next_character:
    ADD R4, #0x1				@Increment by 1
    B string_loop				@Loop back to string loop

@Functions to check state value
check_state_lower:
	CMP R2, #0					@Check state value
	BEQ convert_to_lowercase	@state == 0, convert lowercase
	B next_character			@Otherwise go to next char

check_state_upper:
	CMP R2, #1					@Check state value
	BEQ convert_to_uppercase	@state == 1, convert uppercase
	B next_character			@Otherwise go to next char

@Character conversion functions
convert_to_lowercase:
	ADD R3, #0x20           	@Convert upper to lower
    STRB R3, [R1, R4]           @Store new char
    B next_character			@Loop to next character

convert_to_uppercase:
	SUB R3, #0x20				@Convert lower to upper
	STRB R3, [R1, R4]			@Store new char
    B next_character			@Loop to next character

done:
	BX LR						@Return - quit program
