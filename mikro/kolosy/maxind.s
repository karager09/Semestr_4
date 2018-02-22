.type max_ind,@function
.global max_ind

max_ind:

	MOV %rdi,%rbx
	MOV $1,%rax

	CMPL %esi,%ebx
	JG niezam1
	JE takiesame1	
	
	MOV %rsi,%rbx
	MOV $2,%rax
	
	JMP niezam1

takiesame1:
	MOV $0,%rax

niezam1:


	CMPL %edx,%ebx
	JG niezam2
	JE takiesame2
	
	MOV %rdx,%rbx
	MOV $3,%rax

	JMP niezam2

takiesame2:
	MOV $0,%rax

niezam2:


	CMPL %ecx,%ebx
	JG niezam3
	JE takiesame3
	
	MOV %rcx,%rbx
	MOV $4,%rax

	JMP niezam3

takiesame3:
	MOV $0,%rax

niezam3:


	RET


