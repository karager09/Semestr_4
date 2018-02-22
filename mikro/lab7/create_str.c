#include <stdio.h>

//tworzymy kolejne znaki  "A,B,C"  dla 3,"A"

char * create_str(char * buf, int n, int c);


void main( void )
{
		char buf[10];
		printf("%s\n",create_str(buf,4,'a'));

}