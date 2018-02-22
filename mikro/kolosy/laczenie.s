

	.type fun,@function
	.global fun

fun:
	MOV %rdi, %rax

pierwsze:
	CMPB $0,(%rsi)
	JZ drugie

	MOV (%rsi),%rcx	#przenosimy znak z pierwszego ciągu
	MOV %cl, (%rdi)
	INC %rsi
	INC %rdi

	CMPB $0,(%rdx)		#jak drugi ciąg nie istnieje
	JZ pierwsze

	#MOV %dl, (%rdi)
	MOV (%rdx), %rcx
	MOV %cl, (%rdi)
	INC %rdx
	INC %rdi

	JMP pierwsze

drugie:
	CMPB $0, (%rdx)
	JZ end

	#MOV %dl, (%rdi)
	MOV (%rdx), %rcx
	MOV %cl, (%rdi)
	INC %rdx	
	INC %rdi
	
	JMP drugie

end:
	MOV $0,%rdi
	RET
