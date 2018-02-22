#----------------------------------------------------------------
# Program lab_1.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_1.o lab_1.s
#  To link:    ld -o lab_1 lab_1.o
#  To run:     ./lab_1
#
#----------------------------------------------------------------

	.equ	write_64, 1	# write data to file function (64bit)
	.equ	exit_64, 60	# exit program function (64bit)
	.equ	stdout, 0x01	# handle to stdout, nazwa symboliczna i jej wartość, może być 2*3 np. kompilator obliczy

	.data
	
starttxt:			# first message
	.ascii	"Start\n"
endtxt:				# second message
	.ascii	"Finish\n"
arg1:				# first argument
	.byte		1
arg2:				# second argument, dwa bajty
	.word		2
arg3:				# third argument, 4 bajty, quad - 8 bajtów
	.long		3
result:				# result
	.long		0	

	.equ	startlen, endtxt - starttxt	#określa wielkość obszaru w bajtach, czyli długość ciągu znaków dla "startu"
	.equ	endlen, arg1 - endtxt		#długość "Finish", zmienne sa ustawiane po kolei
 
	.text
	.global _start
	
_start:
	MOV	$write_64,%rax		#przenosimy funkcje do rejestru (rax-64, eax-32 bity), rax- akumulator
	MOVQ	$stdout,%rdi		# r8-r15, dodatkowe rejestry, rdi - rejestr przeznaczenia
	MOV	$starttxt,%rsi		#też przenosimy do innych rejestrów, - rejestr źródła
	MOVQ	$startlen,%rdx
	SYSCALL

	NOP

	XOR	%eax,%eax 		#zerujemy rejestr, bo rejestr-4 bajty, a to 1 bajt
	XOR 	%ebx,%ebx
	MOV	arg1,%eax		#umieszczamy w rejestrach
	MOV	arg2,%ebx
	MOVL	arg3,%ecx
	ADD	%ebx,%eax		#dodawanie, 1-argument źrówdłowy, 2- miejsce w którym jest drugi argument i ma być wynik, utrata jednego z argumentów
	SUB	%ecx,%eax		#odejmowanie, eax=eax-ecx, eax-=ecx
	MOVL	%eax,result		#result = arg1+ebx-ecx

	NOP

	MOV	$write_64,%rax
	MOVQ	$stdout,%rdi
	MOV	$endtxt,%rsi
	MOVQ	$endlen,%rdx
	SYSCALL				#wywołanie funkcji systemowej

	NOP

theend:
	MOV	$exit_64,%rax
	SYSCALL

