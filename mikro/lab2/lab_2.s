#----------------------------------------------------------------
# Program lab_2.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_2.o lab_2.s
#  To link:    ld -o lab_2 lab_2.o
#  To run:     ./lab_2
#


#----------------------------------------------------------------

	.equ	write_64, 1	#write data to file function
	.equ	exit_64, 60	#exit program function
	.equ	stdout, 1 	#handle to stdout

	.data
	
arg1txt:
	.ascii	"Arg1 = "
arg2txt:
	.ascii	"Arg2 = "
sumtxt:
	.ascii	"Sum  = "
difftxt:
	.ascii	"Diff = "
ortxt:
	.ascii	"OR   = "
andtxt:
	.ascii	"AND  = "
xortxt:
	.ascii	"XOR  = "
arg1:				#first argument
	.byte	0xA0
arg2:				#second argument
	.byte	0x05
result:				#result
	.byte	0
tmp:
	.byte	0
restxt:
	.ascii	"  \n"
txtlen:
	.quad	7		#quad - 8 bajtów
reslen:
	.quad	3
 
	.text
	.global _start
	
_start:
	NOP

	MOVB	arg1,%al
	MOV	$arg1txt,%rsi		#wypisanie, jaką operacje wykonywaliśmy 
	CALL	disp_line	#używanie funkcji

	NOP

	MOVB	arg2,%al
	MOV	$arg2txt,%rsi
	CALL	disp_line

	NOP

	MOVB	arg1,%al
	ADDB	arg2,%al
	MOVB	%al,result
	MOV	$sumtxt,%rsi
	CALL	disp_line

	NOP

	MOVB	arg1,%al
	SUBB	arg2,%al
	MOVB	%al,result
	MOV	$difftxt,%rsi
	CALL	disp_line

	NOP

	MOVB	arg1,%al
	ORB	arg2,%al
	MOVB	%al,result
	MOV	$ortxt,%rsi
	CALL	disp_line

	NOP

	MOVB	arg1,%al
	ANDB	arg2,%al
	MOVB	%al,result
	MOV	$andtxt,%rsi
	CALL	disp_line

	NOP

	MOVB	arg1,%al
	XORB	arg2,%al
	MOVB	%al,result
	MOV	$xortxt,%rsi
	CALL	disp_line

	NOP

	MOV	$exit_64,%rax
	XOR	%rdi,%rdi 
	SYSCALL

#----------------------------------------------------------------
# disp_line - displays line of text (prompt + hexadecimal number)
#----------------------------------------------------------------

	.type disp_line,@function  #jak kompilujemy to uzupełniamy tablice o info co to za symbol, funkcja

disp_line:		#definujemy funkcje, wyślwietla tekst w postaci linijki tekstu, zamieniamy liczby na znak i wyświetlamy obie
	MOVB	%al,tmp		#wywołanie funkcji systemowej write

	MOV	$write_64,%rax		#wyświetla działanie, jaka funkcja
	MOV	$stdout,%rdi		# gdzie się ma wypisać
	MOV	txtlen,%rdx		# długość ciągu do wypisania, w rdx - ilość znaków jakie mają zostać wyświetlone,rdx - 8 bajtów, czyli przenosimy z txtlen 8 bajtów
	SYSCALL

	MOVB	tmp,%al		# %al- liczba którą chcemy zamienić
	ANDB	$0x0F,%al
	CMPB	$10,%al
	JB	digit1
	ADDB	$('A'-10),%al
	JMP	insert1
digit1:
	ADDB	$'0',%al
insert1:
	MOV	%al,%ah

	MOVB	tmp,%al
	SHR	$4,%al
	CMPB	$10,%al
	JB	digit2
	ADDB	$('A'-10),%al
	JMP	insert2
digit2:
	ADDB	$'0',%al
insert2:
	MOVW	%ax,restxt	# MOVW	%ax,$restxt- dwa bajty, probowaliśmy zmienić adres, bez dolara- żeby zmienić wartość

	MOV	$write_64,%rax		
	MOV	$stdout,%rdi
	MOV	$restxt,%rsi		
	MOV	reslen,%rdx
	SYSCALL

	RET  #działanie funkcji jest kończone, wracamy do miejsca w którym było wywołanie
	
