#----------------------------------------------------------------
# Funkcja do programu lab_6a - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

#funkcja pobiera z rdi argumenty i sprawdza jeje wartość
#zwracana wartość w rax

#rejestr rsp - tam są odkładane rzeczy na stos

#wszystko mniej więcej to samo co w C
	.text
	.type facta, @function
	.globl facta	

facta:	mov $1, %rax		# 1 do rax

	cmp %rax, %rdi		#porównujemy 1 z argumentem
	jbe f_e			#jak mniejsze albo = to skaczemy

	push %rdi		#zapamiętujemy rdi

	dec %rdi		#zmiejszamy
	call facta		#wywołujemy ze zmiejszonym argumentem, obliczamy silnie dla mniejszego argumentu

	pop %rdi		#pobieramy to co było

	mul %rdi		#mnożymy (wynik w rax?)

f_e:	ret		#wracamy na adres który jest pierwszy na stosie, return

