#include <stdio.h>




char * generate_str( char * s, int c, int n, int inc);

int main(){
	
	char buf[20];
	char buf2[20];
	printf("Argumenty: %d, %d, %d : \"%s\"\n",'a',5,0,generate_str(buf,'a',5,0));
	printf("Argumenty: %d, %d, %d : \"%s\"\n",'c',7,4,generate_str(buf2,'c',7,4));





}
