#----------------------------------------------------------------
# Funkcja do programu lab_6b - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

	.type fiba, @function
	.globl fiba		#ciąg fibbonaciego, zmienne lokalne przechowujemy na stosie (rej. rsp)

fiba:	push %rbp		#rej. %rbp, ułatwia prace ze stosem, #rbp ląduje na stosie 
	mov %rsp,%rbp		#rbp wskazuje na rsp, a ono na stare rbp, rsp się zmieni, a rbp będzie wskazywało na stare rbp

	sub $8,%rsp		#rsp przesuwamy o 8, tam będzie nasza zmienna lokalna

	cmp $0, %rdi
	jz f_0

	cmp $1, %rdi
	jz f_1

	push %rdi		#zapamiętujemy rdi

	sub $2,%rdi		#odejmujemy od niego 2
	call fiba		#wywołujemy rekurencyjnie
	mov %rax,-8(%rbp)		#wsakuzjemy na zmienną lokalną

	pop %rdi

	dec %rdi
	call fiba
	add -8(%rbp),%rax

f_e:	mov %rbp,%rsp
	pop %rbp
	ret

f_0:
	mov $0, %rax
	jmp f_e

f_1:
	mov $1, %rax		#rezultat w rax
	jmp f_e
