#include <stdio.h>


unsigned long int check_tab(int * tab, int n, int * max);


int main(){

	//int tab[12] = {6,4,3,5,3,7,7,7,3,3,63,3};
	int tab[12] = {1,2,3,3,3,4,4,4,4,5,5,0};
	int a=-1;	
	unsigned long int wynik = check_tab(tab,12,&a);
	printf("%ld, %d\n",wynik, a);

	//printf("%d\n",wynik % 2);
 

return 0;
}
