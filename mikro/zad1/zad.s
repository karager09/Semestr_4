

.text
.type check_tab, @function
.global check_tab


check_tab:
	 
	 PUSH %rbp
	MOV %rsp, %rbp
	MOVQ %rdi, -8(%rbp)
	MOVQ %rsi, -16(%rbp)
	MOVQ %rdx, -24(%rbp)
	
	
loop1:
	movq	(%rdi),%r10
	movq	%r10, (%rdx)
	cmpq 	$63, %r10
	ja 		bits
	cmpq 	$0, %r10
	jl 		bits
	
	
	addq $4, %rdi
	
	decq %rsi
	cmp $1, %rsi
	jnz loop1
	
	
no_bits:
	movq	$8, %r8
	movq 	%r8,(%rdx)
	movq 	$5, %rax
	jmp end
bits:
	movq	$1, %r8
	movq 	%r8,(%rdx)
	movq 	$6, %rax
end:
	MOV %rbp, %rsp
	pOP %rbp
	ret
