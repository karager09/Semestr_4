


.type gratest,@function
.global gratest

gratest:


	MOV %rdi,%rbx
	MOVL %ebx,%eax
	
	MOV %rsi, %rbx
	CMPL %ebx,%eax
	JGE niezam
	
	MOV %rsi,%rax

niezam:
	MOV %rdx, %rbx
	CMPL %ebx,%eax
	JGE niezam2

	MOV %rdx,%rax

niezam2:
	RET
