#----------------------------------------------------------------
# Program lab_9a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#   to compile & link:  gcc -lm -o lab_9a lab_9a.s
#   to run: 		./lab_9a
#
#----------------------------------------------------------------

#funkcje do operacji na liczbach zmiennoprzec. musza być inne, bo zapis jest inny
#przy zapisuwaniu danych zmiennop. możliwa jest ich zmiana na całk.
#float-32 , double-64, 
#zmiennoprzecinkowe - 8 rejestrów w formie stosu, 
# ST(0) albo ST    <- pierwszy rejestr
#jak wpiszemy nastepną wartość to on jest ST(0) - wierzchołek stosu a to wyżej(niżej) to ST(1)
#

#pierwiastek kwadratowy na 2 sposoby:1) funkcja 2)newtona-raphson



	.data
i:				# loop counter
	.long		1
x:				# function argument
	.double		0.0
y:
	.double		0.0
sqr_a:				# function result
	.double		0.0
sqr_b:				# function result
	.double		0.0
two:				# constant
	.long		2
fmt_str:
	.asciz	"Square root of %lf = %.20lf\n"

	
	.text
	.global main
	
main:
	FINIT			# FPU initialization, zawsze musi być, inicjalizacja jednostki zmiennoprzec. wyszyszczenie danych, ustwienie trybu działania, zaokrąglenia itd.
next:
	FILDL	i		# i -> ST(0),	F-float, I-całkowita,L-long(double)(64 bitalbo S-short,całkowite(32bit)), wczytujemy i do ST
	FSTPL	x		# ST(0) -> x & pop from stack	,ST- store, P-czyścimy stos, x-dla niego liczymy pierwiastki, x na wierzchołku stosu
				#------------------------------
	FLDL	x		# function argument -> ST(0)
	FSQRT			# sqrt( ST(0) ) -> ST(0)		,liczymy pierwiastek, znajduje sie na wierzchołku stosu, zastępujemy poprzednią wartość
	FSTPL	sqr_a		# ST(0) -> sqr_a  & pop from stack	,zapisujemy do zmiennej o nazwie sqr_a
				#------------------------------
	FLDL	sqr_a		# load & display first result
	CALL	disp		#wyświetlamy
				#------------------------------
	FLDL	x		# first approximation (a0) -> ST(0), zaczynamy od x0=a0

iter:	FLDL	x		# function argument -> ST(0), ak in ST(1)		#metoda newtona raphsona,wczytujemy wartość x
	FDIV	%ST(1), %ST(0)	# ST(0)/ST(1) -> ST(0)    x/ak
	FADD	%ST(1), %ST(0)	# ST(0)+ST(1) -> ST(0)    ak+x/ak
	FIDIVL	two		# ST(0)/two -> ST(0)      (ak+x/ak)/2, nie możemy korzystać za stałych, musimy ze zmiennych o danej wartości
	FCOMI	%ST(1)		# ST(1) ? ST(0)           ak ? ak+1, porównanie, jak to samo, to znaczy że mamy dokładny wynik, ustawiamy flage
	FSTP	%ST(1)		# ST(0) -> ST(1) & pop from stack, zawaartość wierzchołku stosu przenosimy do tego niżej z jednoczenym usunięciem wierzchołka stosu
	JNZ	iter		# test of convergence, jak coś to skaczemy

	FSTPL	sqr_b		# ST(0) -> sqr_b & pop from stack,	zapamiętujemy
				#------------------------------FILDL	i
	FLDL	sqr_b		# load & display second result
	CALL	disp

	INCL	i		# next argument
	CMPL	$10, i		# enough ?
	JBE	next
				#------------------------------
	mov $0, %rdi		# the end
	CALL	exit
	

	.type	disp, @function	# printf( fmt_str, x, ST(0) )
disp:
	FSTPL 	y		# store number in memory
	movq	x, %xmm0	#jednostka SSE, xmm0 do xmm7, zeby wykorzystaaac do printfa, tam maja być liczby zmiennoprzecinkowe
	movq	y, %xmm1
	mov	$fmt_str, %rdi	# address of fmt_str, adres łańcucha formatująceego
	mov $2, %al		#w %al pokazujemy że 2 jednostki SSE zostały wykorzystane
	CALL	printf
	RET

