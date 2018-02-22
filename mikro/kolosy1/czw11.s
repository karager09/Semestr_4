
	.type check_div,@function
	.global check_div

check_div:


	CMP $0,%edx
	JNZ rozne_od_zera

	
	CDQ
	MOV %edi,%eax
	IDIV %esi				# %edx:%eax / %esi = %eax, r: %edx
	
	XOR %rax,%rax

	MOV %edx,%eax
	RET



rozne_od_zera:

	XOR %rdx,%rdx
	XOR %rsi,%rsi
	XOR %rbx,%rbx

	MOV $64,%esi
	MOV $63,%cl
	

	
	CDQ

	loop:

		MOV %edi, %eax
		IDIV %esi
		
		CMP $0,%edx
		JNZ niezero

		XOR %r8,%r8
		ADD $1,%r8
		
		SHL %cl,%r8

		ADD %r8,%rbx


niezero:

	XOR %edx,%edx
	DEC %esi
	DEC %cl
	CMP $0,%esi
	JA loop
	
	MOV %rbx,%rax

	RET
