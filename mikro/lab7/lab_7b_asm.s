#----------------------------------------------------------------
# Funkcja do programu lab_7b - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------

	.type fiba, @function
	.global fiba
	
				#chcemy sobie zwiększyć zakres do 128 bitów, przy dodawanu to ma sens (fibb), przy silni nie, bo przepełnienie i tak nastapi szybko
 				#nie musimy liczyć kilka razy jak rekurencyjnie, nie musimy zajmować się stosem 
				# działa duuuuuużo szybciej
 				
fiba:	push %rbx		#zapamiętujemy orginalną wartość

	mov $0, %rbx		#przenosimy wart do rejestrów
	mov $1, %rcx		#wartości początkowe ciągu fibb

	cmp %rbx, %rdi		#w rdi mamy k
	jz	f_0		#jak k=0 to skaczemy i zwracamy 0
	cmp %rcx, %rdi
	jz	f_1		#zwracamy 1 w etykiecie

next:
	mov %rbx, %rax		#jak nie to wykonjemy pętle, przenosimy rbx do rax
	add %rcx, %rax		# i wykonujemy dodawanie, w rax znajduje się teraz suma poprzednich
	mov %rcx, %rbx		#z rcx do rbx, przenosimy żeby mieć tak jak na początku, w rbx = k-1, w rcx= k
	mov %rax, %rcx		# z rax do rcx
	dec %rdi		#dekrementacja k
	cmp $1, %rdi		# czy powinniśmy liczyś dalej
	ja next			# jak nie to zwracamy co trzeba (jump above)

f_e:	pop %rbx		
	ret			#zwracamy warość rax

f_0:
	mov %rbx, %rax
	jmp f_e

f_1:
	mov %rcx, %rax
	jmp f_e
