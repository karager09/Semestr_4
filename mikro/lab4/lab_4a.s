#----------------------------------------------------------------
# Program lab_4a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_4a.o lab_4a.s
#  To link:    ld -o lab_4a lab_4a.o
#  To run:     ./lab_4a
#
#
#
#
#
#
#----------------------------------------------------------------

	.equ	create_64,	0x55	# create file function
	.equ	close_64,	0x03	# close file function
	.equ	write_64,	0x01	# write data to file function
	.equ	exit_64,	0x3c	# exit program function

	.equ	mode,	0x1FF	# attributes for file creating, prawa dostępu, jak rozpiszemy bitowo to widać jakie są, ale jest jeszcze maska! iloczyn logiczny z zanegowaną maską
	.equ stderr,	2
	.equ	errval,	2

	.data
	
file_n:				# file name (0 terminated)
	.string	"testfile.txt"

file_h:				# file handle
	.quad		0

txtline:			# text to be written to file
	.ascii	"A line of text\n"

txtlen:				# size of written data
	.quad		( . - txtline )

errmsg:				# file error message
	.ascii	"File error!\n"

errlen:
	.quad		( . - errmsg )	#

allokmsg:			# All OK message
	.ascii	"\nAll is OK - too hard to believe!\n"

alloklen:
	.quad		( . - allokmsg )

	.text
	.global _start
	
_start:
	MOV	$create_64,%rax	# create function, na końcu create musi być 0 w ciągu znaków
	MOV	$file_n,%rdi	# RDI points to file name
	MOV	$mode,%rsi	# mode of created file in RSI
	SYSCALL
	
	CMP	$0,%rax
	JL	error		# if RAX<0 then something went wrong

	MOV	%rax,file_h	# store file handle returned in EAX

	MOV	$10,	%rcx	#dopisujemy
petla:	
	PUSH 	%rcx
	
	MOV	$write_64,%rax	# write function
	MOV	file_h,%rdi	# file handle in RDI
	MOV	$txtline,%rsi	# RSI points to data buffer
	MOV	txtlen,%rdx	# bytes to be written
	SYSCALL

	POP	%rcx
	
	CMP	%rdx,%rax
	JNZ	error		# if RAX<>RDX then something went wrong
	
	LOOP petla
	
	MOV	$close_64,%rax	# close function
	MOV	file_h,%rdi	# file handle in RDI
	SYSCALL

	CMP	$0,%rax
	JL	error		# if RAX<0 then something went wrong

all_ok:
	MOV	$write_64,%rax	# write function
	MOV	$stderr,%rdi	# file handle in RDI
	MOV	$allokmsg,%rsi	# RSI points to All OK message
	MOV	alloklen,%rdx	# bytes to be written
	SYSCALL

	XOR	%rdi,%rdi
	JMP	theend

error:		#wypisujemy że coś jest nie tak
	MOV	$write_64,%rax	# write function
	MOV	$stderr,%rdi	# file handle in RDI
	MOV	$errmsg,%rsi	# RSI points to file error message
	MOV	errlen,%rdx	# bytes to be written, bez dolara odwołanie do wartości
	SYSCALL

	MOV	$errval,%rdi

theend:
	MOV	$exit_64,%rax	# exit program function
	SYSCALL

