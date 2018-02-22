#include <stdlib.h>
#include <stdio.h>

long long max_1_ind(long long *tab, long long n, long long *even_count, long long *neg_count);

int main(){
	long long tab[7] = { 2, -1, -3, 4, 5, -6, 7 };
	long long *a = malloc(sizeof(long long));
	long long *b = malloc(sizeof(long long));
	
	int result = max_1_ind(tab, 7, a, b);
	
	printf("Ile liczb parzystych: %lld \nIle liczb ujemnych: %lld \nNajwiecej jedynek ma element o indeksie: %d \n", *a, *b, result);
	
	free(a);
	free(b);

	return 0;
}
