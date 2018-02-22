#----------------------------------------------------------------
# Program lab_8.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
# To compile:	as -o lab_8.o lab_8.s
# To link:	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o lab_8 lab_8.o
# To run:	./lab_8
#
#----------------------------------------------------------------


 #pokazuje argumenty które przekazaliśmy i zmienne środowiskowe(w stringu "nazwa=wartosc")


	.data
argc_s:
	.asciz "argc = %d\n"
args_s:
	.asciz "%s\n"
sep_s:
	.asciz "----------------------------\n"
argc:			#liczba arg
	.quad 0
argv:			#
	.quad 0
env:			#srodowiskowe
	.quad 0
argc_tmp:		#wykorzystamy jako licznik pętli
	.quad 0

	.text
	.global _start

_start:

	mov (%rsp), %rax	# argc is here,		rsp - wskaźnik stosu, zawartość tego miejsca umieszczamy w rax (rsp na wierzchołek)
	mov %rax, argc		# store value of argc		,nadajemy wartości zmiennym
	mov %rax, argc_tmp

	mov $argc_s,%rdi		#adres lancucha formatujacego
	mov argc, %rsi			#liczba, czyli jakby zmienne w printfie w C
	mov $0, %al			#niejawny argument w al, pokazuje ze wszystko co ma wyświetlić to liczby całkowite lub wskaźniki
	call printf		# display value of argc,	pokazujemy ile jest zmiennych

	mov %rsp, %rbx		# use rbx as a pointer
	add $8, %rbx		# argv[] is here,		zeby wskazywał na następna wartość
	mov %rbx, argv		# store address of argv[]	

next_argv:		#petla (for)

	mov $args_s, %rdi
	mov (%rbx), %rsi
	mov $0, %al
	call printf		# display value of argv[i]		#w rax wartość zwracana przez printfa

	add $8,%rbx		# address of argv[i+1]		#znowu kolejny element

	decq argc_tmp		#zmiejszamy licznik pętli, wykorzystujemy zmienną nie rejestr jako licznik (bo nie wiemy jaki możemy,a wcale nie jest dużo szybciej)
	jnz next_argv		#jak nie zero to skaczemy

	mov $sep_s, %rdi	#wyświetlenie separatora
	mov $0, %al
	call printf		# display separator

	add $8, %rbx		# env[] is here - skip zero/NULL, omijamy NULLa
	mov %rbx, env		# store address of env[]

next_env:		#kolejna pętla (while), do odczytu środowiska, ale musimy sprawdzać czy nie jest NULLem
	cmp $0,(%rbx)		# is env[i] == NULL
	je finish		# yes

	mov $args_s, %rdi
	mov (%rbx), %rsi	# no
	mov $0, %al
	call printf		# displays value of env[i]

	add $8,%rbx		# address of env[i+1]
	jmp next_env

finish:
	mov $0,%rdi		# this is the end...
	call exit

