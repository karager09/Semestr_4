//---------------------------------------------------------------
// Program lab_9c - Asemblery Laboratorium IS II rok
//
// To compile&link: gcc -lm -o lab_9c lab_9c.c lab_9c.s
// To run:          ./lab_9c
//
//--------------------------------------------------------------- 

#include <stdio.h>
#include <sys/time.h>
#include <math.h>

#define LOG_OF_ITERATIONS	8


double fun_a( long long iter );		// function in lab_9c.s

double fun_c( long long iter )
{
	double sum = 0.0;
	double denominator = 1.0;
	double numerator = 4.0;
	double temp;
	long long counter = 0;

	while (counter < iter ) {
		temp = numerator;
		temp /= denominator;
		sum += temp;
		denominator += 2;
		numerator = -numerator;
		counter++;
	}
	return sum;
}


int main()
{
	long long iterations;
	int i;
	struct timeval t1, t2;
	double	elapsed;

	gettimeofday( &t1, NULL );
	for( i = 1; i <= LOG_OF_ITERATIONS; i++ )
	{
		iterations = pow( 10.0, i );
		printf("[C]   %12ld iterations - value = %19.17lf\n", iterations, fun_c( iterations ) );
	
	}
	gettimeofday( &t2, NULL );
	elapsed = ( t2.tv_sec - t1.tv_sec ) * 1000.0 + ( t2.tv_usec - t1.tv_usec ) / 1000.0;
	printf( "Time = %10.4lf ms\n", elapsed );

	gettimeofday( &t1, NULL );
	for( i = 1; i <= LOG_OF_ITERATIONS; i++ )
	{
		iterations = pow( 10, i );
		printf("[ASM] %12ld iterations - value = %19.17lf\n", iterations, fun_a( iterations ) );
		
	}
	gettimeofday( &t2, NULL );
	elapsed = ( t2.tv_sec - t1.tv_sec ) * 1000.0 + ( t2.tv_usec - t1.tv_usec ) / 1000.0;
	printf( "Time = %10.4lf ms\n", elapsed );

	return 0;
}

