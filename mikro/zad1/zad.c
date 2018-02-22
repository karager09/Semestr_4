#include <stdlib.h>
#include <stdio.h>


unsigned int check_tab(int *tab, int n, int* max);

int main(void) {
	int tab[10] = {63,1,2,3,4,5,6,7,8,9};
	
	int *max = malloc(sizeof(int));
	unsigned int result = check_tab(tab, 10, max);
	printf("%d\n%d\n", result, *max);
    //printf("%lu\n", check_div(10,10,1));

    return 0;
}