	.type sum3as, @function
	.global sum3as

 				#rdi, rsi, rdx - miejsca gdzie znajdują się kolejne argumenty
sum3as:	
	mov %rdx, %rax
	add %rdi, %rax
	add %rsi, %rax

	
	ret			#zwracamy warość rax
