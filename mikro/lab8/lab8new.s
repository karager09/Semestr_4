#----------------------------------------------------------------
# Program lab_8.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
# To compile:	as -o lab_8.o lab_8.s
# To link:	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o lab_8 lab_8.o
# To run:	./lab_8
#
#----------------------------------------------------------------

#chcemy użyć gcc do kompilacji i linkowania,   gcc -o lab8new lab8new.s
#pokazuje argumenty które przekazaliśmy i zmienne środowiskowe(w stringu "nazwa=wartosc")

#jak kompilkujemy gcc to nie działa, trafiamy w inne dane, na stosie cos sie pojawiło
#zmiana pktu startowego, uruchamiany jest kawałek kodu, który nie my stworzyliśmy i dopiero później jest wywoływane main
#dlatego na wierzchołu stosu pojawia się adres powrotu po zakończeniu maina
#gcc dołącza kod, co dodaje do stosu różne rzeczy 

#tym razem dostajemy zmienne w rejestrach: liczba arg-rdi, argumenty-rsi, zm. srodowiskowe - rdx
#rbp, rbx, r12-r15 - tych nie powinniśmy zmieniać


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
	.global main	#tu też zmieniamy

main:		#zmieniamy na main

	
	#mov (%rsp), %rax	# argc is here,		rsp - wskaźnik stosu, zawartość tego miejsca umieszczamy w rax (rsp na wierzchołek)
	mov %rdi, argc		# store value of argc		,nadajemy wartości zmiennym
	mov %rdi, argc_tmp
	mov %rsi, argv
	mov %rdx, env
	
	mov $argc_s,%rdi		#adres lancucha formatujacego
	mov argc, %rsi			#liczba, czyli jakby zmienne w printfie w C
	mov $0, %al			#niejawny argument w al, pokazuje ze wszystko co ma wyświetlić to liczby całkowite lub wskaźniki
	call printf		# display value of argc,	pokazujemy ile jest zmiennych

	#mov %rsp, %rbx		# use rbx as a pointer
	#add $8, %rbx		# argv[] is here,		zeby wskazywał na następna wartość
	#mov %rbx, argv		# store address of argv[]	

	mov argv, %rbx
	
next_argv:		#petla (for)

	mov $args_s, %rdi
	mov (%rbx), %rsi
	mov $0, %al
	call printf		# display value of argv[i]		#w rax wartość zwracana przez printfa

	add $8,%rbx		# address of argv[i+1]		#znowu kolejny element

	decq argc_tmp		#zmiejszamy licznik pętli, wykorzystujemy zmienną nie rejest jako licznik (bo nie wiemy jaki możemy,a wcale nie jest dużo szybciej)
	jnz next_argv		#jak nie zero to skaczemy

	mov $sep_s, %rdi	#wyświetlenie separatora
	mov $0, %al
	call printf		# display separator

	#add $8, %rbx		# env[] is here - skip zero/NULL, omijamy NULLa
	#mov %rbx, env		# store address of env[]
	mov env, %rbx
	
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
	call exit		#przerywamy, bez powrotu, dlatego nie ma problemu z efektami dziwnymi bo zmieniliśmy rbx, którego nie powinniśmy

