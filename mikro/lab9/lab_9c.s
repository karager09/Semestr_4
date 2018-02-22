#----------------------------------------------------------
# Funkcja do programu lab_9c
#
# Compute Pi (Leibniz formula) using SSE instructions
#----------------------------------------------------------

#Leibniza- obliczamy przybliżenie PI, suma szeregu 1/1-1/3+1/5-1/7+1/9-.. = PI/4,   ale mnożymy przez 4, wiec liczniki są 4
#dzielimy na kawałki parzyste i nieparzystte
#czyli liczymy równolegle, 
#\ 4 \ -4	-liczniki
#\ 1 \ 3	-mianowniki
#\   \  	-roboczo
#\ 0 \ 0	-sumy
#\ 4 \ 4 	-o ile zwiększamy mian

	.data
	.align 16

denom:	
	.double	1.0, 3.0	# first & second denominators, mianowniki
numer:	
	.double	4.0, -4.0	# first & second numerators, licznik
add4:	
	.double	4.0, 4.0	# difference between denominators, wartości które dodajemy do mianowników
zero:	
	.double	0.0, 0.0	# sums starting values, na początku suma 0 i 0

	.text
	.type fun_a, @function
	.global fun_a

	#naraz mamy 8 rejesstrów więc operacje wykonujemy na wszystkich
	
fun_a:
	shr $1, %rdi		# two terms are computed in parallel
	inc %rdi		# half of iterations is enough

	movdqa	denom, %xmm5	# denominators to xmm5
	movdqa	numer, %xmm2	# numerators to xmm2
	movdqa	add4, %xmm3	# differences to xmm3
	movdqa	%xmm2, %xmm4	# numerators to xmm4
	movdqa	zero, %xmm1	# zeros to xmm1

next:
	divpd	%xmm5, %xmm2	# xmm2 /= xmm5
	addpd	%xmm2, %xmm1	# xmm1 += xmm2
	movdqa	%xmm4, %xmm2	# xmm2 = xmm4
	addpd	%xmm3, %xmm5	# xmm5 += xmm3

	dec %rdi
	jnz next

	haddpd	%xmm1, %xmm1	# horizontal sums of low & high parts
	movsd	%xmm1, %xmm0	# low part to xmm0

	ret			# that's all
	
	
#na kolosie SSE nie będzie, ale floaty mogą być

