# -----------------------------------------------------------------------------
# A 64-bit Linux application that writes the first n Fibonacci numbers.
# The input value n is to be read from the keyboard.
# Functions called : puts, scanf, printf
# This routine needs to be linked with C library functions
# To create object file using GNU assembler as
#	$as -gstabs fibio.s -o fibio.o
# To create an executable file after linking
#	$ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 fibio.o -o fibio -lc
# To execute fibio
#	$./fibio
#-----------------------------------------------------------------------------
	.global _start
	.data
		message:	.asciz "ENTER A VALUE FOR n :"		# asciz puts a 0 byte at the end
		format: 	.asciz "%20ld\n"
		format1:	.asciz "THE LIST OF FIRST n=%8ld FIBONACCI NUMBERS\n"
		f: 		.string "%d"
		x:		.quad 0
	.text
_start:
		pushq %rbx		# save this register content since we will use it

	# To call C function puts(message pointer); first store message pointer in #
	# register %rdi as follows message pointer -> %rdi

		movq $message, %rdi	#message address (or pointer) parameter in %rdi
		call puts		# puts(message)

	# READ VALUE OF n FROM KEYBOARD AND STORE IT IN MEMORY LOCATION x
		pushq %rbp
	# To call C function scanf(format, &x); put the parameters in registers
	# as follows #format -> %rdi, &x -> %rsi, 0 -> %rax

		movq $0, %rax
		movq $f, %rdi		# put scanf 1st parameter (format f - see .data section) in %rdi
		movq $x, %rsi		# put scanf 2nd parameter (pointer to location x - see .data section) in %rsi
	# value n read from keyboard will be stored in location x
		call scanf		# scanf(f, pointer x)
		popq %rbp

	# PRINT VALUE OF n in x on the screen
		movq x, %rax 		# %rax <- n , i.e. Contents of memory location x
		pushq %rax		# caller-save register
		pushq %rcx		# caller-save register
	# To call C function printf(format, arg); put the parameters in registers as
	# follows format -> %rdi, arg -> %rsi, 0 -> %rax

		movq $format1, %rdi 	# put printf 1st parameter (format1 - see .data section) in %rdi
		movq %rax, %rsi 	# put printf 2nd parameter ( n ) in %rsi, n is the value to be printed
		xorq %rax, %rax
		call printf		# printf(format1, current_number)
		pop %rcx		# restore caller-save register
		pop %rax		# restore caller-save register

	#COMPUTING FIBONACCI NUMBERS
		movq %rax, %rcx		# rcx will countdown to 0
		xorq %rax, %rax		# rax will hold the current number
		xorq %rbx, %rbx		# rbx will hold the next number
		incq %rbx		# rbx is originally 1
	# We need to call printf, but we are using eax, ebx, and ecx. printf may
	# destroy eax and ecx so we will save these before the call and restore them
	# afterwards
		
	print:
		push %rax		# caller-save register
		push %rcx		# caller-save register
		movq $format, %rdi	# put printf 1st parameter (format1 - see .data section) in %rdi
		movq %rax, %rsi		# put printf 2nd parameter (current_number - currently generated

	# Fibonacci number ) in %rsi; currently generated fibonacci number is the
	# value to be printed

		xorq %rax, %rax
		call printf		# printf(format, current_number)
		pop %rcx		# restore caller-save register
		pop %rax		# restore caller-save register
		movq %rax, %rdx		# save the current number
		movq %rbx, %rax		# next number is now current
		addq %rdx, %rbx		# get the new next number
		decq %rcx		# count down
		jnz print		# if not done counting, jump to print
		pop %rbx		# restore rbx before returning to operating system
		
		movq $60, %rax		# syscall to return 0
		xorq %rdi, %rdi
		syscall
