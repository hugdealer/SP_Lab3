# -----------------------------------------------------------------------------
# A 64-bit Linux application that writes the first 90 Fibonacci numbers.
# It needs to be linked with a C library.
# To create object file using GNU assembler as
#	$as -gstabs fib.s -o fib.o
# To create an executable file after linking
#	$ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 fib.o -o fib -lc
# To execute fib
#	$./fib
# -----------------------------------------------------------------------------
	.global _start
	.data
		format: .asciz "%20ld\n"
	.text
_start:
		pushq %rbx		# we have to save this since we use it
		movq $90, %rcx		# ecx will countdown to 0
		xorq %rax, %rax		# rax will hold the current number
		xorq %rbx, %rbx		# rbx will hold the next number
		incq %rbx		# rbx is originally 1

# We need to call printf, but we are using rax, rbx, and rcx. Printf may
# destroy rax and rcx so we will save these before the call and restore
# them afterwards.
# Before calling printf(format, arg); - parameters are to be stored in
# registers as follows : format -> %rdi, arg -> %rsi, 0 -> %rax

print:		pushq %rax		# caller-save register
		pushq %rcx		# caller-save register
		movq $format, %rdi	# set 1st parameter (format)
		movq %rax, %rsi		# set 2nd parameter (current_number)
		xorq %rax, %rax		# because printf is varargs
	# Stack is already aligned because we pushed three 8 byte registers
		call printf		# printf(format, current_number)
		popq %rcx		# restore caller-save register
		popq %rax		# restore caller-save register
		movq %rax, %rdx		# save the current number
		movq %rbx, %rax		# next number is now current
		addq %rdx, %rbx		# get the new next number
		decq %rcx		# count down
		jnz print		# if not done counting, jump to print
		
		popq %rbx		# restore rbx before returning

		movq $60, %rax
		xorq %rdi, %rdi
		syscall

