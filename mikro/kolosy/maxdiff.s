

.type max_diff,@function
.global max_diff

max_diff:

	
	MOV %rdi,%rax
	
	CMP %rsi,%rax
	JGE niezam1

	MOV %rsi, %rax

niezam1:

	CMP %rdx,%rax
	JGE niezam2

	MOV %rdx,%rax

niezam2:
	
	CMP %rcx,%rax
	JGE niezam3

	MOV %rcx,%rax

niezam3:


	MOV %rdi,%rbx
	
	CMP %rsi,%rbx
	JLE niez1

	MOV %rsi, %rbx

niez1:

	CMP %rdx,%rbx
	JLE niez2

	MOV %rdx,%rbx

niez2:
	
	CMP %rcx,%rbx
	JLE niez3

	MOV %rcx,%rbx

niez3:
	
	SUB %rbx,%rax

	RET
