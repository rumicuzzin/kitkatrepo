
	.syntax unified @ compatibility between ARM and Thumb instruction sets.
	.thumb @ thumb mode, 16-bit instructions

	.global main @ main as the entry point of execution

	.data @ data section, where variables are stored in memory.

	.text @


	@ this is the entry function called from the c file
	main:
		LDR R0, =0x1234
		LDR R1, =0x0001

	forever_loop:
		ADD R0, R1
		B forever_loop
