#The following program reads a string from keyboard, stores it in memory
#starting at location givenstr and then takes each uppercase alphabet in
#that string and converts it to its lowercase alphabet and stores it in memory
#at location lowerstr :
# To create object file using GNU assembler as
#	$as -gstabs upper2lower.s -o upper2lower.o
# To create an executable file after linking
#	$ld upper2lower.o -o upper2lower
# To execute upper2lower
#	$./upper2lower
	.global _start
	.data
		message:.asciz "ENTER A STRING :"
		givenstr: .skip 100
		lowerstr: .space 100
	.text
_start:		movq $1, %rax		#sys_write
		movq $1, %rdi
		movq $message, %rsi
		movq $16, %rdx
		syscall

		movq $0, %rdi		#sys_read
		movq $givenstr, %rsi
		movq $100, %rdx
		movq $0, %rax
		syscall

		movq %rax, %r8
		movq %r8, %rcx
		decq %rcx
		movq $givenstr, %rsi
		movq $lowerstr, %rdi
up:		movb (%rsi), %al
		cmp $65, %al
		jl down1
		cmp $90, %al
		jg down1
		addb $32, %al
down1:		movb %al, (%rdi)
		incq %rsi
		incq %rdi
		decq %rcx
		jnz up
		movb (%rsi), %al
		movb %al, (%rdi)

		movq $1, %rax
		movq $1, %rdi
		movq $lowerstr, %rsi
		movq %r8, %rdx
		syscall

		movq $60, %rax
		xorq %rdi, %rdi
		syscall
