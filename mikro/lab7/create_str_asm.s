	.type create_str, @function
	.global create_str

 				#rdi, rsi, rdx - miejsca gdzie znajdują się kolejne argumenty
				#  rdx=(   | edx(32)  =(  |dx(16)= (dh | dl))) 
create_str:	


mov %rdi, %rax 
label:  
	cmp $0,%rsi
	jbe koniec
	    
	mov %dl, (%rdi)#przenosimy tam gdzie wskazuje rdi?
	inc %rdi		#zwiekszamy adres
	inc %rdx		#zwiekszamy znak
	dec %rsi		#zmiejszamy ile razy mial byc zapisamy
	jmp label

	
koniec:
	movb $0, (%rdi)
	ret
	
