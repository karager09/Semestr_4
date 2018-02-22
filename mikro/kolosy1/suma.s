	.type sum,@function
	.global sum

sum:

	MOV $0, %rax

	CMP %edi, %esi
	JGE loop

	XCHG	%rdi, %rsi

loop:

	CMP %edi, %esi
	JL koniec

	ADD %rdi, %rax
	INC %rdi
	JMP loop

koniec:
	RET
	




