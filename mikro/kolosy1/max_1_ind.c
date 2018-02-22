#include <stdio.h>
#include <stdlib.h>



long max_1_ind(
	long * tab,
	long n,
	long * even_count,
	long * neg_count
	);


int main(){

	long tab[7] = {1,2,3,4,5,-6,-7};
	long *a= malloc(sizeof(long));
	long *b= malloc(sizeof(long));

	long max = max_1_ind(tab, 7, a, b);
	printf("%ld, %ld, %ld\n",*a ,*b ,max);


return 0;
}
