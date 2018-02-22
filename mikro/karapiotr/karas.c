#include <stdio.h>


unsigned long fun(unsigned long a, int b, int * pcs, int * count); 



int main(){


unsigned long a = 10;   // w notacji bitowej 1010
int b = 2;					//dla b=2 mnozymy
int pos = 0;
int count = 0;


	unsigned long wynik = fun(a,b,&pos,&count);
	printf("Param: %ld, %d\nWyniki: %ld, %d, %d\n",a,b,wynik,pos,count);


return 0;
}