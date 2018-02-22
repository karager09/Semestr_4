.data
	
tablica:
	.quad 0

negcount:
	.quad 0

evencount:
	.quad 0

.text
	.type max_1_ind,@function
	.global max_1_ind

	#.type czyparzysta,@function

max_1_ind:
	
	#MOV %rdx, evencount	


	MOV %rdi,tablica
	#XOR %rdi, %rdi
	
	MOV %rcx, negcount
	MOV %rsi, %rcx

	XOR %rbx, %rbx
	
loop:

	MOV (%rdi),%rax
	JMP czyparzysta
wroc:
	INC %rdi

	LOOP loop

	MOV evencount, %rbx
	MOV %rbx,(%rdx)
RET

czyparzysta:	#liczbe otrzymujemy w rax

	AND $0x01,%rax 	

	CMP $0,%al
	JNZ wroc
	INCQ evencount
	JMP wroc
