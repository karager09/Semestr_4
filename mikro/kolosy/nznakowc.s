
	.text
	.type generate_str,@function
	.global generate_str


generate_str:
	

	MOV %rdi, %rax
	
	CMP $0,%rcx	#jak zero to robimy takie same znaki, jak nie to skaczemy
	JNZ zwiekszaj_znaki
	
loop:
	CMP $0,%rdx
	JZ end
	
	MOV %rsi, %rbx
	MOV %bl,(%rdi)
	INC %rdi
	
	DEC %rdx
	JMP loop

zwiekszaj_znaki:


loop2:
	CMP $0,%rdx
	JZ end
	
	MOV %rsi, %rbx
	MOV %bl,(%rdi)
	INC %rdi
	INC %rsi
	DEC %rdx
	JMP loop2	

end:
	MOVB $0, (%rdi)
	ret
