#----------------------------------------------------------------
# Program LAB_5.S - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_5.o lab_5.s
#  To link:    ld -o lab_5 lab_5.o
#  To run:     ./lab_5
#
#
#zamienia małe litery na wielkie i odwrotnie, i cyferki na znak #
#
#
#----------------------------------------------------------------


.equ	read_64,	0x00	# read data from file function
.equ	write_64,	0x01	# write data to file function
.equ	exit_64,	0x3C	# exit program function
.equ	stdout,	1
.equ	stdin,	0
.equ	stderr,	2



.equ	tooval,	-1
.equ	errval,	-2

	.data
	
buffer:			# buffer for file data
	.space		1024, 0
bufsize:		# size of buffer
	.quad		( . - buffer )
b_read:			# size of read data
	.quad		0
errmsg:			# file error message
	.ascii	"File error!\n"
errlen:
	.quad		( . - errmsg )
toomsg:			# file too big error message
	.ascii	"File too big!\n"
toolen:
	.quad		( . - toomsg ) 
promptmsg:
	.ascii	"String: "
promptlen:
	.quad		( . - promptmsg ) 
befmsg:
	.ascii	"Before:\n"
beflen:
	.quad		( . - befmsg ) 
aftmsg:
	.ascii	"After:\n"
aftlen:
	.quad		( . - aftmsg ) 

	.text
	.global _start
	
_start:
	NOP

	MOV	$write_64,%rax	# write function
	MOV	$stdout,%rdi	# file handle in RDI
	MOV	$promptmsg,%rsi	# RSI points to message
	MOV	promptlen,%rdx	# bytes to be written
	SYSCALL
	
	MOV	$read_64,%rax	# read function
	MOV	$stdin,%rdi	# file handle in RDI
	MOV	$buffer,%rsi	# RSI points to data buffer
	MOV	bufsize,%rdx	# bytes to be read
	SYSCALL

	CMP	$0,%rax
	JL	error		# if RAX<0 then something went wrong

	MOV	%rax,b_read	# store count of read bytes

	CMP	bufsize,%rax	# whole file was read ?
	JE	toobig		# probably not

	MOV	$write_64,%rax	# write function
	MOV	$stdout,%rdi	# file handle in RDI
	MOV	$befmsg,%rsi	# RSI points to message
	MOV	beflen,%rdx	# bytes to be written
	SYSCALL

	MOV	$write_64,%rax	# write function
	MOV	$stdout,%rdi	# file handle in RDI
	MOV	$buffer,%rsi	# offset to first character
	MOV	b_read,%rdx	# count of characters
	SYSCALL

	MOV	$buffer,%rsi
	MOV	%rsi,%rdi
	MOV	b_read,%rcx
	CLD
next:		#istnieje flaga kierunku, od niej zależy czy dodajemy(zwiekszamy,inkrementujemy) czy odejmujemy, jak 0 to rejestry są zwiększane, 1 - zmiejszane, o ile-zależy od danych
		      #CLD -clear direction- zmieniamy flage na 0, STD - zmieniamy znaczniek na 1
	LODSB			# al := MEM[ rsi ]; rsi++		load, s-string, b - więc bajt, więc al, #przenosi jeden bajt z rsi do rejestru al
	
	
	CMPB $'0',%al
	JB skip
	
	CMPB $'9',%al
	JBE cyfra
	#MOVB	$'#',%al
	
	
	CMPB	$'A', %al	#b-below, jak a jest większe to skaczemy i nie modyfikujemy zawartości
	JB skip
	CMPB	$'z', %al	#a-above, do modykikacji przechodzą litery od a do z. Inaczej skaczemy!
	JA skip			#------A___Z---a___z-----, tam gdzie "-" skaczemy
	
	CMPB	$'Z',	%al
	JBE	change	
 	
	CMPB	$'a',	%al
	JB	skip
	
	JMP change
	
cyfra:
	MOVB	$'#',%al
	JMP skip
change:		#zamiana małych na wielkie i odwrotnie za pomocą zmienienia tylko 5 bitu
 	#SUB	$32, %al	#odejmujemy 32, żeby uzyskać wielkie litery 
 	#AND	$0xDF,%al	#albo zerujemy 5 bit i to też zamieni, patrz- ASCII
 	
 	#możemy znieniać 5 bit, jeżeli wiemy, że to jest litera
 	XOR	$0x20,	%al	#zamieniamy wielkie na małe, i odwrotnie
skip:	STOSB			# MEM[ rdi ] := al; rdi++	#przenosi znak z al i daje go do rdi	#store-zapisanie danych, b-bite(1), w-word(2), long-4, q-8
	LOOP next

	MOV	$write_64,%rax	# write function
	MOV	$stdout,%rdi	# file handle in RDI
	MOV	$aftmsg,%rsi	# RSI points to message
	MOV	aftlen,%rdx	# bytes to be written
	SYSCALL

	MOV	$write_64,%rax	# write function
	MOV	$stdout,%rdi	# file handle in RDI
	MOV	$buffer,%rsi	# offset to first character
	MOV	b_read,%rdx	# count of characters
	SYSCALL

	MOV	b_read,%rdi
	JMP	theend

toobig:
	MOV	$write_64,%rax	# write function
	MOV	$stderr,%rdi	# file handle in RDI
	MOV	$toomsg,%rsi	# RSI points to toobig message
	MOV	toolen,%rdx	# bytes to be written
	SYSCALL
	MOV	$tooval,%rdi
	JMP	theend

error:
	MOV	$write_64,%rax	# write function
	MOV	$stderr,%rdi	# file handle in RDI
	MOV	$errmsg,%rsi	# RSI points to file error message
	MOV	errlen,%rdx	# bytes to be written
	SYSCALL
	MOV	$errval,%rdi

theend:
	MOV	$exit_64,%rax	# exit program function
	SYSCALL
