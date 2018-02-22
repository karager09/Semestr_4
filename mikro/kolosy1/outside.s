	.type is_outside,@function
	.global is_outside

is_outside:

				#szukamy maxa
	PUSH %rbx

	MOV %rdi, %rbx
	
	CMP %esi, %ebx
	JGE  niezmieniamy

	MOV %rsi, %rbx

niezmieniamy:

	CMP %edx, %ebx
	JGE szukajdalej

	MOV $1,%rax
	POP %rbx
	RET
	
szukajdalej:		#szukamy min

	MOV %rdi, %rbx
	
	CMP %esi, %ebx
	JLE niezmieniamy2

	MOV %rsi, %rbx

niezmieniamy2:
	
	CMP %ebx, %edx
	JL mniejsze

	MOV $0, %rax
	POP %rbx
	RET

mniejsze:

	MOV $-1, %rax
	POP %rbx
	RET






