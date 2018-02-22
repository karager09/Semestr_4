

.data

ciag:
	.string "Cos tam sobie wypisalem\n"
dlugosc:
	.quad ( . - ciag)


.text
.global _start


_start:

MOV $1, %rax
MOV $1, %rdi
MOV $ciag, %rsi
MOV dlugosc, %rdx
SYSCALL

	PUSH %rbx

	MOV $ciag,%rbx

loop:
	MOV $1, %rax
	MOV $1, %rdi
	MOV %rbx, %rsi
	MOV $1, %rdx
	SYSCALL

	INC %rbx
	
	CMP $0,(%rbx)
	JNZ loop

	POP %rbx

MOV $60, %rax
SYSCALL





