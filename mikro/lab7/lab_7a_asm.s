#----------------------------------------------------------------
# Funkcja do programu lab_7a - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

# Silnia obliczona iteracyjnie

	.text
	.type facta, @function
	.globl facta	

facta:	mov $1, %rax		#umieszczamy w rax wartość 1 (jak nie liczymy to od razu zrwócimy)

next:	cmp $1, %rdi		#w pętli - sprawdzamy wartość parametru - jak <2 skaczemy poza pętle
	jbe f_e			
	mul %rdi		#mnozymy  rax * rdi  = rax
	dec %rdi		# zmiejszamy rdi
	jmp next		#skaczemy na początek

f_e:	ret			#zwracamy na zewnątrz rax

